
#' @import dplyr
#' @import readr
NULL

read_raw_data <- function(path) {
  read_delim(
    path, delim = "\t",
    col_types = cols(
      ConsumerID = "c",
      GrantID = "c",
      SiteID = "c",
      ReassessmentNumber_07 = "c",
      GenderSpec = "c",
      EthnicOtherSpec = "c",
      Other_UseSpec = "c",
      AD_P1Rel_OtherSpec_11 = "c",
      AD_P2Rel_OtherSpec_11 = "c",
      AD_P3Rel_OtherSpec_11 = "c",
      AD_P4Rel_OtherSpec_11 = "c",
      AD_P5Rel_OtherSpec_11 = "c",
      AD_P6Rel_OtherSpec_11 = "c",
      OtherHousingSpec = "c",
      OtherEnrolledSpec = "c",
      OtherEmploymentSpec = "c",
      WhoAdministered_OtherSpec = "c",
      OtherDischargeStatus = "c",
      Svc_TraumaSpecific = "c",

      InterviewDate = col_date(format = "%m/%d/%Y"),
      FirstReceivedServicesDate = col_date(format = "%m/%d/%Y"),
      DOB = col_date(format = "%m/%d/%Y"),
      GAFDate = col_date(format = "%m/%d/%Y"),
      DateBloodDrawn = col_date(format = "%m/%d/%Y"),
      DischargeDate = col_date(format = "%m/%d/%Y"),
      LastServiceDate = col_date(format = "%m/%d/%Y"),

      .default = "d"
    )
  ) %>%
    mutate(ConsumerID = stringr::str_replace_all(ConsumerID, "'", "")) %>%
    mutate_if(lubridate::is.Date, funs(if_else(lubridate::year(.) == 1869, as.Date(NA), .)))
}

