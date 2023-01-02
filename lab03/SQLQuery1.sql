USE master;
CREATE DATABASE DRUGAKOV_MyBASE on primary
( name = N'SHOP_mdf', filename = N'D:\study\BD\lab03\SHOP.mdf', 
   size = 10240Kb, maxsize=UNLIMITED, filegrowth=1024Kb),
( name = N'SHOP_ndf', filename = N'D:\study\BD\lab03\SHOP.ndf', 
   size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1
( name = N'SHOP_fg1_1', filename = N'D:\study\BD\lab03\SHOP_fgq-1.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'SHOP_fg1_2', filename = N'D:\study\BD\lab03\SHOP_fgq-2.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
( name = N'SHOP_log', filename=N'D:\study\BD\lab03\SHOP_log.ldf',       
   size=10240Kb,  maxsize=2048Gb, filegrowth=10%)

DROP TABLE Адресс;
CREATE TABLE Адресс
(	Адресс_id int primary key,
	Город nvarchar(50),
	Улица nvarchar(50),
	Дом int,
	Квартира int
)on FG1;

DROP TABLE Поставщик;
CREATE TABLE Поставщик
(	Код_поставщика int primary key,
	Название_поставщика nvarchar(50),
	Адрес_id int foreign key references Адресс(Адресс_id),
	Телефон nvarchar(15)
)on FG1;

DROP TABLE Деталь;
CREATE TABLE Деталь
(	Артикул nvarchar(50) primary key,
	Название_детали nvarchar(50),
	Количество_деталей_на_складе int,
	Цена float,
	Код_поставщика int foreign key references Поставщик(Код_поставщика) 
)on FG1;

DROP TABLE Заказ;
CREATE TABLE Заказ
(	Номер_заказа int primary key,
	Артикул_детали nvarchar(50) foreign key references Деталь(Артикул),
	Дата_заказа date,
	Примечание nvarchar(50)
)on FG1;

ALTER TABLE Заказ ADD Количество_заказанных_деталей int;

INSERT into Адресс(Адресс_id, Город, Улица, Дом, Квартира)
	Values (1, N'минск', N'белорусcкая', 21, 706),
		(2, N'могилёв', N'витебск', 41, 69),
		(3, N'баранавичи', N'наконечникова', 3, 95),
		(4, N'гомель', N'косарева', 41, 108),
		(5, N'минск', N'белорусская', 13, 1);

INSERT into Поставщик(Код_поставщика, Название_поставщика, Адрес_id, Телефон)
	Values(11, N'порше', 1 , N'+375298467777'),
	(12, N'бмв', 2 , N'+375298467778'),
	(13, N'ауди', 3 , N'+375298467779'),
	(14, N'бентли', 4 , N'+375298467785'),
	(15, N'лада', 5 , N'+375298467999');

INSERT into Деталь(Артикул, Название_детали, Количество_деталей_на_складе, Цена, Код_поставщика)
	Values(N'124564', N'подшипник', 25 , 12 , 13),
	(N'424255', N'гайка', 914124 , 3 , 15),
	(N'424635', N'гайка', 914 , 514 , 13),
	(N'523523', N'дверь', 2 , 980 , 14),
	(N'535235', N'крыло', 5 , 460 , 11),
	(N'897324', N'поршень', 13 , 45 , 12);

INSERT into Заказ(Номер_заказа, Артикул_детали, Количество_заказанных_деталей, Дата_заказа, Примечание)
	Values(1, N'897324', 2 , '2022-08-07' , N'быстрее'),
	(2, N'535235', 3 , '2022-09-14' , N'хорош'),
	(3, N'523523', 2 , '2021-05-25' , N'лучший'),
	(4, N'897324', 3 , '2022-09-23' , N'мощь'),
	(5, N'424255', 450 , '2022-12-01' , N'кайф');

SELECT Номер_заказа, Артикул_детали, Количество_заказанных_деталей FROM Заказ WHERE Количество_заказанных_деталей < 4;
	
SELECT DISTINCT Название_детали FROM  Деталь;

UPDATE Заказ set Примечание = N'спасибо' Where Количество_заказанных_деталей = 2;

SELECT * FROM Заказ;

SELECT count (*) from Заказ; 

SELECT top (2) Номер_заказа from Заказ; 
  
alter table Заказ Drop Column Количество_деталей_на_складе;

DELETE from Заказ Where Примечание = 'спасибо';