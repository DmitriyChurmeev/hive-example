

create database hivetestdb;

use hivetestdb;

-- Таблица должностей с информацией о компании, зарплаты, локации и т.д.
CREATE TABLE IF NOT EXISTS jobs (
      work_year int,
      job_title string,
      job_category string,
      salary_currency string,
      salary DOUBLE,
      salary_in_usd DOUBLE,
      employee_residence string,
      experience_level string,
      employment_type string,
      work_setting string,
      company_location string,
      company_size string      
)row format delimited fields terminated by ',' 
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

--Таблица компаний
CREATE table companies AS
select work_year, company_location, company_size, salary, salary_currency, work_setting  from jobs;

--Таблица зарплат по компниям
create table country_salary as
select company_location, work_year, salary as salary from companies;

--Таблица расположении должностей
CREATE table jobs_location AS
SELECT job_title, job_category, company_location, work_year from jobs;



-- Информаия о компаниях
select * from companies;

--Информация о зарплатах в компаниях
select * from country_salary;

--Информация о расположении должностей
SELECT * from jobs_location;


--Средняя зарплаьа по стране по годам
SELECT company_location, work_year ,max(salary) as salary from companies
group by company_location, work_year
ORDER BY work_year DESC, salary DESC;


--Средняя зарплаьа по стране по годам
SELECT company_location, work_year ,avg(salary) as salary from companies
group by company_location, work_year
ORDER BY work_year DESC, salary DESC;

-- Тенденция кол-во должностей с удвленкой по странам и годам
select company_location, count(company_size) count, company_size, work_year from companies
where work_setting = 'Remote'
GROUP BY company_location, work_year, company_size
HAVING count > 1
ORDER BY work_year DESC

-- Список гибридных должностей которые можно найти в РОССИИ
SELECT DISTINCT job_title from jobs_location
inner join companies on companies.company_location = jobs_location.company_location
where companies.work_setting = 'Hybrid' and companies.company_location = 'Russia'

-- зарпдаты из США за 2020 или из Королевства но с гибридом
select DISTINCT salary from companies where company_location = 'United States' and work_year = 2020
UNION 
select DISTINCT salary from companies where company_location = 'United Kingdom' and work_setting = 'Hybrid'

-- Попытаемся понять популярность должностей по компаниям
SELECT job_title, RANK() OVER(order by company_location) as rank_job from jobs order by rank_job DESC ;

docker-compose down
docker system prune -a