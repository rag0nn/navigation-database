
--KONUMLAR
CREATE TABLE konumlar (
	enlem1  FLOAT,
	boylam1 FLOAT,
	enlem2 FLOAT,
	boylam2 FLOAT,
	kita NVARCHAR(15),
	ulke NVARCHAR(30),
	bolge NVARCHAR(30),
	sehir NVARCHAR(30),
	ilce NVARCHAR(30),
	mahalle NVARCHAR(30)
);

INSERT INTO konumlar VALUES 
(40.2408031470367, 27.25756821883033,40.23658189523448, 27.27242160243754,'asya','türkiye','marmara','çanakkale','biga','þirintepe'),
(40.99922795261083, 29.055652097255084,41.005302790903514, 29.07493349678179,'asya','türkiye','marmara','istanbul','üsküdar','ünalan'),
(40.97644130425997, 29.04849549461281,40.985022448810746, 29.085687682769944,'asya','türkiye','marmara','istanbul','kadýköy','göztepe'),
(40.99691823112594, 28.689291964585745,40.97814106255418, 28.704971347289767,'avrupa','türkiye','marmara','istanbul','avcýlar','cihangir')

SELECT * FROM konumlar

--HAVAALANLARI

--türler
CREATE TABLE turHavaalani (
	kategoriId INT IDENTITY(1,1) PRIMARY KEY,
	kategori NVARCHAR(30)
);

INSERT INTO turHavaalani VALUES 
('iç hatlar'),('dýþ hatlar'),('iç-dýþ hatlar'),('askeri')

SELECT * FROM turHavaalani

CREATE TABLE havaalanlari (
	id INT IDENTITY(1,1) PRIMARY KEY,
	enlem FLOAT,
	boylam FLOAT,
	isim NVARCHAR(50),
	kategoriId INT FOREIGN KEY (kategoriId) REFERENCES turHavaalani(kategoriId),
	kapasiteUcak INT,
	kapasiteYolcu INT
);



INSERT INTO havaalanlari VALUES 
(41.27306796395118, 28.744903795514382,'Ýstanbul Havalimaný','3',300,20000),
(40.899427239519426, 29.306326147183476,'Sabiha Gökçen Havalimaný','3',100,10000),
(40.14013926942215, 26.43184230088652,'Çanakkale Havalimaný','1',10,2000)

SELECT * FROM havaalanlari

--SEFERLERHAVA

CREATE TABLE seferlerUcak (
	seferId INT IDENTITY(1,1) PRIMARY KEY,
	tarih DATETIME,
	kalkisHavaalaniId INT FOREIGN KEY (kalkisHavaalaniId) REFERENCES havaalanlari(id),
	varisHavaalaniId INT FOREIGN KEY (varisHavaalaniId) REFERENCES havaalanlari(id),
);

INSERT INTO seferlerUcak VALUES
('2023-12-28 12:00:00',1,2),
('2023-12-28 12:00:00',2,1),
('2024-01-10 10:00:00',3,1),
('2024-01-12 20:30:00',1,3),
('2024-01-03 08:00:00',2,3),
('2023-01-04 20:00:00',3,2)

SELECT * FROM seferlerUcak

--UCAK

CREATE TABLE ucaklar (
	id INT IDENTITY(1,1) PRIMARY KEY,
	enlem FLOAT,
	boylam FLOAT,
	seferId INT FOREIGN KEY (seferId) REFERENCES seferlerUcak(seferId),
	tur  NVARCHAR(20) CHECK (tur IN ('yolcu','askeri','eðitim',NULL)),
	hacim INT,
	motorSayisi INT,
	menzil INT
);

INSERT INTO ucaklar VALUES 
(40.48706970000483, 27.036067898522376,4,'yolcu',1000,1,10000),
(40.93615825579097, 29.039526923112934,1,'yolcu',1400,2,20000)

SELECT * FROM ucaklar

--TRENISTASYONLARI

CREATE TABLE trenIstasyonlari (
	id INT IDENTITY (1,1) PRIMARY KEY,
	isim NVARCHAR(50),
	enlem FLOAT,
	boylam FLOAT,
	uluslarasi BIT,
	kapasiteYolcu INT,
	kapasiteTren INT,
	komsuIstasyonlar INT FOREIGN KEY (komsuIstasyonlar) REFERENCES trenIstasyonlari(id)
);

INSERT INTO trenIstasyonlari VALUES
('Bostancý Tren Ýstasyonu',40.95270152420211, 29.094113476103452,0,500,2,1),
('Pendik Tren Ýstasyonu',40.88027365924282, 29.23154232697349,0,400,2,1),
('Gebze Tren Ýstasyonu',40.78387268177152, 29.410803730670366,0,500,6,2)

UPDATE trenIstasyonlari SET komsuIstasyonlar = 2 WHERE id = 1

SELECT * FROM trenIstasyonlari

--SEFERLERTREN

CREATE TABLE seferlerTren (
	seferId INT IDENTITY(1,1) PRIMARY KEY,
	tarih DATETIME,
	kalkisIstasyonId INT FOREIGN KEY (kalkisIstasyonId) REFERENCES trenIstasyonlari(id), 
	varisIstasyonId INT FOREIGN KEY (varisIstasyonId) REFERENCES trenIstasyonlari(id), 
);

