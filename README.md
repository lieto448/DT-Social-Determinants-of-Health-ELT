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

### **1.1 Dátová architektúra**

#### **ERD diagram**
Surové dáta sú usporiadané v relačnom modeli, ktorý je znázornený na **entitno-relačnom diagrame (ERD)**:
