use QuanLyTrangSuc;

/*----- TRIGGER -----*/

/*---BẢNG TIÊU ĐỀ---*/
/*Thêm TIEUDE*/
create trigger Them_Tieude on TIEUDE
for insert
as
	declare @dem int, @Tentieude nvarchar(50)
	select @Tentieude = TenTieuDe from inserted
	select @dem = COUNT(TenTieuDe) from TIEUDE where TenTieuDe=@Tentieude
	if @dem >= 2
begin
	print N'Tên tiêu đề '+@Tentieude+N' đã tồn tại! Mời bạn nhập tên khác'
	rollback tran
end

/*Sửa TIEUDE*/
create trigger Sua_Tieude on TIEUDE
for update
as
begin
	declare @dem int, @Tentieude nvarchar(50)
	if update(MaTieuDe)
		begin
			rollback tran
			print N'Không được sửa Mã tiêu đề!'
			return
		end
	select @Tentieude = TenTieuDe from inserted
	select @dem = COUNT(TenTieuDe) from TIEUDE where TenTieuDe=@Tentieude
	if @dem >= 2
		begin
			rollback tran
			print N'Tên tiêu đề '+@Tentieude+N' đã tồn tại! Mời bạn nhập tên khác'
		end
end

/*Xóa TIEUDE*/
create trigger Xoa_Tieude on TIEUDE
for delete
as
	declare @MaDanhMuc nchar(5)
	if exists(select MaDanhMuc from DANHMUC
	where MaTieuDe in(select MaTieuDe from deleted))				
begin
	rollback tran
	select @MaDanhMuc=MIN(MaDanhMuc)from DANHMUC
	where MaTieuDe in(select MaTieuDe from deleted)
	print N'Bạn phải xóa danh mục trước!'
end

/*---BẢNG DANH MỤC---*/
/*Thêm DANHMUC*/
create trigger Them_Danhmuc on DANHMUC
for insert
as
	declare @dem int, @Madanhmuc nvarchar(50)
	select @Madanhmuc = MaDanhMuc from inserted
	select @dem = COUNT(MaDanhMuc) from DANHMUC where MaDanhMuc=@Madanhmuc
	if @dem >= 2
begin
	print N'Mã danh mục ' + @Madanhmuc + N' đã tồn tại! Mời bạn nhập mã khác'
	rollback tran
end

/*Sửa DANHMUC*/
create trigger Sua_Danhmuc on DANHMUC
for update
as
	if update(Ma)
begin
	rollback tran
	print N'Không được sửa Mã tiêu đề!'
	return
end

/*Xóa DANHMUC*/
create trigger Xoa_DANHMUC on DANHMUC
for delete
as
	declare @MaTieuDe nchar(5), @ErrorMsg nvarchar(200)
	if exists(select MaTieuDe from TIEUDE
	where MaDanhMuc in (select MaDanhMuc from deleted))
begin
	select @MaTieuDe = MIN(MaTieuDe)from TIEUDE where MaDanhMuc in(select MaDanhMuc from deleted)
	set @ErrorMsg = N'Mã danh mục đã được đặt theo mã tiêu đề '+@MaTieuDe+N'. Không thể xóa mã danh mục này!'
	Raiserror(@ErrorMsg,16,1)
	rollback tran
end

/*Thêm PHIEUNHAP*/
create trigger Them_PHIEUNHAP on PHIEUNHAP
for insert
as
	declare @NgayDH datetime, @ErrMessage char(200)
	if not exists(select * from inserted,DONDH where inserted.MaDH=DONDH.MaDH)
begin
	rollback tran
	print N'Mã đơn hàng không tồn tại!'
end
	select @NgayDH=NgayDH from Inserted,DONDH
	where Inserted.MaDH=DONDH.MaDH
	if @NgayDH > (select Ngaynhap from Inserted)
begin
	rollback tran
	set @ErrMessage = N'Ngày nhập hàng phải sau ngày đặt hàng'+convert(char(10),@NgayDH,103)
	print @ErrMessage
end

/*Xóa PHIEUNHAP*/
create trigger Xoa_PHIEUNHAP on PHIEUNHAP
for delete
as
begin

end

/*Sửa PHIEUNHAP*/
create trigger Sua_PHIEUNHAP on PHIEUNHAP
for update
as
	declare @NgayDH datetime, @ErrMessage char(200)
	select @NgayDH=NgayDH from Inserted,DONDH
	where Inserted.MaDH=DONDH.MaDH
	if @NgayDH > (select Ngaynhap from Inserted)
begin
	rollback tran
	set @ErrMessage = N'Ngày nhập hàng phải sau ngày đặt hàng'+convert(char(10),@NgayDH,103)
	print @ErrMessage
end

/*Xóa PHIEUNHAP*/

/*Thêm VATTU*/
create trigger Them_VATTU on VATTU
for insert
as
	declare @dem int, @TenVatTu nvarchar(50)
	select @TenVatTu=TenVatTu from inserted
	select @dem=COUNT(TenVatTu) from VATTU where TenVatTu=@TenVatTu
	if @dem >= 2
begin
	rollback tran
	print N'Tên vật tư đã tồn tại! Yêu cầu chọn tên khác'
end

/*Sửa VATTU*/
create trigger Sua_VATTU on VATTU
for update
as
begin
end
/*Thêm DONDH*/
create trigger Them_DONDH on DONDH
for insert
as
begin
end

/*Sửa DONDH*/
create trigger Sua_DONDH on DONDH
for update
as
begin
end

/*Xóa DONDH*/
create trigger Xoa_DONDH on DONDH
for delete
as
begin
end

/*----- FUNCTION -----*/

/*HÀM ĐỌC BẢNG*/

/*1. Xây dựng hàm đọc bảng hiển thị danh sách vật tư*/
create function DanhSachVatTu()
	returns table
as
	return select*from VATTU
/*thực thi function*/	
select * from DanhSachVatTu()

/*2. Xây dựng hàm đọc bảng hiển thị danh sách vật tư đồng hồ*/
create function DanhSachDongHo()
	returns table
as
	return select * from VATTU 
			where TenVatTu like N'%Đồng hồ%'
/*thực thi function*/
select * from DanhSachDongHo()

/*3. Xây dựng hàm đọc bảng hiển thị danh sách khách hàng*/
create function DanhSachKhachHang()
	returns table
as
	return select*from KHACHHANG
/*thực thi function*/	
select * from DanhSachKhachHang()

/*4. Xây dựng hàm đọc bảng hiển thị danh sách các nhà cung cấp*/
create function DanhSachNhaCungCap()
	returns table
as
	return select*from NHACC
/*thực thi function*/	
select * from DanhSachNhaCungCap()

/*5. Xây dựng hàm đọc bảng hiển thị danh sách các vật tư đã được đặt hàng*/
create function DanhSachVatTuDaDuocDatHang()
	returns table
as
	return (select CTDONDH.MaDH, CTDONDH.MaVatTu,VATTU.TenVatTu 
	from DONDH inner join CTDONDH
	on DONDH.MaDH=CTDONDH.MaDH
	inner join VATTU
	on VATTU.MaVatTu=CTDONDH.MaVatTu)	
/*thực thi function*/	
select * from DanhSachVatTuDaDuocDatHang()

/*HÀM ĐƠN TRỊ*/

/*1. Tongnhapthang(@MaVTu,@Namthang) trả về tổng số lượng đã nhập của vật tư theo năm tháng 
(dữ liệu được lấy từ bảng CTPNHAP)*/
create function Tongnhapthang(@MaVTu nchar(10),@Namthang char(7))
	returns int
as
	begin
		declare @tongsln int
		select @tongsln = sum(SoLuongNhap) 
		from CTPHIEUNHAP inner join PHIEUNHAP 
		on CTPHIEUNHAP.MaPN=PHIEUNHAP.MaPN 
		where MaVatTu=@MaVTu and convert(char(7),Ngaynhap,21)=@Namthang
		
		return @tongsln
	end
print N'Tổng số lượng nhập của mã vật tư VT01 trong tháng 2 năm 2017 là: ' 
+ cast(dbo.Tongnhapthang('VT01','2017-02') as char(15))

/*2. Tongxuatthang(@MaVTu,@Namthang) trả về tổng số lượng đã xuất của vật tư theo năm tháng 
(dữ liệu được lấy từ bảng CTPXUAT)*/
create function Tongxuatthang(@MaVTu char(4),@Namthang char(7))
	returns int
as
	begin
		declare @tongslx int
		
		select @tongslx=sum(SoLuongXuat)
		from CTPHIEUXUAT inner join PHIEUXUAT
		on CTPHIEUXUAT.MaPX=PHIEUXUAT.MaPX
		where MaVatTu=@MaVTu and convert(char(7),NgayXuat,21)=@Namthang
		
		return @tongslx
	end
