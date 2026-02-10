# DT-Social-Determinants-of-Health-ELT

---
## **1. Úvod a popis zdrojových dát**
V tomto príklade analyzujeme rôzne dáta o faktoroch zdravia, populáciu U.S.A, zvyky a správanie. Napríklad:
- vzdialenosť od obchodov,
- či domácnosť vlastní,
- BMI,
- emocinálna stabilita
  
Zdrojové dáta pochádzajú z Snowflake marketplace https://app.snowflake.com/marketplace/listing/GZT0ZSR7MW2/analyticsiq-social-determinants-of-health?originTab=provider&providerName=AnalyticsIQ&profileGlobalName=GZT0ZSR7MV5

Väčšina premmenných výuživa škalú **od 1 do 7**.
napr.
- `stress` 7 je indikuje veľkú stresovú záťaž
- `grassfed_beef` 5 indikuje jemne nadpriemernú preferenciu pre hovädzie krmené trávou  

Premenné majú rôzne predpony pre kategórie

Component,Meaning,Type,Description
OS_,On-Surface,Prefix,"Core demographics (Age, Gender, etc.)"
HS_,Health Status,Prefix,Health conditions and clinical propensities
INS_,Insurance,Prefix,"Coverage types (Medicaid, Private, etc.)"
_Z4,ZIP+4,Suffix,Data is modeled at the 9-digit ZIP level

Účelom ELT procesu bolo tieto dáta pripraviť, transformovať a sprístupniť pre viacdimenzionálnu analýzu.

---



## **2 Dimenzionálny model**

V ukážke bola navrhnutá **schéma hviezdy (star schema)** podľa Kimballovej metodológie, ktorá obsahuje 1 tabuľku faktov **`fact_household`**, ktorá je prepojená s nasledujúcimi  dimenziami:
- **dim_diet**: Obsahuje podrobné informácie o trendoch v stravovaní.
- **dim_finance**: Obsahuje stabilita, zaťaženie, poistenie a investície.
- **dim_groceries**: Zahrňuje informácie o typov potravín , frekvenciu nákupov, vzdialenosti a preferencie obchodov.
- **dim_habbits**: Obsahuje zdrávé, nezdravé a neutrálne správanie.
- **dim_occupation**: Obsahuje informácie o zamestnaní.
- **dim_wellness**: Skóre fyzického aj mentálneho zdravia.
- **dim_home_enviroment** : Popisuje všetko čo sa nachádza v domácnosti ako psy, mačky, vek domu, počet aut

![star schema](https://github.com/lieto448/DT-Social-Determinants-of-Health-ELT/blob/main/sdoh_star_schema_fix.png)

## **3 Príklad kódu** 
```sql
CREATE OR REPLACE TABLE dim_home_enviroment AS 
SELECT
PRIMARY KEY (home_id),
s.aiq_hhid AS household_id,
   s.aiq_home_age AS home_age , 
   s.auto_age,
   DENSE_RANK() OVER (ORDER BY home_age DESC) AS home_rank,
   s.number_of_autos, 
   s.aiq_children_in_hh_v2 AS children_in_hh,
   s.marital_status,
   s.lt_dog_owner, 
   s.lt_cat_owner, 
   s.lt_pet_owner, 
   s.generations_in_hh, 
FROM sdoh_extarct s;
```

## **4 Vizualizácia dát**

![dashboard](https://github.com/lieto448/DT-Social-Determinants-of-Health-ELT/blob/main/sdoh_dashboard.png)

### Grafy

```sql
// Štáty a organické jedlo
SELECT 
    fact.state, 
    COUNT(fact.household_id) AS organic_loyalist_count
FROM fact_household fact
JOIN dim_groceries g ON fact.household_id = g.household_id
WHERE g.organic_food = 7
GROUP BY fact.state
ORDER BY organic_loyalist_count DESC;



// Stress a vzdelanie

SELECT 
    o.education, 
    AVG(w.hw_stress_v2) AS avg_stress_score,
    COUNT(o.household_id) AS sample_size
FROM dim_occupation o
JOIN dim_wellness w ON o.household_id = w.household_id
GROUP BY o.education;

// BMI a frekvencia nákupov

SELECT 
    g.grocery_trips, 
    AVG(d.hw_bmi) AS average_bmi,
    //COUNT(g.household_id) AS household_count
FROM dim_groceries g
JOIN dim_diet d ON g.household_id = d.household_id
WHERE g.grocery_trips IS NOT NULL 
  AND d.hw_bmi IS NOT NULL
GROUP BY g.grocery_trips;
```

# _Slavomír Hriňa_



