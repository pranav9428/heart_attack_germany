use ftnproject2;

/*1*/
SELECT age_group, SUM(Heart_Attack_Incidence) AS total_heart_attack
FROM heart_attack_germany
GROUP BY age_group;

/*2*/
SELECT gender, AVG(bmi) AS average_bmi
FROM heart_attack_germany
GROUP BY gender;

/*3*/
SELECT state, SUM(Heart_Attack_Incidence) as number_of_heart_atteck
from heart_attack_germany
WHERE age_group = 'Youth'
GROUP BY state
ORDER BY number_of_heart_atteck DESC
LIMIT 5;

/*4*/
SELECT COUNT(Heart_Attack_Incidence) AS total_heart_attack_incdent,Urban_Rural 
FROM  heart_attack_germany
WHERE Heart_Attack_Incidence=1 
GROUP BY Urban_rural 
ORDER BY total_heart_attack_incdent DESC;

/*5*/
SELECT socioeconomic_status, AVG(heart_attack_incidence) AS avg_incidence
FROM heart_attack_germany
GROUP BY socioeconomic_status;

/*6*/
SELECT Year1, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks
FROM heart_attack_germany
WHERE Age_Group = 'Adult'
GROUP BY Year1
ORDER BY Total_Heart_Attacks DESC
LIMIT 1;

/*7*/
SELECT State AS Region , AVG(CASE WHEN Age_Group="Youth" 
THEN Heart_Attack_Incidence ELSE NULL END) AS avg_Youth_heart_attack_incidence,AVG(CASE WHEN Age_Group="Adult" 
THEN Heart_Attack_Incidence ELSE NULL END) AS avg_Adult_heart_attack_incidence
 FROM  heart_attack_germany
 GROUP BY State;


/*8*/

