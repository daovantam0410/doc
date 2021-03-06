/*
**
***
****
*****
******
*******
TRIGGER
*******
******
*****
****
***
**
*/
use QuanLyTrangSuc;

SELECT * FROM PHIEUNHAP INNER JOIN DONDH ON PHIEUNHAP.MaDH=DONDH.MaDH
SELECT * FROM PHIEUNHAP
SELECT * FROM DONDH

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
/*
- nếu tồn tại ít nhất một danh mục thuộc tiêu đề đó thì thông báo không thể xóa tiêu đề này
*/
create trigger Xoa_Tieude on TIEUDE
for delete
as
	declare @MaDanhMuc nchar(5), @ErrMsg nvarchar(200)
	if exists(select MaDanhMuc from DANHMUC
	where MaTieuDe in(select MaTieuDe from deleted))				
begin
	select @MaDanhMuc=MIN(MaDanhMuc)from DANHMUC
	where MaTieuDe in(select MaTieuDe from deleted)
	set @ErrMsg=N'Tiêu đề này đã được nhập theo danh mục'+@MaDanhMuc+N'. Không thể xóa tiêu đề này!'
	Raiserror(@ErrMsg,16,1)
	rollback tran
end

/*---BẢNG DANH MỤC---*/
/*Thêm DANHMUC*/
/*điều kiện:
- không được trùng với tên đã tồn tại
- Mã tiêu đề phải tồn tại trong bảng TIÊU ĐỀ
*/
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
			return
		end
	if not exists (select * from inserted,TIEUDE
				where inserted.MaTieuDe=TIEUDE.MaTieuDe)
		begin
			print N'Mã tiêu đề không tồn tại!'
			rollback tran
			return
		end

/*Sửa DANHMUC*/
/*
-không được sửa MaDanhMuc và MaTieuDe
*/
create trigger Sua_Danhmuc on DANHMUC
for update
as
	if update(MaDanhMuc) or UPDATE(MaTieuDe)
begin
	rollback tran
	print N'Không được sửa mã danh mục và mã tiêu đề!'
	return
end

/*Xóa DANHMUC*/
/*
- Nếu đã có ít nhất 1 vật tư nằm trong danh mục này thì thông báo không thể xóa danh mục
*/
create trigger Xoa_DANHMUC on DANHMUC
for delete
as
	declare @MaVatTu nchar(5), @ErrorMsg nvarchar(200)
	if exists(select MaVatTu from VATTU
	where MaDanhMuc in (select MaDanhMuc from deleted))
begin
	select @MaVatTu = MIN(MaVatTu)from VATTU where MaDanhMuc in(select MaDanhMuc from deleted)
	set @ErrorMsg = N'Mã danh mục đã được đặt theo mã vật tư '+@MaVatTu+N'. Không thể xóa danh mục này!'
	Raiserror(@ErrorMsg,16,1)
	rollback tran
end

/*BẢNG PHIẾU NHẬP*/
/*THÊM PHIEUNHAP*/
/*
- Ngày nhập phải sau ngày đặt hàng
*/
create trigger Them_PHIEUNHAP on PHIEUNHAP
for insert
as
	declare @NgayDH datetime, @ErrMessage nvarchar(200)
	select @NgayDH=NgayDH from Inserted,DONDH
	where Inserted.MaDH=DONDH.MaDH
	if @NgayDH > (select Ngaynhap from Inserted)
begin
	rollback tran
	set @ErrMessage = N'Ngày nhập hàng phải sau ngày đặt hàng'+convert(char(10),@NgayDH,103)
	print @ErrMessage
end

/*Sửa PHIEUNHAP*/
/*
- Ngày nhập phải sau ngày đặt hàng
*/
create trigger Sua_PHIEUNHAP on PHIEUNHAP
for update
as
	declare @NgayDH datetime, @ErrMessage nvarchar(200)
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

/*BẢNG VẬT TƯ*/
/*Thêm VATTU*/
/*
- Không thêm tên vật tư đã tồn tại trước đó
- Phải tồn tại Mã danh mục
*/
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
	if not exists(select * from inserted,DANHMUC
				where inserted.MaDanhMuc=DANHMUC.MaDanhMuc)
		begin
			rollback tran
			print N'Mã danh mục không tồn tại!'
		end

/*Sửa VATTU*/
/*
- không cho sửa mã vật tư
*/
create trigger Sua_VATTU on VATTU
for update
as
	if UPDATE(MaVatTu)
begin
	rollback tran
	print N'Không được sửa mã vật tư'
end

/*Xóa VATTU*/
/*
- 
*/
create trigger Xoa_VATTU on VATTU
for delete
as
begin
end

/*BẢNG ĐƠN ĐẶT HÀNG*/
/*THÊM DONDH*/
/*
- Ngày đặt hàng phải trước ngày nhập
*/
create trigger Them_DONDH on DONDH for insert
as
	declare @Ngaynhap datetime
	select @Ngaynhap = Ngaynhap from inserted,PHIEUNHAP
	where inserted.MaDH=PHIEUNHAP.MaDH
	if @Ngaynhap < (select NgayDH from inserted)
begin
	print N'Ngày đặt hàng phải trước ngày nhập'+
	convert(char(10),@Ngaynhap,103)
	rollback tran
end

/*SỬA DONDH*/
/*
- Không được sửa MaDH hoặc MaNCC vì liên quan đến nhiều bảng khác
*/
create trigger Sua_DONDH on DONDH for update
as
	declare @ErrMsg nvarchar(200)
	if UPDATE(MaDH) or UPDATE(MaNCC)
begin
	set @ErrMsg = N'Không được sửa MaDH/MaNCC'
	raiserror(@ErrMsg,16,1)
	rollback tran