print N'Tổng số lượng xuất của mã vật tư VT01 trong tháng 11 năm 2019 là: '
+cast(dbo.Tongxuatthang('VT01','2019-11') as char(15))

/*3. Tongdathang(@MaVTu, @Namthang) trả về tổng số lượng đặt của vật tư theo năm tháng
(dữ liệu lấy từ bảng CTDONDH)*/
create function Tongdathang(@MaVTu nchar(10), @Namthang char(7))
	returns int
as
	begin
		declare @tongsld int
		select @tongsld=SUM(Soluong)
		from CTDONDH inner join DONDH
		on CTDONDH.MaDH=DONDH.MaDH
		where MaVatTu=@MaVTu and CONVERT(char(7),NgayDH,21)=@Namthang
		return @tongsld
	end
print N'Tổng số lượng đặt của mã vật tư VT01 trong tháng 12 năm 2016 là: '
+cast(dbo.Tongdathang('VT01','2016-12') as char(15))

/*4. Tongnhap(@SoDh,@MaVTu) trả về số lượng đã nhập của vật tư theo số đơn đặt hàng*/
create function Tongnhap(@MaDH nchar(5), @MaVTu nchar(10))
	returns int
as
	begin
		declare @tongsln int
		select @tongsln=SUM(SoLuongNhap)
		from CTPHIEUNHAP inner join PHIEUNHAP
		on CTPHIEUNHAP.MaPN=PHIEUNHAP.MaPN
		inner join DONDH
		on DONDH.MaDH=PHIEUNHAP.MaDH
		where MaVatTu=@MaVTu and DONDH.MaDH=@MaDH
		
		return @tongsln
	end 
	
	print N'Tổng số lượng đã nhập của vật tư VT01 theo số đơn hàng DH01 là: '+
	cast(dbo.Tongnhap('DH01','VT01') as char(15))
	
/*5. Tongdongiaban(@Namthang) trả về tổng số tiền bán được trong tháng 11/2019*/
create function Tongdongiaban(@Namthang char(7))
	returns float
as
	begin
		declare @tongslgban float
		select @tongslgban = SUM(DonGiaXuat) from CTPHIEUXUAT
		inner join PHIEUXUAT
		on CTPHIEUXUAT.MaPX=PHIEUXUAT.MaPX
		where CONVERT(char(7),NgayXuat,21)=@Namthang
		
		return @tongslgban
	end
	
	print N'Tổng số tiền bán được trong tháng 12/2019 là: '
	+cast(dbo.Tongdongiaban('2019-12') as char(15))
	
/*HÀM TẠO BẢNG*/

/*1. Tạo hàm tạo bảng lưu danh sách hàng xuất với giá khuyến mãi, tham số truyền vào là mã vật tư và phần trăm khuyến mãi*/
create function DSHangXuat(@MaVatTu nchar(5), @Phantram numeric)
returns @DSHangXuat table(
	MaPX char(5),
	MaVatTu char(5),
	SoLuongXuat int,
	GiaKhuyenMai float)
as
begin
	insert into @DSHangXuat(MaPX,MaVatTu,SoLuongXuat,GiaKhuyenMai)
	select * from CTPHIEUXUAT where MaVatTu=@MaVatTu
	update @DSHangXuat
	set GiaKhuyenMai=GiaKhuyenMai*(100-@Phantram)/100
	return
end

select * from DSHangXuat('VT01','20')
/*2. */
/*3. */
/*3. */
/*4. */

/*----- PROCEDURE -----*/

/*TABLE TIEUDE*/
/*thêm proc*/
create proc themTIEUDE
as
	insert into TIEUDE(MaTieuDe,TenTieuDe) values('TD05',N'Kim cương')
	
exec themTIEUDE

/*sửa proc*/
create proc suaTIEUDE
@maTieuDe nchar(10), @tenTieuDe nvarchar(50)
as	
	update TIEUDE
	set TenTieuDe=@tenTieuDe
	where MaTieuDe=@maTieuDe

exec suaTIEUDE @maTieuDe='TD05', @tenTieuDe=N'Khuyến mãi'

/*xóa proc*/
create proc xoaTIEUDE
@maTieuDe nchar(10)
as
	delete from TIEUDE where MaTieuDe=@maTieuDe

exec xoaTIEUDE @maTieuDe='TD05'
	