SELECT age_group, (SUM(CASE WHEN smoking_status = 'Smoker' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS smoker_percentage
FROM heart_attack_germany
WHERE heart_attack_incidence = 1
GROUP BY age_group;

/*9*/
WITH Avg_Heart_Attack_Rate AS (
SELECT AVG(Heart_Attack_Incidence) AS Avg_Heart_Attack_Rate
FROM heart_attack_germany
)
SELECT State, AVG(Physical_Activity_Level) AS Avg_Physical_Activity_Level
FROM heart_attack_germany
WHERE Heart_Attack_Incidence < (SELECT Avg_Heart_Attack_Rate FROM Avg_Heart_Attack_Rate)
GROUP BY State;


/*10*/
WITH Avg_Alcohol_Consumption AS (
SELECT AVG(Alcohol_Consumption) AS Avg_Alcohol_Consumption
FROM heart_attack_germany)
SELECT DISTINCT Year1
FROM heart_attack_germany
WHERE Alcohol_Consumption > (SELECT Avg_Alcohol_Consumption FROM Avg_Alcohol_Consumption);

/*11*/
WITH RankedData AS (
SELECT Gender, Heart_Attack_Incidence, 
ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Heart_Attack_Incidence) AS RowNum,
COUNT(*) OVER (PARTITION BY Gender) AS TotalRows
FROM heart_attack_germany
)
SELECT Gender, 
AVG(Heart_Attack_Incidence) AS Median_Heart_Attack_Incidence
FROM RankedData
WHERE RowNum IN (TotalRows / 2, TotalRows / 2 + 1)
GROUP BY Gender;


/*12*/
SELECT State,Year1,MAX(Heart_Attack_Incidence) ,MIN(Heart_Attack_Incidence) 
FROM  heart_attack_germany
GROUP BY State,Year1;

/*13*/
SELECT AVG(Stress_Level) ,State,Air_Pollution_Index 
FROM  heart_attack_germany
GROUP BY State,Air_Pollution_Index 
ORDER BY Air_Pollution_Index DESC LIMIT 10;

/*14*/
SELECT Education_Level, AVG(Cholesterol_Level) AS avg_cholesterol
FROM heart_attack_germany
GROUP BY Education_Level;

/*15*/
WITH avg_healthcare_access AS (
    SELECT AVG(healthcare_access) AS avg_access
    FROM heart_attack_germany
)
SELECT Region_Heart_Attack_Rate, AVG(heart_attack_incidence) AS avg_incidence
FROM heart_attack_germany, avg_healthcare_access
WHERE healthcare_access > avg_access
GROUP BY Region_Heart_Attack_Rate;

/*16*/
SELECT Socioeconomic_status,AVG(Heart_Attack_Incidence),SUM(Heart_Attack_Incidence)
 FROM  heart_attack_germany
 GROUP BY Socioeconomic_status;

/*17*/
SELECT diet_quality, COUNT(*) AS count
FROM heart_attack_germany
WHERE age_group = 'Youth' AND heart_attack_incidence = 1
GROUP BY diet_quality
ORDER BY count DESC
LIMIT 1;

/*18*/
WITH Yearly_Incidences AS (
SELECT State, Year1, SUM(Heart_Attack_Incidence) AS Yearly_Heart_Attack_Incidence
FROM heart_attack_germany
GROUP BY State, Year1
)
SELECT a.State
FROM Yearly_Incidences a
JOIN Yearly_Incidences b ON a.State = b.State AND a.Year1 = b.Year1 - 1
JOIN Yearly_Incidences c ON a.State = c.State AND a.Year1 = c.Year1 - 2
WHERE a.Yearly_Heart_Attack_Incidence > b.Yearly_Heart_Attack_Incidence
  AND b.Yearly_Heart_Attack_Incidence > c.Yearly_Heart_Attack_Incidence;


/*19*/
SELECT employment_status, AVG(physical_activity_level) AS avg_activity
FROM heart_attack_germany
GROUP BY employment_status;

/*20*/
SELECT State,AVG(BMI) AS avg_bmi 
FROM  heart_attack_germany
GROUP BY State 
HAVING avg_bmi>(SELECT AVG(BMI) FROM heart_attack_germany);

/*21*/
SELECT a.state
FROM heart_attack_germany  a
JOIN heart_attack_germany b ON a.state = b.state
WHERE a.age_group = 'Youth' AND b.age_group = 'Adult'
GROUP BY a.state
HAVING SUM(a.Heart_Attack_Incidence) > SUM(b.Heart_Attack_Incidence);


/*22*/
SELECT Region_Heart_Attack_Rate
FROM heart_attack_germany t1
WHERE Heart_Attack_Incidence > (
SELECT AVG(Heart_Attack_Incidence)
FROM heart_attack_germany t2
WHERE t2.Socioeconomic_Status = t1.Socioeconomic_Status
)
GROUP BY Region_Heart_Attack_Rate;

/*23*/
SELECT a.State, 
SUM(CASE WHEN a.Smoking_Status = 'Smoker' THEN a.Heart_Attack_Incidence ELSE 0 END) AS Smoker_Heart_Attacks,
SUM(CASE WHEN a.Smoking_Status = 'Non-Smoker' THEN a.Heart_Attack_Incidence ELSE 0 END) AS Non_Smoker_Heart_Attacks
FROM heart_attack_germany a
GROUP BY a.State
ORDER BY Smoker_Heart_Attacks DESC
LIMIT 5;

/*24*/
WITH Avg_Stress AS (
SELECT AVG(Stress_Level) AS Avg_Stress_Level
FROM heart_attack_germany
),
Avg_Heart_Attack AS (
SELECT AVG(Heart_Attack_Incidence) AS Avg_Heart_Attack_Incidence
FROM heart_attack_germany
)
SELECT State
FROM heart_attack_germany
GROUP BY State
HAVING AVG(Stress_Level) > (SELECT Avg_Stress_Level FROM Avg_Stress)
AND AVG(Heart_Attack_Incidence) < (SELECT Avg_Heart_Attack_Incidence FROM Avg_Heart_Attack);

/*25*/
WITH Yearly_Incidences AS (
SELECT State, Year1, SUM(Heart_Attack_Incidence) AS Yearly_Heart_Attack_Incidence
FROM heart_attack_germany
GROUP BY State, Year1
)
SELECT a.State, a.Year1,
((a.Yearly_Heart_Attack_Incidence - b.Yearly_Heart_Attack_Incidence) / b.Yearly_Heart_Attack_Incidence) * 100 AS Yearly_Percentage_Change
FROM Yearly_Incidences a
JOIN Yearly_Incidences b ON a.State = b.State AND a.Year1 = b.Year1 + 1;

/*26*/
SELECT State, Year1, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks,
RANK() OVER (PARTITION BY Year1 ORDER BY SUM(Heart_Attack_Incidence) DESC) AS Rank1
FROM heart_attack_germany
WHERE Age_Group = 'Adult'
GROUP BY State, Year1;

/*27*/
SELECT Year1, SUM(Heart_Attack_Incidence) AS Yearly_Heart_Attacks,
SUM(SUM(Heart_Attack_Incidence)) OVER (PARTITION BY State ORDER BY Year1) AS Running_Total_Heart_Attacks
FROM heart_attack_germany
WHERE Age_Group = 'Youth' AND State = 'Germany'
GROUP BY Year1;

/*28*/
SELECT State, Year1, AVG(Cholesterol_Level) OVER (PARTITION BY State ORDER BY Year1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Avg_Cholesterol_Level
FROM heart_attack_germany ;

/*29*/
SELECT State, Year1, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks,
ROW_NUMBER() OVER (PARTITION BY Year1 ORDER BY SUM(Heart_Attack_Incidence) DESC) AS RowNum
FROM heart_attack_germany
WHERE Age_Group = 'Youth'
GROUP BY State, Year1
HAVING RowNum <= 3;

/*30*/
SELECT State, Urban_Rural, Year1, 
Heart_Attack_Incidence - LAG(Heart_Attack_Incidence) OVER (PARTITION BY State ORDER BY Year1) AS Heart_Attack_Rate_Difference
FROM heart_attack_germany
WHERE Urban_Rural IN ('Urban', 'Rural');

/*31*/
SELECT CORR(Air_Pollution_Index, Heart_Attack_Incidence) AS Correlation_Air_Pollution_Heart_Attacks
FROM heart_attack_germany;

/*32*/
WITH Socioeconomic_Change AS (
SELECT Region, Socioeconomic_Status, Year, SUM(Heart_Attack_Incidence) AS Yearly_Heart_Attack_Incidence
FROM heart_attack_germany
GROUP BY Region, Socioeconomic_Status, Year
)
SELECT Region
FROM Socioeconomic_Change a
JOIN Socioeconomic_Change b ON a.Region = b.Region AND a.Socioeconomic_Status = b.Socioeconomic_Status
WHERE a.Year = b.Year - 1 AND a.Yearly_Heart_Attack_Incidence < b.Yearly_Heart_Attack_Incidence
GROUP BY Region
HAVING COUNT(DISTINCT a.Socioeconomic_Status) = (SELECT COUNT(DISTINCT Socioeconomic_Status) FROM heart_attack_germany);

/*33*/
SELECT Age_Group, Diabetes, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks
FROM heart_attack_germany
GROUP BY Age_Group, Diabetes;

/*34*/
WITH Yearly_Incidences AS (
SELECT Year1, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks
FROM heart_attack_germany
WHERE Age_Group = 'Youth' AND State = 'Germany'
GROUP BY Year1
)
SELECT a.Year1, 
((a.Total_Heart_Attacks - b.Total_Heart_Attacks) / b.Total_Heart_Attacks) * 100 AS Yearly_Growth_Percentage
FROM Yearly_Incidences a
JOIN Yearly_Incidences b ON a.Year1 = b.Year1 + 1;

/*35*/
SELECT 
CORR(Smoking_Status, Heart_Attack_Incidence) AS Smoking_Correlation,
CORR(Alcohol_Consumption, Heart_Attack_Incidence) AS Alcohol_Correlation
FROM heart_attack_germany;


/*36*/
SELECT Education_Level, AVG(Physical_Activity_Level) AS Avg_Physical_Activity_Level, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks
FROM heart_attack_germany
GROUP BY Education_Level;

/*37*/
SELECT State, Family_History, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks
FROM heart_attack_germany
GROUP BY State, Family_History
ORDER BY Total_Heart_Attacks DESC
LIMIT 1;

/*38*/
WITH Avg_Diet_Quality AS (
SELECT AVG(Diet_Quality) AS Avg_Diet_Quality
FROM heart_attack_germany
WHERE Age_Group = 'Adult'
)
SELECT Age_Group, Diet_Quality, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks
FROM heart_attack_germany
WHERE Age_Group = 'Adult'
GROUP BY Diet_Quality;


/*39*/
SELECT Hypertension, AVG(Cholesterol_Level) AS Avg_Cholesterol_Level, SUM(Heart_Attack_Incidence) AS Total_Heart_Attacks
FROM heart_attack_germany
GROUP BY Hypertension;

/*40*/
SELECT CASE
WHEN Stress_Level > 7 AND BMI > 30 AND Healthcare_Access < 50 THEN 'High Risk'
ELSE 'Low Risk'
END AS Risk_Group,
COUNT(*) AS Population_Count
FROM heart_attack_germany
GROUP BY Risk_Group;


