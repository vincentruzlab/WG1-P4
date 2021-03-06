#SEISMIC AP - Variable Conversion
#### Setup ####
# Load packages and data
if (!require("pacman")) install.packages("pacman")
library(pacman)
pacman::p_load("tidyverse", "psych")

# Functions and settings ####
# Use dplyr for 'select'
select <- dplyr::select

# Load FULL MERGED Dataframe ####
df_full <- read.csv("~/Box Sync/LSAP_LRDC/Research Projects/SEISMIC/AP/SEISMIC_AP/2191_MATH_FULL.csv")     
names(df_full)                        # TOTAL N = 670191

#### CLEANING ####
# (STILL MISSING: gpao, begin_term_cum_gpa, instructor_name, apyear)
## STABLE - Student Level ####
df_std <- df_full %>%
  # Rename variables
  mutate(st_id = EMPLID_H) %>%
  mutate(firstgen = recode(FIRST_GENERATION_DESCR, "First Generation" = 1, "Not First Generation" = 0, "Unknown" = 0)) %>%
  mutate(ethniccode = ETHNIC_GROUP_CD) %>%
  mutate(ethniccode_cat = recode(as.factor(ETHNIC_GROUP_CD), "HISPA" = 1, "BLACK" = 1, "AMIND" = 1, "PACIF" = 1, "ASIAN" = 2, "WHITE" = 0)) %>%
  mutate(urm = recode(ETHNIC_GROUP_CD, "HISPA" = 1, "BLACK" = 1, "AMIND" = 1, "PACIF" = 1, "ASIAN" = 0, "WHITE" = 0)) %>%
  mutate(gender = recode(GENDER_CD, "F"=1, "M"=0, "m"=0, "U" = 2)) %>%
  mutate(female = recode(GENDER_CD, "F"=1, "M"=0, "m"=0, "U" = 2)) %>%
  mutate(famincome = abs(AGI)) %>%
  mutate(lowincomeflag = if_else(is.na(AGI), 0,
                                if_else(AGI <= 46435, 1,0))) %>%
  mutate(transfer = recode(FIRST_TIME_FRESHMAN, "N"=1, "Y"=0)) %>%
  mutate(transfer_cred = TOT_TRNSFR_CREDITS) %>%
  mutate(international = if_else(CITIZENSHIP_STATUS_DESCR == "U.S. Citizen", 0, 1)) %>%
  mutate(ell = if_else(TOEFL_SCORE > 0, 0, 1)) %>%
  mutate(us_hs = if_else(is.na(HS_GPA), 0, 1)) %>%
  separate(as.character("START_TRM_CD"), c("st_YEAR", "st_SEMESTER"), 3, remove = FALSE) %>%
  separate(as.character("st_YEAR"), c("st_DEC", "st_YEAR"), 1) %>%
  mutate(cohort = as.numeric(st_YEAR)) %>%
  mutate(cohort = ifelse(cohort >= 20, cohort + 1900, cohort + 2000)) %>%
  mutate(cohort_2013 = ifelse(cohort == 2013, 1,0)) %>%
  mutate(cohort_2014 = ifelse(cohort == 2014, 1,0)) %>%
  mutate(cohort_2015 = ifelse(cohort == 2015, 1,0)) %>%
  mutate(cohort_2016 = ifelse(cohort == 2016, 1,0)) %>%
  mutate(cohort_2017 = ifelse(cohort == 2017, 1,0)) %>%
  mutate(cohort_2018 = ifelse(cohort == 2018, 1,0)) %>%
 # mutate(apyear = cohort-1) %>%
  mutate(englsr = if_else(ACT_HIGH_ENGL == 36, 800,
if_else(ACT_HIGH_ENGL == 35, 780,
if_else(ACT_HIGH_ENGL == 34, 760,
if_else(ACT_HIGH_ENGL == 33, 740,
if_else(ACT_HIGH_ENGL == 32,	720,
if_else(ACT_HIGH_ENGL == 31,	710,
if_else(ACT_HIGH_ENGL == 30,	700,
if_else(ACT_HIGH_ENGL == 29,	680,
if_else(ACT_HIGH_ENGL == 28,	660,
if_else(ACT_HIGH_ENGL == 27,	640,
if_else(ACT_HIGH_ENGL == 26,	610,
if_else(ACT_HIGH_ENGL == 25,	590,
if_else(ACT_HIGH_ENGL == 24,	580,
if_else(ACT_HIGH_ENGL == 23,	560,
if_else(ACT_HIGH_ENGL == 22,	540,
if_else(ACT_HIGH_ENGL == 21,	530,
if_else(ACT_HIGH_ENGL == 20,	520,
if_else(ACT_HIGH_ENGL == 19,	510,
if_else(ACT_HIGH_ENGL == 18,	500,
if_else(ACT_HIGH_ENGL == 17,	470,
if_else(ACT_HIGH_ENGL == 16	, 430,
if_else(ACT_HIGH_ENGL == 15	, 400,
if_else(ACT_HIGH_ENGL == 14	, 360,
if_else(ACT_HIGH_ENGL == 13	, 330,
if_else(ACT_HIGH_ENGL == 12,	310,
if_else(ACT_HIGH_ENGL == 11,	280,
if_else(ACT_HIGH_ENGL == 10,	260, NaN )))))))))))))))))))))))))))) %>%
  mutate(englsr = ifelse(SAT_HIGH_VERBAL %in% NA, englsr, SAT_HIGH_VERBAL)) %>%
  mutate(mathsr = if_else(ACT_HIGH_MATH == 36, 800,
                          if_else(ACT_HIGH_MATH == 35, 780,
if_else(ACT_HIGH_MATH == 34, 760,
if_else(ACT_HIGH_MATH == 33, 740,
if_else(ACT_HIGH_MATH == 32,	720,
if_else(ACT_HIGH_MATH == 31,	710,
if_else(ACT_HIGH_MATH == 30,	700,
if_else(ACT_HIGH_MATH == 29,	680,
if_else(ACT_HIGH_MATH == 28,	660,
if_else(ACT_HIGH_MATH == 27,	640,
if_else(ACT_HIGH_MATH == 26,	610,
if_else(ACT_HIGH_MATH == 25,	590,
if_else(ACT_HIGH_MATH == 24,	580,
if_else(ACT_HIGH_MATH == 23,	560,
if_else(ACT_HIGH_MATH == 22,	540,
if_else(ACT_HIGH_MATH == 21,	530,
if_else(ACT_HIGH_MATH == 20,	520,
if_else(ACT_HIGH_MATH == 19,	510,
if_else(ACT_HIGH_MATH == 18,	500,
if_else(ACT_HIGH_MATH == 17,	470,
if_else(ACT_HIGH_MATH == 16	, 430,
if_else(ACT_HIGH_MATH == 15	, 400,
if_else(ACT_HIGH_MATH == 14	, 360,
if_else(ACT_HIGH_MATH == 13	, 330,
if_else(ACT_HIGH_MATH == 12,	310,
if_else(ACT_HIGH_MATH == 11,	280,
if_else(ACT_HIGH_MATH == 10,	260, NaN )))))))))))))))))))))))))))) %>%
  mutate(mathsr = ifelse(SAT_HIGH_MATH %in% NA, mathsr, SAT_HIGH_MATH)) %>%
  mutate(hsgpa = HS_GPA) %>%
  # Select only common-named variables used in analysis
  select(st_id, firstgen:hsgpa) %>%
  # Remove any duplicate cases
  distinct()

