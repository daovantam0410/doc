CREATE DATABASE QuanLyBanHang
ON PRIMARY
	(NAME = QuanLyBanHang_Data,
	FILENAME='C:\Program Files\Microsoft SQL Server\
         MSSQL10.MSSQLSERVER\MSSQL\DATA\QLBanhang_Data.mdf',
    SIZE=100MB,
    MAXSIZE=200MB,
    FILEGROWTH=10MB)
LOG ON
	(NAME = QuanLyBanHang_Log,
	FILENAME='C:\Program Files\Microsoft SQL Server\
         MSSQL10.MSSQLSERVER\MSSQL\DATA\QLBanhang_Log.ldf',
    SIZE=30MB,
    MAXSIZE=UNLIMITED,
    FILEGROWTH=5MB)	
    
CREATE TABLE VATTU
(
	MaVTu char(4),
	TenVTu nvarchar(100),
	DvTinh nvarchar(10),
	PhanTram real
)

CREATE TABLE NCC
(
	MaNCC char(3),
	TenNCC nvarchar(100),
	Diachi nvarchar(10),
	Dienthoai varchar(20)
)

CREATE TABLE DONDH
(
	SoDH char(4),
	NgayDH datetime,
	MaNCC char(3)
)

CREATE TABLE CTDONDH
(
	SoDH char(4),
	MaVTu char(4),
	SlDat int
)

CREATE TABLE PNHAP
(
	SoPN char(4),
	Ngaynhap datetime,
	SoDH char(4)
)

CREATE TABLE CTPNHAP
(
	SoPN char(4),
	MaVTu char(4),
	SlNhap int,
	DgNhap money
)

CREATE TABLE PXUAT
(
	SoPX char(4),
	Ngayxuat datetime,
	TenKH nvarchar(100)
)

CREATE TABLE CTPXUAT
(
	SoPX char(4),
	MaVTu char(4),
	SlXuat int,
	DgXuat money
)

CREATE TABLE TONKHO
(
	Namthang char(6),
	MaVTu char(4),
	SlDau int,
	TongSLN int,
	TongSLX int,
	SlCuoi int
)

ALTER TABLE VATTU
ADD CONSTRAINT PK_VATTU PRIMARY KEY(MaVTu)

ALTER TABLE VATTU
ADD UNIQUE(TenVTu)