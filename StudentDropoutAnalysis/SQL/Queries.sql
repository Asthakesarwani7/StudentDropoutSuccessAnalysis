CREATE DATABASE dropout;
USE dropout;
SELECT * FROM dropout.dropout_analysis LIMIT 50;

-- Dropout Rate Compared to Average Dropout Rate by Course
SELECT CourseLabel,
COUNT(*) AS TotalStudents,
SUM(is_Dropout) AS Dropouts,
ROUND(SUM(is_Dropout) * 100 / COUNT(*), 2) AS DropoutRate,
ROUND(AVG(SUM(is_Dropout) * 100.0 / COUNT(*)) OVER (), 2) AS OverallDropoutRate,
ROUND(
	ROUND(SUM(is_Dropout) * 100.0 / COUNT(*), 2) - 
	ROUND(AVG(SUM(is_Dropout) * 100.0 / COUNT(*)) OVER (), 2), 2) AS VarianceFromAverage
FROM dropout.dropout_analysis
GROUP BY CourseLabel
ORDER BY VarianceFromAverage DESC;

-- Performance vs Dropout
SELECT GradeBand,
ROUND(AVG(AverageGrade1stAnd2ndSem), 2) as AvgGrade,
ROUND(SUM(is_Dropout) * 100.0 / COUNT(*), 2) AS DropoutRate
FROM dropout.dropout_analysis
GROUP BY GradeBand
ORDER BY AvgGrade;


-- Dropout by Age Band
SELECT AgeBand,
COUNT(*) AS TotalStudents,
SUM(is_Dropout) AS Dropouts,
ROUND(SUM(is_Dropout) * 100.0 / COUNT(*), 2) AS DropoutRate,
ROW_NUMBER() OVER (ORDER BY ROUND(SUM(is_Dropout) * 100.0 / COUNT(*), 2) DESC) AS DropoutRank
FROM dropout.dropout_analysis
GROUP BY AgeBand
ORDER BY DropoutRate DESC;

-- Dropout Risk by Parental Occupation
SELECT MotherOccLabel,
FatherOccLabel,
COUNT(*) AS TotalStudents,
SUM(is_Dropout) AS Dropouts,
ROUND(SUM(is_Dropout) * 100 / COUNT(*), 2) AS DropoutRate
FROM dropout.dropout_analysis
GROUP BY MotherOccLabel, FatherOccLabel
ORDER BY DropoutRate DESC;

-- Dropout by Attendance Type
SELECT AttendanceTiming,
COUNT(*) AS TotalStudents,
SUM(is_Dropout) AS Dropouts,
ROUND(SUM(is_Dropout) * 100 / COUNT(*), 2) AS DropoutRate
FROM dropout.dropout_analysis
GROUP BY AttendanceTiming;


-- Impact of Mother's Qualification
SELECT MotherQualLabel,
COUNT(*) AS TotalStudents,
SUM(is_Dropout) AS Dropouts,
ROUND(SUM(is_Dropout) * 100.0 / COUNT(*), 2) AS DropoutRate,
	CASE 
		WHEN MotherQualLabel IN (
			'No Schooling', 'Primary', 'Middle', 'No Degree', 'Other', 'Certificate', 'Short Courses'
		) THEN 'High Risk'
		
		WHEN MotherQualLabel IN (
			'Secondary', 'High School', 'Higher Secondary', 'Vocational', 'Technical', 'Associate',
			'Vocational Diploma', 'High Vocational', 'Trade', 'Specialized Training', 'IT Certification'
		) THEN 'Medium Risk'
		
		WHEN MotherQualLabel IN (
			'Diploma', 'Bachelor', 'Undergraduate', 'Bachelor of Arts', 'Bachelor of Science',
			'Master', 'Postgraduate', 'Doctorate', 'PhD', 'PhD Advanced', 'Professional'
		) THEN 'Low Risk'
		
		ELSE 'Unknown'
END AS RiskCategory
FROM dropout.dropout_analysis
GROUP BY MotherQualLabel, RiskCategory
ORDER BY DropoutRate DESC;


-- Dropout by Scholarship
SELECT ScholarshipHolderLabel,
COUNT(*) AS TotalStudents,
SUM(is_Dropout) AS Dropouts,
ROUND(SUM(is_Dropout) * 100 / COUNT(*), 2) AS DropoutRate
FROM dropout.dropout_analysis
GROUP BY ScholarshipHolderLabel;

-- Dropout vs Economic Indicators
SELECT RiskLevel,
ROUND(AVG(UnemploymentRate), 2) AS AvgUnemploymentRate,
ROUND(AVG(InflationRate), 2) AS AvgInflationRate,
ROUND(AVG(GDP), 2) AS AvgGDP,
ROUND(SUM(is_Dropout) * 100.0 / COUNT(*), 2) AS DropoutRate
FROM dropout.dropout_analysis
GROUP BY RiskLevel
ORDER BY DropoutRate DESC;

-- Dropout Rate by Debtor Status and Tuition Fee Payment
SELECT DebtorLabel,
TutionFeesUpToDate,
COUNT(*) AS TotalStudents,
SUM(is_Dropout) AS Dropouts,
ROUND(SUM(is_Dropout) * 100 / COUNT(*), 2) AS DropoutRate
FROM dropout.dropout_analysis
GROUP BY DebtorLabel, TutionFeesUpToDate
ORDER BY DropoutRate DESC;