end
/*XÓA DONDH*/
/*
- Nếu đã có ít nhất 1 phiếu nhập hàng cho đơn đặt hàng đó thì thông báo không thể xóa đơn đặt hàng
*/
create trigger Xoa_DONDH on DONDH
for delete
as
	declare @Maphieunhap nchar(5), @ErrMsg nvarchar(200)
	if exists(select MaPN from PHIEUNHAP
				where MaDH in(select MaDH from deleted))
begin
	select @Maphieunhap=MIN(MaPN)from PHIEUNHAP
	where MaDH in(select MaDH from deleted)
	set @ErrMsg=N'Đơn đặt hàng đã được nhập theo phiếu nhập'+@Maphieunhap+
				N'. Không thể xóa đơn hàng này!'
	Raiserror(@ErrMsg,16,1)
	rollback tran
end

/*BẢNG PHIẾU XUẤT*/
/*THÊM PHIEUXUAT*/
/*
- Ngày xuất phải sau ngày nhập
*/
create trigger Them_PHIEUXUAT on PHIEUXUAT for insert
as
	declare @Ngaynhap datetime
	select @Ngaynhap= Ngaynhap from inserted inner join CTPHIEUXUAT
								on inserted.MaPX=CTPHIEUXUAT.MaPX
								inner join VATTU
								on CTPHIEUXUAT.MaVatTu=VATTU.MaVatTu
								inner join CTPHIEUNHAP
								on VATTU.MaVatTu=CTPHIEUNHAP.MaVatTu
								inner join PHIEUNHAP
								on CTPHIEUNHAP.MaPN=PHIEUNHAP.MaPN
	if @Ngaynhap >(select NgayXuat from inserted)
begin
	print N'Ngày xuất phải sau ngày nhập!'
	+convert(char(10),@Ngaynhap,103)
	rollback tran
end

/*SỬA PHIEUXUAT*/
create trigger Sua_PHIEUXUAT on PHIEUXUAT for update
as
begin
end

/*XÓA PHIEUXUAT*/
/*

*/
create trigger Xoa_PHIEUXUAT on PHIEUXUAT for delete
as
	declare 
begin
end

/*BẢNG KHÁCH HÀNG*/
/*THÊM KHACHHANG*/
create trigger Them_KHACHHANG on KHACHHANG for insert
as
	declare @dem int, @dem1 int, @sdt varchar(11), @email varchar(50)
	select @sdt=SDT from inserted
	select @dem=COUNT(SDT)from KHACHHANG where SDT=@sdt
	if @dem >=2 
begin
	print N'Số điện thoại '+@sdt+N' đã tồn tại! Mời bạn nhập số khác'
	rollback tran
end
	select @email= Email from inserted
	select @dem1=COUNT(Email) from KHACHHANG where Email=@email
	if @dem1 >=2
begin
	print N'Email '+@email+N' đã tồn tại! Mời bạn nhập email khác'
	rollback tran
end

/*SỬA KHACHHANG*/
	
/*XÓA KHACHHANG*/
/*
- Nếu tồn tại ít nhất 1 phiếu xuất cho khách hàng đó thì thông báo không thể xóa khách hàng đó
*/
create trigger Xoa_KHACHHANG on KHACHHANG for delete
as
	declare @Mapx nchar(5)
	if exists(select MaPX from PHIEUXUAT
				where MaKH in(select MaKH from deleted))
begin
	select @Mapx=MIN(MaPX)from PHIEUXUAT
			where MaKH in(select MaKH from deleted)
	print N'Khách hàng này đã được xuất theo hóa đơn '
	+@Mapx+N'. Không thể xóa khách hàng này!'
	rollback tran
end

/*BẢNG NHÀ CUNG CẤP*/
create trigger Them_NHACC on NHACC for insert
as
	declare @dem int, @dem1 int, @dem2 int, @tenncc nvarchar(50), @sdt varchar(11), @diachi nvarchar(50)
	select @tenncc=TenNCC from inserted
	select @dem=COUNT(TenNCC)from NHACC where TenNCC=@tenncc
	if (@dem >= 2)
		begin
			print N'Tên nhà cung cấp '+@tenncc+N' đã tồn tại! Mời bạn nhập tên khác'
			rollback tran
		end
	select @diachi=DiaChi from inserted
	select @dem1=COUNT(DiaChi)from NHACC where DiaChi=@diachi
	if (@dem1 >= 2)	
		begin
			print N'Địa chỉ '+@diachi+N' đã tồn tại! Mời bạn nhập tên khác'
			rollback tran
		end
	select @sdt=SDT from inserted
	select @dem2=COUNT(SDT)from NHACC where SDT=@sdt
	if (@dem2 >= 2)	
		begin
			print N'Số điện thoại '+@sdt+N' đã tồn tại! Mời bạn nhập số khác'
			rollback tran
		end
/*XÓA NHACC*/
/*
- Nếu tồn tại ít nhất 1 đơn đặt hàng ứng với nhà cung cấp đó thì thông báo không được xóa
*/
create trigger Xoa_NHACC on NHACC for delete
as
	declare @madh nchar(5)
	if exists (select MaDH from DONDH
				where MaNCC in(select MaNCC from deleted))
begin
	select @madh=MIN(MaDH) from DONDH
	where MaNCC in (select MaNCC from deleted)
	print N'Nhà cung cấp này đã được đặt theo đơn đặt hàng '
	+@madh+N'. Không thể xóa nhà cung cấp này!'
	rollback tran
end

/*BẢNG CTDONDH*/
/*THÊM CTDONDH*/
/*
-Nếu không tồn tại mã đơn hàng và mã vật tư tương ứng với chi tiết đơn hàng,
thì thông báo không thể thêm đơn hàng này
*/
create trigger Them_CTDONDH on CTDONDH for insert
as
begin
	
end