INSERT INTO seferlerTren VALUES 
('2024-01-01  13:30:00',1,3),
('2024-01-01  12:00:00',3,1)

SELECT * FROM seferlerTren

--TREN

CREATE TABLE tren (
	id INT IDENTITY(1,1) PRIMARY KEY,
	isim NVARCHAR(30),
	enlem FLOAT,
	boylam FLOAT,
	seferId INT FOREIGN KEY (seferId) REFERENCES seferlerTren(seferId),
	tur NVARCHAR(20)  CHECK (tur IN ('yolcu','yük'))
);

INSERT INTO tren VALUES
('TCDD-220123',40.80247238954702, 29.374953535641964,1,'yolcu'),
('TCDD-210610',40.902598516224806, 29.217768707117635,2,'yolcu')

SELECT * FROM tren

--VAPURLÝMANLARI

CREATE TABLE vapurLimanlari (
	id INT IDENTITY (10000,5) PRIMARY KEY,
	isim NVARCHAR (30),
	enlem FLOAT,
	boylam FLOAT,
	uluslararasi BIT,
	kapasiteBuyukGemi INT,
	kapasiteOrtaGemi INT,
	kapasiteKucukGemi INT,
);

INSERT INTO vapurLimanlari VALUES 
('Pendik Vapur Limaný',40.874296727383026, 29.236340069376805,0,0,2,40),
('Harem Vapur Limaný',41.01060741434491, 29.009969034931014,1,5,10,0),
('Haydarpaþa Vapur Ýskelesi',40.996834784083944, 29.019209694370588,0,0,8,0),
('Çanakkale Vapur Limaný',40.15036201371293, 26.4022374272821,1,2,5,60)

SELECT * FROM vapurLimanlari
--SEFERLERVAPUR

CREATE TABLE seferlerVapur (
	seferId INT IDENTITY(1,1) PRIMARY KEY,
	tarih DATETIME,
	kalkisLimanId INT FOREIGN KEY (kalkisLimanId) REFERENCES vapurLimanlari(id),
	varisLimanId INT FOREIGN KEY (varisLimanId) REFERENCES vapurLimanlari(id), 
);

INSERT INTO seferlerVapur VALUES
('2024-01-01  13:30:00',10005,10015),
('2024-01-04  09:45:00',10015,10005)

SELECT * FROM seferlerVapur

--VAPUR

CREATE TABLE vapur (
	id  INT IDENTITY (1,1) PRIMARY KEY,
	isim NVARCHAR(30),
	enlem FLOAT,
	boylam FLOAT,
	seferId INT FOREIGN KEY (seferId) REFERENCES seferlerVapur(seferId),
	tur NVARCHAR(20) CHECK (tur IN  ('kucuk','orta','buyuk'))
);

INSERT INTO vapur VALUES
('Piri Reis 3',40.11911727477272, 26.376209549161835,3,'orta'),
('Alaca 1',40.799396264667294, 27.8124717717758261,4,'orta')

SELECT * FROM vapur


-- NULL OLMAMASI GEREKENLER
ALTER TABLE seferlerUcak ALTER COLUMN tarih DATETIME NOT NULL;
ALTER TABLE seferlerUcak ALTER COLUMN kalkisHavaalaniId INT NOT NULL;
ALTER TABLE seferlerUcak ALTER COLUMN varisHavaalaniId INT NOT NULL;

ALTER TABLE seferlerTren ALTER COLUMN tarih DATETIME NOT NULL;
ALTER TABLE seferlerTren ALTER COLUMN kalkisIstasyonId INT NOT NULL;
ALTER TABLE seferlerTren ALTER COLUMN varisIstasyonId INT NOT NULL;

ALTER TABLE seferlerVapur ALTER COLUMN tarih DATETIME NOT NULL;
ALTER TABLE seferlerVapur ALTER COLUMN kalkisLimanId INT NOT NULL;
ALTER TABLE seferlerVapur ALTER COLUMN varisLimanId INT NOT NULL;

--uçaklara isim kolonu unutulduðu için isim kolonu eklemek
ALTER TABLE ucaklar ADD isim NVARCHAR(20); 
SELECT * FROM ucaklar

UPDATE ucaklar SET isim = 0 WHERE isim IS NULL;

ALTER TABLE ucaklar ALTER COLUMN isim NVARCHAR NOT NULL;

ALTER TABLE tren ALTER COLUMN isim NVARCHAR(30) NOT NULL;
ALTER TABLE vapur ALTER COLUMN isim NVARCHAR(30) NOT NULL;

ALTER TABLE konumlar ALTER COLUMN ulke NVARCHAR(30) NOT NULL;
ALTER TABLE konumlar ALTER COLUMN sehir NVARCHAR(30) NOT NULL;
ALTER TABLE konumlar ALTER COLUMN kita NVARCHAR(30) NOT NULL;
ALTER TABLE konumlar ALTER COLUMN bolge NVARCHAR(30) NOT NULL;

--kolon isimlerini deðiþtirmek
exec sp_rename 'tren', 'trenler'
exec sp_rename 'vapur','vapurlar' 
SELECT * FROM trenler
SELECT * FROM vapurlar