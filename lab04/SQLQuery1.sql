use DRUGAKOV_MyBASE
-- 1
SELECT Поставщик.Название_поставщика, Адресс.Город 
FROM Поставщик inner join Адресс 
ON Поставщик.Адрес_id = Адресс.Адресс_id

-- 2
SELECT Поставщик.Название_поставщика, Адресс.Город 
FROM Поставщик inner join Адресс 
ON Поставщик.Адрес_id = Адресс.Адресс_id
WHERE Адресс.Город like N'м%'

-- 3
SELECT Поставщик.Название_поставщика, Адресс.Город 
FROM Поставщик, Адресс 
WHERE Поставщик.Адрес_id = Адресс.Адресс_id

-- 4 - 5
SELECT Заказ.Номер_заказа, Поставщик.Название_поставщика, Деталь.Название_детали, Заказ.Количество_заказанных_деталей,
	Case 
	when(Деталь.Цена < 10 ) then N'до 10'
	when(Деталь.Цена = 10) then N'ровно 10'
	when(Деталь.Цена > 10) then N'больше 10'
	else N'error'
	end N'Цена'
FROM Заказ
inner join Деталь ON Деталь.Артикул = Заказ.Артикул_детали
inner join Поставщик on Поставщик.Код_поставщика = Деталь.Код_поставщика
Order by
(	case
	When (Заказ.Количество_заказанных_деталей < 2) then 3
	When (Заказ.Количество_заказанных_деталей > 2) then 1
	else 2
	end 
)desc, Заказ.Количество_заказанных_деталей desc

-- 6
SELECT isnull(Деталь.Название_детали, '***'), Поставщик.Название_поставщика 
FROM Поставщик
LEFT OUTER JOIN Деталь ON Деталь.Код_поставщика = Поставщик.Код_поставщика

-- 7		
SELECT isnull(Деталь.Название_детали, '***'), Поставщик.Название_поставщика 
FROM Поставщик
Right OUTER JOIN Деталь ON Деталь.Код_поставщика = Поставщик.Код_поставщика

go

use UNIVER
-- 1
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME FROM AUDITORIUM
inner join AUDITORIUM_TYPE ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

-- 2
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME FROM AUDITORIUM
inner join AUDITORIUM_TYPE ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like N'%компьютер%'
-- 3
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
FROM AUDITORIUM, AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

-- 4
SELECT FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME,
PROFESSION.QUALIFICATION, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
	Case 
	when(PROGRESS.NOTE between 1 and 5 ) then N'оценка низкая'
	when(PROGRESS.NOTE = 6) then N'шесть'
	when(PROGRESS.NOTE = 7) then N'семь'
	when(PROGRESS.NOTE = 8 ) then N'восьм'
	when(PROGRESS.NOTE between 9 and 10) then N'высокий балл'
	else N'вхреп)'
	end N'Оценка'
FROM STUDENT
Inner join PROGRESS ON STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join SUBJECT ON PROGRESS.SUBJECT = SUBJECT.SUBJECT
inner join PULPIT ON SUBJECT.PULPIT = PULPIT.PULPIT
inner join FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY
inner join PROFESSION ON PROFESSION.FACULTY = FACULTY.FACULTY
ORDER BY PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION,
STUDENT.NAME asc ;

-- 5
SELECT FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME,
PROFESSION.QUALIFICATION, SUBJECT.SUBJECT_NAME, STUDENT.NAME,
	Case 
	when(PROGRESS.NOTE between 1 and 5 ) then N'оценка низкая'
	when(PROGRESS.NOTE = 6) then N'шесть'
	when(PROGRESS.NOTE = 7) then N'семь'
	when(PROGRESS.NOTE = 8 ) then N'восьм'
	when(PROGRESS.NOTE between 9 and 10) then N'высокий балл'
	else N'вхреп)'
	end N'Оценка'
FROM STUDENT
inner join PROGRESS ON STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join SUBJECT ON PROGRESS.SUBJECT = SUBJECT.SUBJECT
inner join PULPIT ON SUBJECT.PULPIT = PULPIT.PULPIT
inner join FACULTY ON PULPIT.FACULTY = FACULTY.FACULTY
inner join PROFESSION ON PROFESSION.FACULTY = FACULTY.FACULTY
ORDER BY 
(
Case 
	when(PROGRESS.NOTE between 1 and 5 ) then 2
	when(PROGRESS.NOTE = 6) then 4
	when(PROGRESS.NOTE = 7) then 6
	when(PROGRESS.NOTE = 8 ) then 5
	when(PROGRESS.NOTE between 9 and 10) then 3
	else 1
	end 
) desc, PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, PROFESSION.PROFESSION,
STUDENT.NAME asc ;

-- 6 
SELECT isnull(TEACHER.TEACHER_NAME, '***'), PULPIT.PULPIT_NAME 
FROM PULPIT
LEFT OUTER JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT

-- 7		
SELECT isnull(TEACHER.TEACHER_NAME, '***'), PULPIT.PULPIT_NAME 
FROM PULPIT
RIGHT OUTER JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT

-- 8.1
SELECT * FROM PULPIT
full outer join TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
WHERE TEACHER is not null

-- 8.2
SELECT * FROM PULPIT
full outer join TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
WHERE PULPIT.PULPIT is not null

-- 8.3 
SELECT * FROM PULPIT
full outer join TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT

-- 9
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME FROM AUDITORIUM
cross join AUDITORIUM_TYPE 