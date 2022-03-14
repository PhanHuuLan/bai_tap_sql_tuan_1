create database QLMH;
use QLMH;

 

create table CUSTOMER(
    maKH varchar(10) primary key,
    hoten varchar(100),
    email varchar(100),
    sdt varchar(10),
    diachi varchar(100)
)

 

create table PAYMENT(
    maTT varchar(10) primary key,
    tenPTTT varchar(100),
    phiTT money
)

 

create table ORDERS(
    maDH varchar(10) primary key,
    ngaydat date,
    trangthai varchar(10),
    tongtien money,
    maKH varchar(10),
    maTT varchar(10)
)

 

create table PRODUCT(
    maSP varchar(10) primary key,
    tenSP varchar(100),
    mota varchar(100),
    giaSP money,
    soluongSP int
)

 

create table ORDER_DETAILS(
    maCTSP varchar(10) primary key,
    soluongmua int,
    gia money,
    thanhtien money,
    maDH varchar(10),
    maSP varchar(10)
)

 

alter table ORDERS add foreign key(maKH) references CUSTOMER(maKH)
alter table ORDERS add foreign key(maTT) references PAYMENT(maTT)
alter table ORDER_DETAILS add foreign key(maDH) references ORDERS(maDH)
alter table ORDER_DETAILS add foreign key(maSP) references PRODUCT(maSP)

 

INSERT INTO CUSTOMER VALUES
--MaKH            hoten            email            sdt            diachi
('MKH01','Phan Huu Lan',    'lanhuu@gmail.com','0339410753','Hai Chau'),
('MKH02','Vo Dai Hua',    'daihua@gmail.com','0339410357','Lien Chieu'),
('MKH03','Phan Huu A',        'huua@gmail.com','0339410123','Hoa Vang');

 

INSERT INTO PAYMENT VALUES
--MaTT        TenTTT        PhiTT
('MaTT01',    'MOMO',        10000),
('MaTT02',    'ATM',        10000);

 

INSERT INTO ORDERS VALUES
--MaDH        ngaydat            trangthai    tongtien    MaKH    MaTT
('MDH01',    '2016/10/20',    'Cho Xu Ly',7000000,        'MKH01','MaTT01'),
('MDH02',    '2018/10/19',    'Cho Xu Ly',14000000,        'MKH01','MaTT01'),
('MDH03',    '2020/10/09',    'Da Xu Ly',    6000000,        'MKH01','MaTT01');

 

INSERT INTO PRODUCT VALUES
--MaSP    tenSP        mota            giaSP    soluongSP
('SP01','samsum',    'android 9.0',    6000000,10),
('SP02','oppo',        'android 8.0',    7000000,10),
('SP03','iphone11',        'ios 14.0',    14000000,10);

 

INSERT INTO ORDER_DETAILS VALUES
('CTSP01',1,600000,6010000,'MDH03','SP01'),
('CTSP02',1,700000,7010000,'MDH01','SP02'),
('CTSP03',1,1400000,14010000,'MDH02','SP03');

 

--VIEW
---- 1.1 Tạo khung nhìn có tên là CUSTOMER_VIEW để xem thông tin KH
create view CUSTOMER_VIEW as
select maKH, hoten, sdt
from  CUSTOMER;

select * from CUSTOMER_VIEW;
----1.2 Tạo khung nhìn có tên là Customer_Processing để xem thông tin của 
--khách hàng đã có trạng thái đặt hàng là "Da Xu Ly"
create view Customer_Processing
as
select customer.*, ORDERS.trangthai from CUSTOMER
inner join ORDERS on CUSTOMER.maKH = ORDERS.maKH
where ORDERS.trangthai = 'Da Xu Ly'

select * from Customer_Processing
--PROCEDURE
---- 1.1 them Khach hang
create proc q_AddCustomer(
	 @maKH varchar(10),
    @hoten varchar(100),
    @email varchar(100),
    @sdt varchar(10),
    @diachi varchar(100)
)
as
begin
	if exists(select maKH from CUSTOMER
	where maKH = @maKH)
	begin
		print N'Mã KHÁCH HÀNG đã tồn tại'
		return
	end
	insert into CUSTOMER
	values (@maKH, @hoten, @email, @sdt, @diachi)
end

exec q_AddCustomer @maKH = 'MKH04', @hoten = 'Phan Huu B', @email = 'huub@gmail.com', @sdt = '0339410001', @diachi = 'Ha Noi';

select * from CUSTOMER

---- 1.2 sua thong tin khach hang
create proc P_UpdateCustomer(
	@maKH varchar(10),
	@name nvarchar(50),
	@email varchar(50),
	@phone nvarchar(50),
	@adress nvarchar(50)
)
as
begin
	if not exists(select maKH from CUSTOMER
	where maKH = @maKH)
	begin
		print N'Khách hàng không tồn tại!'
		return
	end
	update CUSTOMER
	set hoten = @name, email = @email, sdt = @phone, diachi = @adress
	where maKH = @maKH
end

exec P_UpdateCustomer @maKH = 'MKH01', @name = 'Phan Huu Lan Lan',@email = 'lanhuu@gmail.com', @phone = '0339410753', @adress = 'Da Nang'
select * from CUSTOMER


-- FUNCTION: 
---- 1.1: đếm tổng tiền trong bảng Oders
create function Sum_Oders()
returns int
as
begin
	declare @tong int
	select @tong = SUM(tongtien)
	from ORDERS
	return @tong
end

select dbo.Sum_Oders() Tong_Tien;
----Vo Dai Hua
create function SanPham(@TenSP VARCHAR(100))
returns Int
as
begin
		declare @SoLuongSanPham int
		select @SoLuongSanPham= soluongSP from DBO.PRODUCT where  tenSP = @tenSP
		return @SoLuongSanPham
end

select dbo.SanPham('samsum') as soluongSP

drop function SanPham
---Vanni---
--- trigger---
create trigger demo1SSS on CUSTOMER
FOR UPDATE, INSERT
AS
BEGIN
    PRINT'NHAP THANH CONG'
END
GO
INSERT INTO CUSTOMER VALUES
	('MKH04','Hang Nguyen','ha@gmail.com','0339410120','Hoa Vang');
GO
---------------------------------
SELECT	*from CUSTOMER
GO