/*TABLE DANHMUC*/
/*Thêm*/
create proc themDANHMUC
@madanhmuc nchar(5),
@tendanhmuc nvarchar(50),
@matieude nchar(10)
as
	insert into DANHMUC(MaDanhMuc,TenDanhMuc,MaTieuDe)
	values(@madanhmuc,@tendanhmuc,@matieude)
	
exec themDANHMUC
@madanhmuc = 'DM11',
@tendanhmuc = N'Nhẫn',
@matieude='TD05'

/*Sửa*/
create proc suaDANHMUC
@madanhmuc nchar(5),
@tendanhmuc nvarchar(50)
as
	update DANHMUC
	set TenDanhMuc=@tendanhmuc
	where MaDanhMuc=@madanhmuc
	
exec suaDANHMUC
@madanhmuc = 'DM11',
@tendanhmuc = N'Vòng tay'

/*xóa proc*/
create proc xoaDANHMUC
@madanhmuc nchar(5)
as
	delete from DANHMUC where MaDanhMuc=@madanhmuc

exec xoaDANHMUC @madanhmuc='DM11'

/*TABLE KHACHHANG*/
/*Thêm*/
create proc themKHACHHANG
@makh nchar(5),
@tenkh nvarchar(50),
@diachi nvarchar(50),
@sdt varchar(11),
@email varchar(50),
@gioitinh nchar(4)
as
	insert into KHACHHANG(MaKH,TenKH,DiaChi,SDT,Email,GioiTinh)
	values(@makh,@tenkh,@diachi,@sdt,@email,@gioitinh)
	
exec themKHACHHANG
@makh = 'KH04',
@tenkh = N'Nguyễn Văn A',
@diachi = 'HCM',
@sdt = '0364792164',
@email = 'abc@gmai.com',
@gioitinh = 'nam'

/*sửa*/
create proc suaKHACHHANG
@makh nchar(5),
@tenkh nvarchar(50)
as
	update KHACHHANG
	set TenKH=@tenkh
	where MaKH=@makh
	
exec suaKHACHHANG
@makh = 'KH04',
@tenkh = N'Nguyễn Văn B'

/*xóa*/
create proc xoaKHACHHANG
@makh nchar(5)
as
	delete from KHACHHANG
	where MaKH=@makh
	
exec xoaKHACHHANG
@makh = 'KH04'

/*TABLE VATTU*/
/*thêm*/
create proc themVATTU
@mavtu nchar(10),
@tenvtu nvarchar(50),
@thongtin nvarchar(50),
@gia float,
@tinhtrang nvarchar(50),
@madanhmuc nchar(5),
@kichco int
as
	insert into VATTU(MaVatTu,TenVatTu,ThongTin,Gia,TinhTrang,MaDanhMuc,Kichco)
	values(@mavtu,@tenvtu,@thongtin,@gia,@tinhtrang,@madanhmuc,@kichco)
	
exec themVATTU
@mavtu = 'VT15',
@tenvtu = N'Nhẫn',
@thongtin = N'Đang cập nhật',
@gia = 3000000,
@tinhtrang = N'còn hàng',
@madanhmuc = 'DM01',
@kichco = 15

/*sửa*/
create proc suaVATTU
@mavtu nchar(10),
@tenvtu nvarchar(50),
@thongtin nvarchar(50),
@tinhtrang nvarchar(50)
as
	update VATTU
	set TenVatTu=@tenvtu,ThongTin=@thongtin,TinhTrang=@tinhtrang
	where MaVatTu=@mavtu
	
exec suaVATTU
@mavtu = 'VT15',
@tenvtu = N'Vòng tay',
@thongtin = N'Đang cập nhật',
@tinhtrang = N'hết hàng'

/*xóa*/
create proc xoaVATTU
@mavtu nchar(10)
as
	delete from VATTU
	where MaVatTu=@mavtu
	
exec xoaVATTU
@mavtu = 'VT15'

/*TABLE PHIEUXUAT*/
/*THÊM*/
create proc themPHIEUXUAT
@maphieuxuat nchar(5),
@ngayxuat datetime,
@makh nchar(5)
as
	insert into PHIEUXUAT(MaPX,NgayXuat,MaKH)
	values(@maphieuxuat,@ngayxuat,@makh)

exec themPHIEUXUAT
@maphieuxuat = 'PX10',
@ngayxuat = '11/4/2019',
@makh = 'KH03'

/*sửa*/
create proc suaPHIEUXUAT
@maphieuxuat nchar(5),
@makh nchar(5)
as
	update PHIEUXUAT
	set MaKH=@makh
	where MaPX=@maphieuxuat
	
