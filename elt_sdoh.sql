USE DATABASE GORILLA_DB;
USE WAREHOUSE GORILLA_WH;

CREATE SCHEMA sdoh_staging;
USE SCHEMA sdoh_staging;

CREATE OR REPLACE STAGE sdoh_stage;


CREATE OR REPLACE TABLE sdoh_extarct AS
SELECT * FROM SOCIAL_DETERMINANTS_OF_HEALTH.PUBLIC.sdoh_sample;

SELECT * FROM sdoh_extarct;

COPY INTO @sdoh_stage
FROM sdoh_extarct;

SHOW COLUMNS IN sdoh_extarct;

CREATE OR REPLACE TABLE staging_finance(
    risktaking INT,
    planning INT,
    impulse_control INT,
    organization INT,
    invest_actvive STRING
);





CREATE OR REPLACE TABLE staging_wellness(
    scr_wellness INT,
    emotional_stabilty INT,
    hw_sleep INT,
    hw_stress INT,
    lt_exercise INT
);


CREATE OR REPLACE TABLE staging_habbits(
    food_delivery_service INT,
    smartphone_iphone_scale INT,
    smartphone_andriod_scale INT,
    smartphone_none_scale INT,
    hw_alcohol INT,
    smoking_cigars INT,
    smoking_hookah INT,
    hw_smoking INT,
    hw_urgent_care_visits INT
);

CREATE OR REPLACE TABLE staging_home_enviroment(
    home_age INT,
    auto_age INT,
    number_of_autos INT,
    children_in_hh INT,
    marital_status STRING,
    lt_dog_owner INT,
    lt_cat_owner INT,
    lt_pet_owner INT,
    generations_in_hh INT
);

CREATE OR REPLACE TABLE staging_occupation(
    hw_job_satisf INT,
    employment_stability INT,
    job_seeker STRING,
    education STRING,
    lt_career_improvement INT
);

CREATE OR REPLACE TABLE staging_groeceries (
  inmarket_aldi INT,
  distance_aldi INT,
  inmarket_billo_winndixie INT,
  inamrket_costco INT,
  distance_costco INT,
  inmarket_h_e_b INT,
  inmarket_kroger INT,
  distance_kroger INT,
  imarket_meijer INT,
  inmarket_publix INT,
  distance_publix INT,
  inmarket_safeway INT,
  distance_safeway INT,
  inmarket_samsclub INT,
  distance_samsclub INT,
  inmarket_sprouts INT,
  distance_sprouts INT,
  inmarket_traderjoes INT,
  distance_traderjoes INT,
  inmarket_wholefoods INT,
  farmers_mkt INT,
  organic_food INT,
  trips INT
  );

  CREATE OR REPLACE TABLE staging_diet (
  hw_bmi INT ,
  hw_diet INT ,
  cagefree_eggs INT ,
  fake_meat_alt INT ,
  freerange_chicken INT ,
  grassfed_beef INT ,
  vegetarian INT ,
  junk_diet INT ,
  vegan INT 
);


CREATE OR REPLACE TABLE staging_wellness(
    scr_wellness INT,
    emotional_stabilty INT,
    hw_sleep INT,
    hw_stress INT,
    lt_exercise INT
);

CREATE OR REPLACE TABLE dim_finance AS 
SELECT
s.aiq_hhid AS household_id,
    s.os_risktaking_fin::INT AS finance_risktaking,
  s.os_fin_planning::INT AS finance_planning,
  s.os_fin_impcontrol::INT AS finance_impuls_control,
  s.os_fin_organization::INT AS finance_organization,
  s.invest_active
FROM sdoh_extarct s;

CREATE OR REPLACE TABLE dim_wellness AS 
SELECT
s.aiq_hhid AS household_id,
   s.scr_wellness, 
   s.os_emotion AS emotional_stability, 
   s.hw_sleep_v3, 
   s.hw_stress_v2, 
   s.lt_exercise
FROM sdoh_extarct s;

