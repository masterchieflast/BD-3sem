-- 1. Разработать сценарий, демонстрирующий работу в режиме неявной транзакции.ГНФ Un Com Rep Ser
--Проанализировать пример, приведенный справа, в котором создается таблица Х, и создать сценарий для другой таблицы.

set nocount on
if exists (select * from SYS.OBJECTS
where OBJECT_ID=object_id(N'DBO.TAB'))
drop table TAB;
declare @c int, @flag nchar = 'r'; -- если с->r, таблица не сохр

SET IMPLICIT_TRANSACTIONS ON -- вкл режим неявной транзакции
create table TAB(K int );
insert TAB values (1),(2),(3),(4),(5);
set @c = (select count(*) from TAB);
print N'кол-во строк в TAB: ' + cast(@c as varchar(2));
if @flag = 'c' commit -- фиксация
else rollback; -- откат
SET IMPLICIT_TRANSACTIONS OFF -- действует режим автофиксации


if exists (select * from SYS.OBJECTS
where OBJECT_ID= object_id(N'DBO.TAB')) print N'таблица TAB есть';
else print N'таблицы TAB нет'

--2. Разработать сценарий, демонстрирующий свойство атомарности явной транзакции на примере базы данных X_UNIVER.
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках.
--Опробовать работу сценария при использовании различных операторов модификации таблиц.

begin try
begin tran
insert FACULTY values (N'ДФ', N'Факультет других наук');
insert FACULTY values (N'ПиМ', N'Факультет printt-технологий');
commit tran;
end try
begin catch
print N'ошибка:'+case
when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) >0
then N'дублирование товара'
else N'неизвестная ошибка' + cast(error_number() as varchar(5)) + error_message()
end;
if @@TRANCOUNT>0 rollback tran;
end catch;

--3. Разработать сценарий, демонстрирующий применение оператора SAVE TRAN на примере базы данных X_UNIVER.
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках.
--Опробовать работу сценария при использовании различных контрольных точек и различных операторов модификации таблиц.

declare @point nvarchar(32);
begin try
begin tran
insert FACULTY values(N'ФП',N'Факультет Психологии');
set @point='p1'; save tran @point;
insert FACULTY values(N'ЛФ',N'Факультет Лингвистики');
set @point='p2' ; save tran @point;
insert FACULTY values(N'МФ', N'Медицинский факультет');
commit tran;
end try
begin catch
print N'ошибка:' + case when error_number() = 2627
and patindex('%FACULTY_PK%', error_message()) > 0
then N'дублирование товара'
else N'неизвестная ошибка:' + cast(error_number() as varchar(5)) + error_message()
end
if @@trancount>0
begin
print N'контрольная точка:'+@point;
rollback tran @point;
commit tran;
end;
end catch;

--4 Разработать два сценария A и B на примере базы данных X_UNIVER.
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ UNCOMMITED, сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолчанию).
--Сценарий A должен демонстрировать, что уровень READ UNCOMMITED допускает неподтвержденное, неповторяющееся и фантомное чтение.

----------------A------------------
set transaction isolation level READ UNCOMMITTED
begin transaction
----------------t1-----------------
select @@SPID, 'insert FACULTY' N'результат', *
from FACULTY WHERE FACULTY = N'ИТ';
select @@SPID, 'update PULPIT' N'результат', *
from PULPIT WHERE FACULTY = N'ИТ';
commit;
---------------t2----------------------
----------B--------
begin transaction
select @@SPID

insert FACULTY values(N'ФФ',N'Факультет Физической культуры');
-------------t1---------------------
-------------t2---------------------
rollback;

--5.Разработать два сценария A и B на примере базы данных X_UNIVER.
--Сценарии A и В представляют собой явные транзакции с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, но при этом возможно неповторяющееся и фантомное чтение.

--А--
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from FACULTY where FACULTY=N'ИТ'
--------------t1---------------
--------------t2---------------
select 'update FACULTY' N'результат', count(*)
from FACULTY where FACULTY=N'ИТ'
commit;

--B--
begin transaction
------------t1--------------
update FACULTY set FACULTY=N'ИТ'
where FACULTY=N'ФИТ'
commit;
------------t2--------------

--6. Разработать два сценария A и B на примере базы данных X_UNIVER.
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать, что уровень REAPETABLE READ не допускает неподтвержденного чтения и неповторяющегося чтения, но при этом возможно фантомное чтение.

set transaction isolation level REPEATABLE READ
begin transaction
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t1 ------------------
-------------------------- t2 -----------------
select case
when PULPIT = N'ЛВ' then 'insert PULPIT' else ' '
end N'результат', PULPIT from PULPIT where FACULTY = N'ИТ';
commit;
--- B ---
begin transaction
-------------------------- t1 --------------------
insert PULPIT values (N'пратв', N'Полиграфических производств', N'ИДИП');
commit;
select * from PULPIT
-------------------------- t2 --------------------


--7--
-- A ---
set transaction isolation level SERIALIZABLE
begin transaction

insert PULPIT values (N'КГ', N'Компьютерная графика', N'ИТ');
commit;
update PULPIT set PULPIT = N'КГ' where FACULTY = N'ИТ';
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t1 -----------------
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t2 ------------------
commit;

--- B ---
begin transaction
insert PULPIT values (N'КБ', N'компьютерная безопсность', N'ИТ');
update PULPIT set PULPIT = N'КБ' where FACULTY = N'ИТ';
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t1 --------------------
commit;
select PULPIT from PULPIT where FACULTY = N'ИТ';
-------------------------- t2 --------------------
select * from PULPIT


--8--
select (select count(*) from dbo.PULPIT where FACULTY = N'ИДиП') N'Кафедры ИДИПа',
(select count(*) from FACULTY where FACULTY.FACULTY = N'ИДиП') N'ИДИП';

select * from PULPIT

begin tran
begin tran
update PULPIT set PULPIT_NAME=N'Кафедра ИДиПа' where PULPIT.FACULTY = N'ИДиП';
commit;
if @@TRANCOUNT > 0 rollback;