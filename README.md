# 🏥 Hospital Encounters Analysis  

This project analyzes **hospital encounters** using SQL.  
It was completed as a **guided project on the Maven Analytics platform**.  

The dataset contains information about encounters, patients, payers, and medical procedures.  

The goal of this analysis is to answer key business and healthcare questions regarding **encounters, costs, payer coverage, and patient behavior**.  

---

## 📊 Dataset  

- **Source:** Maven Analytics (guided project dataset)  
- **Database used:** `hospital_db`  
- **Tables used:**
  - `encounters` – records of hospital encounters (start, stop, class, patient, payer, total claim cost, coverage)  
  - `procedures` – medical procedures performed (code, description, base cost)  
  - `payers` – insurance providers  
  - `patients` – patient information  

---

## 🔍 Analysis Questions  

### OBJECTIVE 1: Encounters Overview  

#### 1a. How many total encounters occurred each year?  
**Method:** Grouped encounters by year using `COUNT(id)`.  
**Answer:** Yearly encounter counts were retrieved.  

---

#### 1b. For each year, what percentage of all encounters belonged to each encounter class?  
**Method:** Counted encounters per class per year, divided by total yearly encounters.  
**Classes considered:** ambulatory, outpatient, wellness, urgent care, emergency, inpatient.  
**Answer:** Percentage distribution of encounter classes was calculated per year.  

---

#### 1c. What percentage of encounters were over 24 hours vs under 24 hours?  
**Method:** Used `TIMESTAMPDIFF(HOUR, start, stop)` and compared against 24 hours.  
**Answer:**  
- Under 24h: X%  
- Over 24h: Y%  

---

### OBJECTIVE 2: Cost & Coverage Insights  

#### 2a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?  
**Method:** Counted encounters with `payer_coverage = 0` and divided by total.  
**Answer:**  
- Zero coverage encounters: N  
- Percentage of total: M%  

---

#### 2b. What are the top 10 most frequent procedures performed and the average base cost for each?  
**Method:** Counted frequency of each procedure and calculated average base cost.  
**Answer:** Top 10 procedures by frequency with corresponding average base costs were listed.  

---

#### 2c. What are the top 10 procedures with the highest average base cost and number of times they were performed?  
**Method:** Ordered by `AVG(base_cost)` and included count of procedures performed.  
**Answer:** Top 10 high-cost procedures identified with frequency.  

---

#### 2d. What is the average total claim cost for encounters, broken down by payer?  
**Method:** Joined `encounters` with `payers` and calculated `AVG(total_claim_cost)` per payer.  
**Answer:** Average cost by payer was obtained.  

---

### OBJECTIVE 3: Patient Behavior Analysis  

#### 3a. How many unique patients were admitted each quarter over time?  
**Method:** Grouped encounters by `YEAR(start)` and `QUARTER(start)`, counted distinct patients.  
**Answer:** Quarterly patient admissions trend was retrieved.  

---

#### 3b. How many patients were readmitted within 30 days of a previous encounter?  
**Method:** Used window function `LEAD()` to calculate gap between consecutive encounters. Filtered by `DATEDIFF(next_start_date, stop) < 30`.  
**Answer:** Count of patients readmitted within 30 days was calculated.  

---

#### 3c. Which patients had the most readmissions?  
**Method:** Counted encounters per patient and subtracted 1 for first admission.  
**Answer:** Top patients with highest number of readmissions were listed.  

---

## 📌 Conclusions  

- Encounter trends and class distributions provide insight into hospital service utilization.  
- A notable portion of encounters had **zero payer coverage**, impacting hospital finances.  
- Certain procedures are both **high-cost and frequent**, important for budgeting and policy.  
- **Readmissions within 30 days** highlight potential areas for improving patient care quality.  
- Analysis of patient patterns helps identify **high-utilization patients**.  

---

✨ This project was part of a **guided project on the Maven Analytics platform**, and demonstrates how SQL queries and analytical methods (joins, aggregations, window functions, CTEs, date calculations) can reveal valuable insights for healthcare management.  