CREATE OR REPLACE TABLE dim_home_enviroment AS 
SELECT
s.aiq_hhid AS household_id,
   s.aiq_home_age AS home_age , 
   s.auto_age, 
   s.number_of_autos, 
   s.aiq_children_in_hh_v2 AS children_in_hh,
   s.marital_status,
   s.lt_dog_owner, 
   s.lt_cat_owner, 
   s.lt_pet_owner, 
   s.generations_in_hh, 
FROM sdoh_extarct s;

CREATE OR REPLACE TABLE dim_habbits AS 
SELECT
s.aiq_hhid AS household_id,
  s.lt_food_delivery_service_v2 AS lt_food_delivery_service, 
  s.smartphone_iphone_scale, 
  s.smartphone_android_scale, 
  s.smartphone_none_scale, 
  s.hw_alcohol_v2 AS hw_alcohol, 
  s.hw_smoking_cigars_sc, 
  s.hw_smoking_hookah_sc, 
  s.hw_smoking, 
  s.hw_er_visits_sc, 
  s.hw_urgent_care_visits_sc 
FROM sdoh_extarct s;

CREATE OR REPLACE TABLE dim_groceries AS 
SELECT
s.aiq_hhid AS household_id,
  s.inmarket_aldi, 
  s.distanceiq_aldi, 
  s.inmarket_bilo_winndixie, 
  s.inmarket_costco, 
  s.distanceiq_costco, 
  s.inmarket_h_e_b, 
  s.inmarket_kroger, 
  s.distanceiq_kroger , 
  s.inmarket_meijer, 
  s.inmarket_publix, 
  s.distanceiq_publix, 
  s.inmarket_safeway, 
  s.distanceiq_safeway, 
  s.inmarket_samsclub, 
  s.distanceiq_sams AS distance_samsclub, 
  s.inmarket_sprouts, 
  s.distanceiq_sprouts, 
  s.inmarket_traderjoes, 
  s.distanceiq_traderjoe AS distance_traderjoes, 
  s.inmarket_whole_foods, 
  s.grocery_farmers_mkt, 
  s.grocery_organic AS organic_food, 
  s.grocery_trips
FROM sdoh_extarct s;

CREATE OR REPLACE TABLE dim_diet AS 
SELECT
s.aiq_hhid AS household_id,
s.hw_bmi, 
s.hw_diet, 
s.diet_cagefree_eggs, 
s.diet_fake_meat_alt, 
s.diet_freerange_chicken, 
s.diet_grassfed_beef, 
s.diet_vegetarian, 
s.hw_junk_diet, 
s.diet_vegan
FROM sdoh_extarct s;

CREATE OR REPLACE TABLE dim_occupation AS 
SELECT
s.aiq_hhid AS household_id,
s.hw_job_satis, 
s.aiq_employment AS employment_stability, 
s.job_seeker, 
s.aiq_education_v2 AS education, 
s.lt_career_improvement_v2 AS lt_career_improvement
FROM sdoh_extarct s;

CREATE OR REPLACE TABLE fact_household AS
SELECT
    s.aiq_hhid AS household_id,
    s.city, 
    s.state, 
    s.zip5 AS zipcode, 
    s.phone, 
    s.em_email AS email, 
    s.county
FROM sdoh_extarct s
JOIN dim_diet d ON s.aiq_hhid = d.household_id
JOIN dim_finance f ON s.aiq_hhid = f.household_id
JOIN dim_groceries g ON s.aiq_hhid = g.household_id
JOIN dim_habbits h ON s.aiq_hhid = h.household_id
JOIN dim_occupation o ON s.aiq_hhid = o.household_id
JOIN dim_wellness w ON s.aiq_hhid = w.household_id;



DROP TABLE IF EXISTS staging_finance;
DROP TABLE IF EXISTS staging_diet;
DROP TABLE IF EXISTS staging_groceries;
DROP TABLE IF EXISTS staging_habbits;
DROP TABLE IF EXISTS staging_occupation;
DROP TABLE IF EXISTS staging_wellness;