exec suaPHIEUXUAT
@maphieuxuat='PX10',
@makh='KH01'

/*xóa*/
create proc xoaPHIEUXUAT
@maphieuxuat nchar(5)
as
	delete from PHIEUXUAT
	where MaPX=@maphieuxuat

exec xoaPHIEUXUAT
@maphieuxuat='PX10'

/*TABLE CTPHIEUXUAT*/
/*THÊM*/
create proc themCTPHIEUXUAT
@maphieuxuat nchar(5),
@mavtu nchar(10),
@slgxuat int,
@dgxuat float
as
	insert into CTPHIEUXUAT(MaPX,MaVatTu,SoLuongXuat,DonGiaXuat) 
	values(@maphieuxuat,@mavtu,@slgxuat,@dgxuat)
	
exec themCTPHIEUXUAT
@maphieuxuat='PX10',
@mavtu='VT01',
@slgxuat=2,
@dgxuat=2025000

/*SỬA*/
create proc suaCTPHIEUXUAT
@maphieuxuat nchar(5),
@mavtu nchar(10),
@slgxuat int,
@dgxuat float
as
	update CTPHIEUXUAT
	set MaVatTu=@mavtu,
		SoLuongXuat=@slgxuat,
		DonGiaXuat=@dgxuat
	where MaPX=@maphieuxuat
	
exec suaCTPHIEUXUAT
@maphieuxuat='PX10',
@mavtu='VT02',
@slgxuat=3,
@dgxuat=480000

/*XÓA*/
create proc xoaCTPHIEUXUAT
@maphieuxuat nchar(5),
@mavtu nchar(10)
as
	delete from CTPHIEUXUAT
	where MaPX=@maphieuxuat and MaVatTu=@mavtu
	
exec xoaCTPHIEUXUAT
@maphieuxuat='PX10',
@mavtu='VT02'

/*TABLE NHACC*/

/*THÊM*/
create proc themNHACC
	@mancc nchar(5),
	@tenncc nvarchar(50),
	@diachi nvarchar(50),
	@sdt varchar(11)
as
	insert into NHACC(MaNCC,TenNCC,DiaChi,SDT)
	values(@mancc,@tenncc,@diachi,@sdt)
	
exec themNHACC
	@mancc='NCC04',
	@tenncc=N'PNJ Chi Nhánh Hoàn Kiếm',
	@diachi=N'49 hai bà trưng, hoàn kiếm, hà nội',
	@sdt='0132636345'
	
/*SỬA*/
create proc suaNHACC
	@mancc nchar(5),
	@tenncc nvarchar(50),
	@diachi nvarchar(50),
	@sdt varchar(11)
as
	update NHACC
	set TenNCC=@tenncc,
		DiaChi=@diachi,
		SDT=@sdt
	where MaNCC=@mancc
	
exec suaNHACC
	@mancc='NCC04',
	@tenncc=N'PNJ Chi Nhánh Xã Đàn',
	@diachi=N'100 Xã Đàn, Đống Đa, Hà Nội',
	@sdt='0365668888'
	
/*XÓA*/
create proc xoaNHACC
	@mancc nchar(5)
as
	delete from NHACC
	where MaNCC=@mancc
	
exec xoaNHACC
	@mancc='NCC04'
	
/*TABLE DONDH*/

/*THÊM*/
create proc themDONDH
	@maDH nchar(5),
	@ngaydh datetime,
	@mancc nchar(5)
as
	insert into DONDH(MaDH,NgayDH,MaNCC)
	values(@maDH,@ngaydh,@mancc)
	
exec themDONDH
	@maDH='DH08',
	@ngaydh='12/02/2016',
	@mancc='NCC04'

/*SỬA*/
create proc suaDONDH
	@maDH nchar(5),
	@mancc nchar(5)
as
	update DONDH
	set MaNCC=@mancc
	where MaDH=@maDH
	
exec suaDONDH
	@maDH='DH08',
	@mancc='NCC03'

/*XÓA*/
create proc xoaDONDH
	@maDH nchar(5)
as
	delete from DONDH
	where MaDH=@maDH
	
exec xoaDONDH
	@maDH='DH08'
	
/*TABLE CTDONDH*/

/*THÊM*/
create proc themCTDONDH
	@maDH nchar(5),
	@mavtu nchar(10),
	@soluong int
as
	insert into CTDONDH(MaDH,MaVatTu,Soluong)
	values(@maDH,@mavtu,@soluong)
	
