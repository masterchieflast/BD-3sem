use UNIVER
/*1*/
select distinct p.PULPIT_NAME, f.FACULTY
	from FACULTY f, PULPIT p
	where p.FACULTY = f.FACULTY 
	and
	f.FACULTY in (select PROFESSION.FACULTY from PROFESSION
		where (PROFESSION_NAME like N'%технология%' 
		or
		PROFESSION_NAME like N'%технологии%'))

/*2*/
select distinct p.PULPIT_NAME, f.FACULTY
	from FACULTY f join PULPIT p
	on p.FACULTY = f.FACULTY
	where f.FACULTY in (select PROFESSION.FACULTY from PROFESSION
		where (PROFESSION.PROFESSION_NAME like N'%технология%' 
		or
		PROFESSION_NAME like N'%технологии%'))

/*3*/
select distinct p.PULPIT_NAME, f.FACULTY
	from FACULTY f inner join PULPIT p
	on p.FACULTY = f.FACULTY 
	inner join PROFESSION
	on PROFESSION.FACULTY = f.FACULTY 
		where (PROFESSION.PROFESSION_NAME like N'%технология%' 
		or
		PROFESSION_NAME like N'%технологии%')

/*4*/
select AUDITORIUM_TYPE, AUDITORIUM_CAPACITY 
	from AUDITORIUM a
		where AUDITORIUM_TYPE=(select top(1) AUDITORIUM_TYPE from AUDITORIUM aa
			where aa.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE  order by AUDITORIUM_CAPACITY desc) order by AUDITORIUM_CAPACITY desc

/*5*/
select f.FACULTY_NAME from FACULTY f
	where not exists (select * from PULPIT p
		where f.FACULTY=p.FACULTY)

/*6*/
select top 1
	(select avg(pr.NOTE) from PROGRESS pr
where pr.SUBJECT=N'ОАиП') [OAP],
	(select avg(pr.NOTE) from PROGRESS pr
where pr.SUBJECT=N'БД') [BD],
	(select avg(pr.NOTE) from PROGRESS pr
where pr.SUBJECT=N'СУБД') [SUBD]

/*7*/
select AUDITORIUM.AUDITORIUM_CAPACITY, AUDITORIUM.AUDITORIUM_TYPE
		from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_CAPACITY <= all (select AUDITORIUM_CAPACITY from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_TYPE like N'ЛК-П%');

/*8*/
select AUDITORIUM.AUDITORIUM_CAPACITY, AUDITORIUM.AUDITORIUM_TYPE
		from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_CAPACITY > any (select AUDITORIUM_CAPACITY from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_TYPE like N'ЛК-%');


Select Name from Student where Student.IDGROUP in (select IDGROUP from GROUPS
join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY where FACULTY.FACULTY_NAME like N'%т' )