#write.csv(df_std, file = "SEISMIC_AP_STUDENT_CLEAN.csv")          #UNIQUE N = 22976

#### Course Level ####
df_crs <- df_full %>%
  # Rename variables
  mutate(st_id = EMPLID_H) %>%
  mutate(crs_sbj = SUBJECT_CD) %>%
  mutate(crs_catalog = CATALOG_NBR) %>%
  mutate(crs_name	= CLASS_TITLE) %>%
  mutate(numgrade = ifelse(COURSE_GRADE_CD %in% c("G", "H", "I", "N", "NC", "NG", "R", "S", "U"), NA, 
                           GRADE_POINTS/UNITS_TAKEN)) %>%
  mutate(numgrade_w = if_else(COURSE_GRADE_CD == "W", 1, 0)) %>%
  mutate(crs_retake = REPEAT_CD) %>%
  separate(as.character("TERM_CD"), c("crs_YEAR", "crs_SEMESTER"), 3, remove = FALSE) %>%
  separate(as.character("crs_YEAR"), c("crs_DEC", "crs_YEAR"), 1) %>% 
  mutate(crs_term = as.numeric(crs_YEAR)) %>%
  mutate(crs_term_sem = as.numeric(crs_SEMESTER)) %>%
  mutate(crs_term = ifelse(crs_term >= 20, crs_term + 1900, crs_term + 2000)) %>%
  mutate(summer_crs = if_else(endsWith(as.character(TERM_CD),"7"), 1, 0)) %>%
  mutate(TERM_REF = START_TRM_CD-TERM_CD) %>%
  separate(as.character("START_TRM_CD"), c("st_YEAR", "st_SEMESTER"), 3, remove = FALSE) %>%
  separate(as.character("st_YEAR"), c("st_DEC", "st_YEAR"), 1) %>%
  mutate(enrl_from_cohort = if_else(st_SEMESTER == "1" & TERM_REF == "0", 1,
                                    if_else(TERM_REF == -3, 1.5,
                                            if_else(TERM_REF == -6, 1.66,
                                                    if_else(TERM_REF == -10, 2,
                                                            if_else(TERM_REF == -13, 2.5,
                                                                    if_else(TERM_REF == -16, 2.66,
                                                                            if_else(TERM_REF == -20, 3,
                                                                                    if_else(TERM_REF == -23, 3.5,
                                                                                            if_else(TERM_REF == -26, 3.66,
                                                                                                    if_else(TERM_REF == -30, 4,
                                                                                                            if_else(TERM_REF == -33, 4.5,
                                                                                                                    if_else(TERM_REF == -36, 4.66, 
                                                                                                                            if_else(st_SEMESTER == "4" & TERM_REF == "0", 1,
                                                                                                                                    if_else(TERM_REF == -3, 1.5,
                                                                                                                                            if_else(TERM_REF == -7, 1.66,
                                                                                                                                                    if_else(TERM_REF == -10, 2,
                                                                                                                                                            if_else(TERM_REF == -13, 2.5,
                                                                                                                                                                    if_else(TERM_REF == -17, 2.66,
                                                                                                                                                                            if_else(TERM_REF == -20, 3,
                                                                                                                                                                                    if_else(TERM_REF == -23, 3.5,
                                                                                                                                                                                            if_else(TERM_REF == -27, 3.66,
                                                                                                                                                                                                    if_else(TERM_REF == -30, 4,
                                                                                                                                                                                                            if_else(TERM_REF == -33, 4.5,
                                                                                                                                                                                                                    if_else(TERM_REF == -37, 4.66, 
                                                                                                                                                                                                                            if_else(st_SEMESTER == "7" & TERM_REF == "0", 1,
                                                                                                                                                                                                                                    if_else(TERM_REF == -4, 1.5,
                                                                                                                                                                                                                                            if_else(TERM_REF == -7, 1.66,
                                                                                                                                                                                                                                                    if_else(TERM_REF == -10, 2,
                                                                                                                                                                                                                                                            if_else(TERM_REF == -14, 2.5,
                                                                                                                                                                                                                                                                    if_else(TERM_REF == -17, 2.66,
                                                                                                                                                                                                                                                                            if_else(TERM_REF == -20, 3,
                                                                                                                                                                                                                                                                                    if_else(TERM_REF == -24, 3.5,
                                                                                                                                                                                                                                                                                            if_else(TERM_REF == -26, 3.66,
                                                                                                                                                                                                                                                                                                    if_else(TERM_REF == -30, 4,
                                                                                                                                                                                                                                                                                                            if_else(TERM_REF == -34, 4.5,
                                                                                                                                                                                                                                                                                                                    if_else(TERM_REF == -36, 4.66, NaN ))))))))))))))))))))))))))))))))))))) %>%
  #mutate(gpao = ?) %>%
  #mutate(begin_term_cum_gpa = ?) %>%
  mutate(crs_credits = UNITS_TAKEN) %>%
  #mutate(instructor_name = NA) %>%
  mutate(crs_component= CLASS_COMPONENT_DESCR) %>%
  mutate(class_number	= CLASS_NBR) %>%
  mutate(current_major = ACADEMIC_SUBPLAN_DESCR) %>%
  # Select only common-named variables used in analysis
  select(st_id, crs_sbj:current_major)

