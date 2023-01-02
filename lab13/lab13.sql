USE UNIVER;


-- 1. Разработать скалярную функцию с именем COUNT_STUDENTS, которая вычисляет количество студентов на факультете, код которого задается параметром типа VARCHAR(20) с именем @faculty.
-- Использовать внутреннее соединение таблиц FACULTY, GROUPS, STUDENT. Опробовать работу функции.

Alter FUNCTION COUNT_STUDENTS(@faculty nvarchar(20)) returns int
AS
BEGIN
	DECLARE @rc int = 0;
	SET @rc = (SELECT COUNT(*) from STUDENT s 
		join GROUPS g on s.IDGROUP = g.IDGROUP
			WHERE g.FACULTY  = @faculty);
return @rc;
end;

declare @f int = dbo.COUNT_STUDENTS(N'ХТиТ');
print N'Количество студентов на выбранном факультете: ' + convert(nvarchar(4), @f);

select FACULTY, dbo.COUNT_STUDENTS(FACULTY) from FACULTY;

-- Внести изменения в текст функции с помощью оператора ALTER с тем, чтобы функция принимала второй параметр @prof типа VARCHAR(20),
-- обозначающий специальность студентов. Для параметров определить значения по умолчанию NULL. Опробовать работу функции с помощью SELECT-запросов.

ALTER FUNCTION COUNT_STUDENTS(@faculty nvarchar(20) = NULL, @prof nvarchar(20) = NULL) returns int
AS
BEGIN
	DECLARE @rc int = 0;
	SET @rc = (SELECT COUNT(*) from STUDENT s 
		join GROUPS g on s.IDGROUP = g.IDGROUP
		join PULPIT p on g.FACULTY = p.FACULTY
			WHERE g.FACULTY  = @faculty and p.PULPIT = @prof);
return @rc;
end;

declare @f int = dbo.COUNT_STUDENTS(N'ТОВ',N'ОХ');
print N'Количество студентов на выбранном факультете: ' + convert(nvarchar(4), @f);

select FACULTY, dbo.COUNT_STUDENTS(FACULTY) from FACULTY;

-- 2. Разработать скалярную функцию с именем FSUBJECTS, принимающую параметр @p типа VARCHAR(20), значе-ние которого задает код кафедры (столбец SUB-JECT.PULPIT). 
-- Функция должна возвращать строку типа VARCHAR(300) с перечнем дисциплин в отчете. 
-- Создать и выполнить сценарий, который создает отчет, аналогичный представленному ниже. 
-- Примечание: использовать локальный статический кур-сор на основе SELECT-запроса к таблице SUBJECT.


alter FUNCTION FSUBJECTS(@p nvarchar(20)) returns nvarchar(300) 
AS
BEGIN
	DECLARE @ds nvarchar(20);
	DECLARE @d nvarchar(300) = N'Перечень дисциплин: ';
	DECLARE Disciplines CURSOR LOCAL STATIC
		FOR SELECT s.SUBJECT FROM SUBJECT s 
								WHERE s.PULPIT = @p;

	OPEN Disciplines;
	FETCH Disciplines into @ds;
	while @@FETCH_STATUS = 0
	BEGIN
		set @d = @d + ', ' + rtrim(@ds);
		FETCH Disciplines into @ds;
	END;
	return @d;
END;

select PULPIT,  dbo.FSUBJECTS(PULPIT) from PULPIT;


-- 3. Разработать табличную функцию FFACPUL, результаты работы которой продемонстрированы на рисунке ниже. 
-- Функция принимает два параметра, задающих код фа-культета (столбец FACULTY.FACULTY) и код кафедры (столбец PULPIT.PULPIT). Использует SELECT-запрос c левым внешним соединением между таблицами FACUL-TY и PULPIT. 
-- Если оба параметра функции равны NULL, то она воз-вращает список всех кафедр на всех факультетах. 
-- Если задан первый параметр (второй равен NULL), функция возвращает список всех кафедр заданного фа-культета. 
-- Если задан второй параметр (первый равен NULL), функция возвращает результирующий набор, содержащий строку, соответствующую заданной кафедре.


CREATE FUNCTION FFACPUL(@kf nvarchar(10), @kk nvarchar(10))returns table
AS RETURN
	SELECT f.FACULTY, p.PULPIT
		FROM FACULTY f join PULPIT p 
							ON f.FACULTY = p.FACULTY
						    WHERE f.FACULTY = ISNULL(@kf, f.FACULTY)
							AND p.PULPIT = isnull(@kk, p.PULPIT);

SELECT * FROM dbo.FFACPUL(NULL, NULL);
SELECT * FROM dbo.FFACPUL(N'ЛХФ', NULL);
SELECT * FROM dbo.FFACPUL(NULL, N'ЛВ');
SELECT * FROM dbo.FFACPUL(N'ИТ', N'ИСиТ');

-- 4. На рисунке ниже показан сценарий, демонстрирующий работу скалярной функции FCTEACHER. Функция при-нимает один параметр, задающий код кафедры. Функция возвращает количество преподавателей на заданной пара-метром кафедре. Если параметр равен NULL, то возвраща-ется общее количество преподавателей. 

CREATE FUNCTION FCTEACHER(@kk varchar(10)) returns int
AS
BEGIN
	DECLARE @rc int = (select count(*) from TEACHER
	WHERE PULPIT = ISNULL(@kk, PULPIT));
	return @rc;
END;

SELECT PULPIT, dbo.FCTEACHER(PULPIT) from PULPIT;

--6 Проанализировать многооператорную табличную функцию FACULTY_REPORT, представленную ниже:

drop function FACULTY_REPORT;
go
alter function COUNT_PULPIT(@faculty nvarchar(20)) returns int as
begin
declare @count int;
set @count = (select count(*) from PULPIT where FACULTY = @faculty);
return @count;
end;

go
alter function COUNT_GROUPS(@faculty nvarchar(20)) returns int as
begin
declare @count int;
set @count = (select count(*) from GROUPS where FACULTY = @faculty);
return @count;
end;

go
alter function COUNT_PROFESSION(@faculty nvarchar(20)) returns int as
begin
	declare @count int;
	set @count = (select count(*) from GROUPS where FACULTY = @faculty);
	return @count;
end;
go


Alter function FACULTY_REPORT(@c int) returns @fr table
([Факультет] nvarchar(50), [Кол-во кафедр] int, [Кол-во групп] int, [Кол-во судентов] int, [Кол-во специальностей] int)
as begin
	declare cc cursor static for
	select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY) > @c;

	declare @f nvarchar(30);
	
	open cc;
	fetch cc into @f;
	while @@FETCH_STATUS = 0
	begin
		insert @fr values (@f, dbo.COUNT_PULPIT(@f),dbo.COUNT_GROUPS(@f), dbo.COUNT_STUDENTS(@f),
		dbo.COUNT_PROFESSION(@f));
		fetch cc into @f;
	end;
	return;
end;
go
select * from dbo.FACULTY_REPORT(0);

go
