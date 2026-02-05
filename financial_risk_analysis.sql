create database Financial_risk ;
use Financial_risk ;

select * from loan_data ;

-- 1. number of loan application and number of approved or cancelled 
select case when LoanApproved = 0 then 'Cancelled' else 'Approved' end as loan ,
count(*) as loan_application from loan_data group by 1 with rollup ;

-- 2. Which customer profiles are most likely to default on loans?
select CreditScore,EmploymentStatus,count(*) as total_application,
sum(case when LoanApproved = 0 then 1 else 0 end ) as defaults,
concat(round(sum(case when LoanApproved = 0 then 1 else 0 end) * 100.0 / count(*) ,2),'%') as defaults_rata  
from loan_data group by 1,2 order by 5 desc ;

-- 3. What are the key predictors of loan approval?
select 
EmploymentStatus, EducationLevel, MaritalStatus,
round(avg(CreditScore),2) as avg_credit_score ,round(avg(AnnualIncome),2) as avg_income ,
round(avg(DebtToIncomeRatio),2) as avg_DTI, 
concat(round(sum(LoanApproved) * 100 / count(*),2),'%') as approved,
case when round(avg(DebtToIncomeRatio),2) between 0.0 and 0.20 then 'Very low risk'
	 when round(avg(DebtToIncomeRatio),2) between 0.21 and 0.35 then 'Acceptable risk'
     when round(avg(DebtToIncomeRatio),2) between 0.36 and 0.50 then 'High risk'
     else 'Very high risk' end as DTI_Level
from loan_data group by 1,2,3 order by 8 desc ; 


-- 4. How does Debt-to-Income Ratio affect the risk score and loan approval?
select 
case when DebtToIncomeRatio between 0.0 and 0.20 then 'Very low risk'
	 when DebtToIncomeRatio between 0.21 and 0.35 then 'Acceptable risk'
     when DebtToIncomeRatio between 0.36 and 0.50 then 'High risk'
     else 'Very high risk' end as DTI_Level,
round(avg(RiskScore),2) avg_risk_score,
concat(round(avg(LoanApproved) * 100 / count(*),4),'%') as approval_rate
from loan_data group by 1 order by 2 desc ;

-- 5. Is there a relationship between credit history length and risk score?
select LengthOfCreditHistory,
round(avg(RiskScore),2) avg_risk_score
from loan_data group by 1 order by 1 desc  ;

-- 6. Which employment types or education levels have higher financial risk?
select EmploymentStatus , EducationLevel,
round(avg(RiskScore),2) as avg_risk_score,
concat(round(avg(LoanApproved) *100 / count(*),2),'%') as approval_rate
from loan_data group by  1,2  order by 3 desc ;

-- 7. What impact do previous defaults or bankruptcies have on current risk?
select PreviousLoanDefaults, BankruptcyHistory,
round(avg(RiskScore),2) as avg_risk_score,
concat(round(avg(LoanApproved) *100 / count(*),3),'%') as approval_rate
from loan_data group by  1,2  order by 3 desc ;

-- 8. How does credit card utilization influence financial risk?
select 
case when CreditCardUtilizationRate < 0.3 then 'Low Utilization'
	 when CreditCardUtilizationRate < 0.7 then 'Moderate'
     else 'High Utilization' end as utilization,
round(avg(RiskScore),2) as avg_risk_score,
concat(round(avg(LoanApproved) *100 / count(*),3),'%') as approval_rate
from loan_data group by  1  order by 2 desc ;

-- 9. Are certain loan purposes more prone to defaults or rejections?.
select 
LoanPurpose,
round(avg(RiskScore),2) as avg_risk_score,
concat(round(avg(LoanApproved) *100 / count(*),3),'%') as approval_rate
from loan_data group by  1  order by 2 desc ;

-- 10. What is the impact of monthly loan payments on approval rates?
select 
case when MonthlyLoanPayment < 500 then 'Low Payment'
	 when MonthlyLoanPayment between 501 and 1000 then 'Medium Payment'
     else 'High payment' end payment_category,
round(avg(RiskScore),2) as avg_risk_score,
concat(round(avg(LoanApproved) *100 / count(*),3),'%') as approval_rate
from loan_data group by  1  order by 2 desc ;

-- 11. Which financial ratios (e.g., Total Debt to Income, Net Worth) best predict risk?
select 
round(avg(TotalDebtToIncomeRatio),2) avg_total_DTI, round(avg(DebtToIncomeRatio),2) avg_DTI, 
round(avg(RiskScore),2) avg_risk, round(avg(NetWorth),2)avg_net_worth
from loan_data ;

-- 12. Does marital status or number of dependents affect loan risk?
select
MaritalStatus, NumberOfDependents,
round(avg(RiskScore),2) as avg_risk_score,
concat(round(avg(LoanApproved) *100 / count(*),3),'%') as approval_rate
from loan_data group by  1,2  order by 3 desc ;

-- 13. Can we cluster customers based on risk profile to design targeted loan products?
select 
case when RiskScore < 40 then 'Low Risk'
	 when RiskScore between 41 and 70 then 'Medium Risk'
     else 'High Risk' end as risk_group,
count(*) as total,
round(avg(MonthlyIncome),2) avg_monthly_income, 
round(avg(CreditScore),2) avg_credit_score,
concat(round(avg(LoanApproved),2),'%') approval_rate
from loan_data group by 1 order by 2 desc ;


select distinct 

dristring 