write.csv(df_crs, file = "SEISMIC_AP_COURSES_CLEAN.csv")

# By Course (Taking only First Attempt) ####
# Bio
df_crs_bio1 <- df_crs %>%
  filter(crs_sbj == "BIOSC" & (crs_catalog == "0150")) %>% # | crs_catalog == "0715")) %>%
  #Only first time taking course
  group_by(st_id, crs_catalog) %>% 
  arrange(crs_term, .by_group= TRUE) %>%
  mutate(crs_retake_num = row_number()) %>%
  filter(crs_retake_num == 1)

df_crs_bio2 <- df_crs %>%
  filter(crs_sbj == "BIOSC" & (crs_catalog == "0160")) %>% # | crs_catalog == "0716")) %>%
  #Only first time taking course
  group_by(st_id, crs_catalog) %>% 
  arrange(crs_term, .by_group= TRUE) %>%
  mutate(crs_retake_num = row_number()) %>%
  filter(crs_retake_num == 1)

#Chem
df_crs_chem1 <- df_crs %>%
  filter(crs_sbj == "CHEM" & (crs_catalog == "0110")) %>% # | crs_catalog == "0710")) %>%
  #Only first time taking course
  group_by(st_id, crs_catalog) %>% 
  arrange(crs_term, .by_group= TRUE) %>%
  mutate(crs_retake_num = row_number()) %>%
  filter(crs_retake_num == 1) 