create_derived_fields <- function(data) {
  data_with_intake_seq <- data %>%
    mutate(der_date = coalesce(InterviewDate, DischargeDate)) %>%
    group_by(ConsumerID) %>%
    arrange(ConsumerID, der_date, Assessment) %>%
    mutate(der_intake_seq_no = cumsum(Assessment == 600)) %>%
    ungroup

  vars <- c("BPressure_s", "BPressure_d", "Weight", "Height", "WaistCircum",
            "BreathCO", "Plasma_Gluc", "HgbA1c", "Lipid_TotChol",
            "Lipid_HDL", "Lipid_LDL", "Lipid_Tri")

  data_derived <- data_with_intake_seq %>%
    mutate_at(vars,
              funs(der = if_else(. < 0, NA_real_, .))) %>%
    rename(!!! setNames(paste0(vars, "_der"), paste0("der_", stringr::str_to_lower(vars)))) %>%
    mutate(
      der_bmi = round(der_weight / (der_height / 100) ^ 2, 1),
      der_age = age_years(DOB, der_date),
      der_bp_s_risk = if_else(der_bpressure_s > 130, "At risk", "Normal"),
      der_bp_d_risk = if_else(der_bpressure_d > 85, "At risk", "Normal"),
      der_bmi_risk = case_when(
        der_bmi < 25 ~ "Normal",
        der_bmi < 30 ~ "Overweight",
        der_bmi < 40 ~ "Obese",
        der_bmi >= 40 ~ "Extreme Obesity"
      ),
      der_breathco_risk = case_when(
        der_breathco <= 6 ~ "Normal",
        der_breathco <= 10 ~ "Light smoker",
        der_breathco > 10 ~ "Heavy smoker"
      ),
      der_hgba1c_risk = case_when(
        der_hgba1c < 5.7 ~ "Normal",
        der_hgba1c <= 6.4 ~ "Prediabetes",
        der_hgba1c > 6.4 ~ "Diabetes"
      ),
      der_plasma_gluc_risk = case_when(
        EightHour_Fast != 1 ~ NA_character_,
        der_plasma_gluc <= 99 ~ "Normal",
        der_plasma_gluc <= 125 ~ "Prediabetes",
        der_plasma_gluc > 125 ~ "Diabetes"
      ),
      der_lipid_hdl_risk = if_else(der_lipid_hdl < 40, "At risk", "Normal"),
      der_lipid_ldl_risk = if_else(der_lipid_ldl > 130, "At risk", "Normal"),
      der_lipid_tri_risk = if_else(der_lipid_tri > 150, "At risk", "Normal"),
      der_waist_circum_risk = if_else(
        (der_waistcircum > 102 & Gender == 1) | (der_waistcircum > 88 & Gender == 2),
        "At risk", "Normal"
      ),
      der_diabetes_risk = case_when(
        (der_hgba1c_risk == "Diabetes") | (der_plasma_gluc_risk == "Diabetes") ~ "Diabetes",
        (der_hgba1c_risk == "Prediabetes") | (der_plasma_gluc_risk == "Prediabetes") ~ "Prediabetes",
        (der_hgba1c_risk == "Normal") | (der_plasma_gluc_risk == "Normal") ~ "Normal"
      ),
      der_waist_cirum_in = round(der_waistcircum * 0.393701, 1),
      der_weight_lbs = round(der_weight * 2.20462),
      der_height_ft = round(der_height * 0.0328084),
      der_mechanical_risk_count =
        coalesce(der_bp_d_risk == "Normal", FALSE) +
        coalesce(der_bp_s_risk == "Normal", FALSE) +
        coalesce(der_bmi_risk == "Normal", FALSE) +
        coalesce(der_breathco_risk == "Normal", FALSE) +
        coalesce(der_waist_circum_risk == "Normal", FALSE),
      der_blood_risk_count =
        coalesce(der_diabetes_risk == "Normal", FALSE) +
        coalesce(der_lipid_hdl_risk == "Normal", FALSE) +
        coalesce(der_lipid_ldl_risk == "Normal", FALSE) +
        coalesce(der_lipid_tri_risk == "Normal", FALSE),
      der_mechanical_risk_na_count =
        is.na(der_bp_d_risk) +
        is.na(der_bp_s_risk) +
        is.na(der_bmi_risk) +
        is.na(der_breathco_risk) +
        is.na(der_waist_circum_risk),
      der_blood_risk_count_na =
        is.na(der_diabetes_risk) +
        is.na(der_lipid_hdl_risk) +
        is.na(der_lipid_ldl_risk) +
        is.na(der_lipid_tri_risk),
      der_aa_at_all = RaceBlack == 1,
      der_white_only =
        (HispanicLatino != 1) &
        (EthnicCentralAmerican != 1) &
        (EthnicCuban != 1) &
        (EthnicMexican != 1) &
        (EthnicPuertoRican != 1) &
        (EthnicSouthAmerican != 1) &
        (EthnicOther != 1) &
        (RaceBlack != 1) &
        (RaceAsian != 1) &
        (RaceNativeHawaiian != 1) &
        (RaceAlaskaNative != 1) &
        (RaceAmericanIndian != 1) &
        (RaceAlaskaNative != 1) &
        (RaceAmericanIndian != 1) &
        (RaceWhite == 1),
      der_hisp_at_all = HispanicLatino == 1,
      der_lgbt = (SexualIdentity %in% c(2, 3)) | (Gender == 3),
      der_women_only = Gender == 2,
      der_men_only = Gender == 1,
      der_age_55_p_only = der_age >= 55
    )

  data_derived %>%
    group_by(ConsumerID) %>%
    mutate(der_violence_trauma_only = 1 %in% ViolenceTrauma) %>%
    ungroup
}


#' Read NOMs data
#'
#' Read NOMs data extract and create derived fields
#'
#' @param path Path to the ExcelReport.xlsx file
#' @return Data frame with original data and derived fields
#' @examples
#' read_data("/path/to/folder/ExcelReport.xls")
#' @export
read_data <- function(path) {
  read_raw_data(path) %>%
    create_derived_fields
}