exec themCTDONDH
	@maDH='DH08',
	@mavtu='VT01',
	@soluong=14
	
/*SỬA*/
create proc suaCTDONDH
	@maDH nchar(5),
	@mavtu nchar(10),
	@soluong int
as
	update CTDONDH
	set Soluong=@soluong
	where MaDH=@maDH and MaVatTu=@mavtu
	
exec suaCTDONDH
	@maDH='DH08',
	@mavtu='VT01',
	@soluong=12
	
/*XÓA*/
create proc xoaCTDONDH
	@maDH nchar(5),
	@mavtu nchar(10)
as
	delete from CTDONDH
	where MaDH=@maDH and MaVatTu=@mavtu
	
exec xoaCTDONDH
	@maDH='DH08',
	@mavtu='VT01'
	
/*TABLE PHIEUNHAP*/
/*THÊM*/
create proc themPHIEUNHAP
	@mapn nchar(5),
	@ngaynhap datetime,
	@madh nchar(5)
as
	insert into PHIEUNHAP(MaPN,Ngaynhap,MaDH)
	values(@mapn,@ngaynhap,@madh)
	
exec themPHIEUNHAP
	@mapn='PN07',
	@ngaynhap='02/07/2017',
	@madh='DH01'
	
/*SỬA*/
create proc suaPHIEUNHAP
	@mapn nchar(5),
	@ngaynhap datetime,
	@madh nchar(5)
as
	update PHIEUNHAP
	set Ngaynhap=@ngaynhap,
		MaDH=@madh
	where MaPN=@mapn
	
exec suaPHIEUNHAP
	@mapn='PN07',
	@ngaynhap='02/08/2017',
	@madh='DH02'
	
/*XÓA*/
create proc xoaPHIEUNHAP
	@mapn nchar(5)
as
	delete from PHIEUNHAP
	where MaPN=@mapn
	
exec xoaPHIEUNHAP
	@mapn='PN07'
	
/*TABLE CTPHIEUNHAP*/

/*THÊM*/
create proc themCTPHIEUNHAP
	@mapn nchar(5),
	@mavtu nchar(10),
	@slgnhap int,
	@dgnhap float
as
	insert into CTPHIEUNHAP(MaPN,MaVatTu,SoLuongNhap,DonGiaNhap)
	values(@mapn,@mavtu,@slgnhap,@dgnhap)
	
exec themCTPHIEUNHAP
	@mapn='PN07',
	@mavtu='VT02',
	@slgnhap=3,
	@dgnhap=200000
	
/*SỬA*/
create proc suaCTPHIEUNHAP
	@mapn nchar(5),
	@mavtu nchar(10),
	@slgnhap int
as
	update CTPHIEUNHAP
	set SoLuongNhap=@slgnhap
	where MaPN=@mapn and MaVatTu=@mavtu
	
exec suaCTPHIEUNHAP
	@mapn='PN07',
	@mavtu='VT02',
	@slgnhap=4
	
/*XÓA*/
create proc xoaCTPHIEUNHAP
	@mapn nchar(5),
	@mavtu nchar(10)
as
	delete from CTPHIEUNHAP
	where MaPN=@mapn and MaVatTu=@mavtu
	
exec xoaCTPHIEUNHAP
	@mapn='PN07',
	@mavtu='VT02'
	
/*TABLE TONKHO*/

/*THÊM*/
create proc themTONKHO
	@mavtu nchar(10),
	@namthang datetime,
	@sldau int,
	@tongsln int,
	@tongslx int,
	@slcuoi int
as
	insert into TONKHO(MaVatTu,NamThang,SlDau,TongSLN,TongSLX,SlCuoi)
	values(@mavtu,@namthang,@sldau,@tongsln,@tongslx,@slcuoi)
	
exec themTONKHO
@mavtu='VT02',
@namthang='4/9/2018',
@sldau=2,
@tongsln=5,
@tongslx=4,
@slcuoi=3

/*SỬA*/
create proc suaTONKHO
	@mavtu nchar(10),
	@namthang datetime
as
	update TONKHO
	set NamThang=@namthang
	where MaVatTu=@mavtu
	
exec suaTONKHO
@mavtu='VT02',
@namthang='4/9/2019'

/*XÓA*/
create proc xoaTONKHO
	@mavtu nchar(10)
as
	delete from TONKHO
	where MaVatTu=@mavtu
	
exec xoaTONKHO
@mavtu='VT02'