df_crs_chem2 <- df_crs %>%
  filter(crs_sbj == "CHEM" & (crs_catalog == "0120")) %>% # | crs_catalog == "0720")) %>%
  #Only first time taking course
  group_by(st_id, crs_catalog) %>% 
  arrange(crs_term, .by_group= TRUE) %>%
  mutate(crs_retake_num = row_number()) %>%
  filter(crs_retake_num == 1) 

#Phys
df_crs_phys1 <- df_crs %>%
  filter(crs_sbj == "PHYS" & (crs_catalog == "0174")) %>% # | crs_catalog == "0475")) %>%
  #Only first time taking course
  group_by(st_id, crs_catalog) %>% 
  arrange(crs_term, .by_group= TRUE) %>%
  mutate(crs_retake_num = row_number()) %>%
  filter(crs_retake_num == 1)

df_crs_phys2 <- df_crs %>%
  filter(crs_sbj == "PHYS" & (crs_catalog == "0175")) %>% # | crs_catalog == "0476")) %>%
  #Only first time taking course
  group_by(st_id, crs_catalog) %>% 
  arrange(crs_term, .by_group= TRUE) %>%
  mutate(crs_retake_num = row_number()) %>%
  filter(crs_retake_num == 1)

##### AP Level ####
# By course ####
# Bio
df_ap_bio <- df_full %>%
  mutate(st_id = EMPLID_H) %>%
  mutate(aptaker = ifelse(is.na(BY), 0, 1)) %>%
  mutate(eligible_to_skip = ifelse(BY >= 4 & !is.na(BY), 1, 0)) %>%
  mutate(eligible_to_skip_2 = ifelse(BY == 5 & !is.na(BY), 1, 0)) %>%
  mutate(tookcourse = ifelse(
    SUBJECT_CD == "BIOSC" & (CATALOG_NBR == "0150") & # | CATALOG_NBR == "0715") & 
      COURSE_GRADE_CD != "W", 1, 0)) %>%
  mutate(tookcourse_2 = ifelse(
    SUBJECT_CD == "BIOSC" & (CATALOG_NBR == "0160") & # | CATALOG_NBR == "0716") & 
      COURSE_GRADE_CD != "W", 1, 0)) %>%
  #mutate(apyear = ?) %>%
  mutate(apscore = as.numeric(BY)) %>%
  mutate(apscore_full = ifelse(is.na(BY), 0, BY)) %>%
  select(st_id, aptaker:apscore_full) %>%
  group_by(st_id) %>%
  summarize_at(vars(-group_cols()),max)

#Chem
df_ap_chem <- df_full %>%
  mutate(st_id = EMPLID_H) %>%
  mutate(aptaker = ifelse(is.na(CH), 0, 1)) %>%
  mutate(eligible_to_skip = ifelse(CH >= 3 & !is.na(CH), 1, 0)) %>%
  mutate(eligible_to_skip_2 = ifelse(CH == 5 & !is.na(CH), 1, 0)) %>%
  mutate(tookcourse = ifelse(
    SUBJECT_CD == "CHEM" & (CATALOG_NBR == "0110") & # | CATALOG_NBR == "0710") & 
      COURSE_GRADE_CD != "W", 1, 0)) %>%
  mutate(tookcourse_2 = ifelse(
    SUBJECT_CD == "CHEM" & (CATALOG_NBR == "0120") & # | CATALOG_NBR == "0720") & 
      COURSE_GRADE_CD != "W", 1, 0)) %>%
  #mutate(apyear = ?) %>%
  mutate(apscore = as.numeric(CH)) %>%
  mutate(apscore_full = ifelse(is.na(CH), 0, CH)) %>%
  select(st_id, aptaker:apscore_full) %>%
  group_by(st_id) %>%
  summarize_at(vars(-group_cols()),max)

