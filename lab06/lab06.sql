use UNIVER

-- 1
select 
	max(AUDITORIUM_CAPACITY) as max_capacity,
	min(AUDITORIUM_CAPACITY) as min_capacity,
	avg(AUDITORIUM_CAPACITY) as avg_capacity,
	COUNT(*) as auditorium_count,
	sum(AUDITORIUM_CAPACITY) as sum_by_type_capacity
from AUDITORIUM;


-- 2
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
	max(AUDITORIUM_CAPACITY) as max_capacity,
	min(AUDITORIUM_CAPACITY) as min_capacity,
	avg(AUDITORIUM_CAPACITY) as avg_capacity,
	COUNT(*) as auditorium_count,
	sum(AUDITORIUM_CAPACITY) as sum_by_type_capacity
from AUDITORIUM join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME;

-- 3
select * from (
	select case 
	when NOTE between 10 and 11 then '10'
	when NOTE between 8 and 9 then '8-9'
	when NOTE between 6 and 7 then '6-7'
	when NOTE between 4 and 5 then '4-5'
	else 'its horrible' end
	as notes, count(*) as accounting
from PROGRESS group by case 
	when NOTE between 10 and 11 then '10'
	when NOTE between 8 and 9 then '8-9'
	when NOTE between 6 and 7 then '6-7'
	when NOTE between 4 and 5 then '4-5'
	else 'its horrible' end 
) as t 
order by t.accounting;



-- 4 
select  GROUPS.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP,
	round(avg(cast(PROGRESS.NOTE as float(4))),2) as avg_note from FACULTY
inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where PROGRESS.SUBJECT = N'БД' or PROGRESS.SUBJECT = N'ОАиП'
group by GROUPS.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP


-- 5
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(NOTE) as N'avg_note' from FACULTY
inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where FACULTY.FACULTY = N'ТОВ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT with rollup

-- 6
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(NOTE) as N'avg_note' from FACULTY
inner join GROUPS on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where FACULTY.FACULTY = N'ТОВ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT with cube

--7
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) as 'avg_note'
from student
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY = N'ТОВ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT
union 
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) as 'avg_note'
from student
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY = N'ХТиТ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT

select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) as 'avg_note'
from student
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY = N'ТОВ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT
union all
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) as 'avg_note'
from student
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY = N'ХТиТ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT

-- 8
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) as 'avg_note'
from student
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY in (N'ТОВ' , N'ХТиТ')
group by GROUPS.PROFESSION,PROGRESS.SUBJECT
intersect
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) as 'avg_note'
from student
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY = N'ХТиТ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT

--9
select g.PROFESSION, p.SUBJECT, avg(p.NOTE) as 'avg_note'
from student s
inner join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
inner join GROUPS g on s.IDGROUP = g.IDGROUP
where g.FACULTY = N'ТОВ'
group by g.PROFESSION,p.SUBJECT
except
select GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) as 'avg_note'
from student
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
where GROUPS.FACULTY = N'ХТиТ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT

-- 10
select p.SUBJECT, p.NOTE, count(*) as capacity_of_student from PROGRESS p 
group by p.SUBJECT, p.NOTE
having p.NOTE >= 8
order by p.NOTE