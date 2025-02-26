DROP TABLE IF EXISTS patients;
CREATE TABLE IF NOT EXISTS patients (
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    blood_type VARCHAR(3) NOT NULL,
    medical_condition VARCHAR(100) NOT NULL,
    date_of_admission DATE NOT NULL,
    doctor VARCHAR(100) NOT NULL,
    hospital VARCHAR(100) NOT NULL,
    insurance_provider VARCHAR(100) NOT NULL,
    billing_amount NUMERIC(10, 2) NOT NULL,
    room_number INT NOT NULL,
    admission_type VARCHAR(50) NOT NULL,
    discharge_date DATE,
    medication VARCHAR(100) NOT NULL,
    test_results VARCHAR(100) NOT NULL
);



select *
from patients


--1. What is the distribution of patients by gender?
--How many male and female patients are in the dataset?

select count(gender) as male_count
from patients 
where gender = 'Male';

select count(gender) as female_count
from patients 
where gender = 'Female';

--What percentage of the total patients does each gender represent?

SELECT
    gender,
    COUNT(*) AS count_of_gender,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM patients
GROUP BY gender
ORDER BY count DESC;


--2. What are the most common medical conditions among patients?
--Which medical condition appears most frequently in the dataset?

select * from patients

with medical_data (medical_condition,count_of_medical_conditions) as (
select 
		medical_condition, 
		count(*) as count_of_medical_conditions
from patients
group by medical_condition
order by count_of_medical_conditions desc)

select 
		medical_condition, 
		count_of_medical_conditions
from medical_data
where count_of_medical_conditions= (select max(count_of_medical_conditions) from medical_data)	
--What percentage of patients have each medical condition?


select
		medical_condition, 
		count(*) as count_of_medical_conditions,
		round(count(*) * 100/sum(count(*)) over(), 2) as percentage_
from patients
group by medical_condition
order by percentage_ desc


--3. What is the average billing amount for each medical condition?
--Which medical condition has the highest average billing amount?

with highest_billing (medical_condition, avg_amount) as 
(select
		medical_condition, 
		round(avg(billing_amount),2) as avg_amount
		
from patients
group by medical_condition 
order by avg_amount desc)

select medical_condition, avg_amount
from highest_billing
where avg_amount = (select max(avg_amount) from highest_billing);


--Which medical condition has the lowest average billing amount?

with lowest_billing (medical_condition, avg_amount) as 
(select
		medical_condition, 
		round(avg(billing_amount),2) as avg_amount
from patients
group by medical_condition 
order by avg_amount desc)

select medical_condition, avg_amount
from lowest_billing
where avg_amount = (select min(avg_amount) from lowest_billing);


--4. How does the length of stay vary by admission type?
--What is the average length of stay (in days) for patients admitted under "Urgent," "Emergency," and "Elective" admissiontypes?


select 
		admission_type,
		round(avg(discharge_date - date_of_admission ),2) as avg_stay
from patients
group by admission_type
order by avg_stay desc


--Which admission type has the longest average stay?
with longest_avg_stay (admission_type, avg_stay) as 
(select 
		admission_type,
		round(avg(discharge_date - date_of_admission ),2) as avg_stay
from patients
group by admission_type
order by avg_stay desc)

select 
		admission_type,
		avg_stay
from longest_avg_stay
where avg_stay = (select(max(avg_stay)) from longest_avg_stay)


--5. What is the distribution of blood types among patients?
--Which blood type is the most common among patients?

select blood_type, count(*) as patients_count
from patients
group by blood_type
order by patients_count desc
limit 1

--What percentage of patients have each blood type?

select blood_type, count(*) as patients_count, 
round(count(*)*100/sum(count(*)) over(),2 ) as percentage
from patients
group by blood_type
order by percentage desc


--6. Which insurance provider is most commonly used by patients?
--What is the distribution of patients across insurance providers?

select insurance_provider, count(*) as patients_count
from patients
group by insurance_provider
order by patients_count desc
limit 1;


--Which insurance provider covers the most patients, and what percentage of the total patients does it represent?

select insurance_provider, count(*) as patients_count, 
round(count(*)*100/sum(count(*)) over(),2 ) as percentage
from patients
group by insurance_provider
order by percentage desc
limit 1

--What is the average age of patients in the dataset?
select round(avg(age),2) as avg_age
from patients;

--What is the age range (minimum and maximum age) of patients?

select max(age) as max_age, min(age) as min_age
from patients;

--How many patients fall into different age groups (e.g., 0-18, 19-35, 36-50, 51+)?
with age_gp (age, age_group) as
(SELECT age,
    CASE
        WHEN age <= 18 THEN 'very young'
        WHEN age <= 35 THEN 'Grown'
        WHEN age <= 50 THEN 'Old'
        ELSE 'very old'
    END AS age_group
FROM patients
order by age)

select age_group, count(age_group) as count_of_each_gp
from age_gp
group by age_group
order by count_of_each_gp desc



select * from patients