#Phys
df_ap_phys <- df_full %>%
  mutate(st_id = EMPLID_H) %>%
  mutate(aptaker_CE = ifelse(is.na(PHCE), 0, 1)) %>%
  mutate(aptaker_CM = ifelse(is.na(PHCM), 0, 1)) %>%
  mutate(aptaker = ifelse(aptaker_CE == 1 | aptaker_CM == 1, 1, 0)) %>%
  mutate(eligible_to_skipCE = ifelse(PHCE == 5 & !is.na(PHCE), 1, 0)) %>%
  mutate(eligible_to_skipCM = ifelse(PHCM == 5  & !is.na(PHCM), 1, 0)) %>%
  mutate(eligible_to_skip = ifelse(eligible_to_skipCE == 1 | eligible_to_skipCM == 1, 1, 0)) %>%
  mutate(tookcourse = ifelse(
    SUBJECT_CD == "PHYS" & (CATALOG_NBR == "0174") & # | CATALOG_NBR == "0475") & 
      COURSE_GRADE_CD != "W", 1, 0)) %>%
  mutate(tookcourse_2 = ifelse(
    SUBJECT_CD == "PHYS" & (CATALOG_NBR == "0175") & # | CATALOG_NBR == "0476") & 
      COURSE_GRADE_CD != "W", 1, 0)) %>%
  #mutate(apyear = ?) %>%
  mutate(apscore = (pmax(PHCM, PHCE, na.rm = TRUE))) %>%
  mutate(apscore_full = ifelse(is.na(apscore), 0, apscore)) %>%
  select(st_id, PHCE, PHCM, aptaker:apscore_full) %>%
  group_by(st_id) %>%
  summarize_at(vars(-group_cols()),max)

#### Create Stacked Dataset #### 
# Bio (N=3090)
df_bio <- df_std %>%
  right_join(df_crs_bio2, by = "st_id") %>%
  full_join(df_crs_bio1, by = "st_id") %>%
  full_join(df_ap_bio, by = "st_id") %>%
  mutate(discipline = "BIO") %>%
  mutate(skipped_course = ifelse(tookcourse == 0 & tookcourse_2 == 1 & eligible_to_skip == 1, 1, 0)) %>%
  select(discipline, st_id:hsgpa, crs_sbj.x:current_major.x, crs_sbj.y:current_major.y, 
         aptaker, apscore, apscore_full, eligible_to_skip, 
         tookcourse, tookcourse_2, skipped_course)

#Chem (N=3019)
df_chem <- df_std %>%
  right_join(df_crs_chem2, by = "st_id") %>%
  full_join(df_crs_chem1, by = "st_id") %>%
  full_join(df_ap_chem, by = "st_id") %>%
  mutate(discipline = "CHEM") %>%
  mutate(skipped_course = ifelse(tookcourse == 0 & tookcourse_2 == 1 & eligible_to_skip == 1, 1, 0)) %>%
  select(discipline, st_id:hsgpa, crs_sbj.x:current_major.x, crs_sbj.y:current_major.y, 
         aptaker, apscore, apscore_full, eligible_to_skip, 
         tookcourse, tookcourse_2, skipped_course)

#Phys (N=1598)
df_phys <- df_std %>%
  right_join(df_crs_phys2, by = "st_id") %>%
  full_join(df_crs_phys1, by = "st_id") %>%
  full_join(df_ap_phys, by = "st_id") %>%
  mutate(discipline = "PHYS") %>%
  mutate(skipped_course = ifelse(tookcourse == 0 & tookcourse_2 == 1 & eligible_to_skip == 1, 1, 0)) %>%
  select(discipline, st_id:hsgpa, crs_sbj.x:current_major.x, crs_sbj.y:current_major.y, 
         aptaker, apscore, apscore_full, eligible_to_skip,
         tookcourse, tookcourse_2, skipped_course)

#Stacked data
df_clean <- rbind(df_bio, df_chem, df_phys)
df_clean <- df_clean %>%
  rename_at(vars(ends_with(".x")), 
            ~(str_replace(., ".x", "_2"))) %>%
  rename_at(vars(ends_with(".y")), 
            ~(str_replace(., ".y", ""))) %>%
  filter(crs_term <= 2018 | is.na(crs_term)) %>%
  filter(crs_term_2 <= 2018 | is.na(crs_term_2)) %>%
  mutate(apyear = if_else(discipline == "CHEM", cohort - 1, cohort)) 

rm(df_ap_bio, df_ap_chem, df_ap_phys, 
   df_bio, df_chem, df_phys, 
   df_crs_bio1, df_crs_bio2, df_crs_chem1, df_crs_chem2, df_crs_phys1, df_crs_phys2,
   df_crs, df_std)

write.csv(df_clean, file = "~/Box Sync/LSAP_LRDC/Research Projects/SEISMIC/AP/SEISMIC_AP/SEISMIC_AP_CLEAN.csv")
