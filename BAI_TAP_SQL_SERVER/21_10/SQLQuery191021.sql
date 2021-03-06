use QLBH

/*===Bài 6: HÀM DO NGƯỜI DÙNG ĐỊNH NGHĨA===*/

/*===Câu 1: Xây dựng các hàm đơn trị sau:===*/

/*
a) Tongnhapthang(@MaVTu,@Namthang) trả về tổng số lượng đã nhập của vật tư theo năm tháng 
(dữ liệu được lấy từ bảng CTPNHAP)
*/

create function Tongnhapthang(@MaVTu char(4),@Ngaynhap datetime)
returns int
as
begin
	declare @tongsl int
		select @tongsl=sum(SlNhap) from CTPNHAP left join PNHAP 
		on CTPNHAP.SoPn=PNHAP.SoPn 
		where MaVTu=@MaVTu
	/*print N'Tổng số lượng đã nhập của vật tư theo năm tháng là: '@tongsl + convert(char(4),@Ngaynhap,112)*/
	return @tongsl
end

alter function Tongnhapthang(@MaVTu char(4),@Namthang char(7))
	returns int
as
	begin
		declare @tongsln int
		
		select @tongsln = sum(SlNhap) 
		from CTPNHAP inner join PNHAP 
		on CTPNHAP.SoPn=PNHAP.SoPn 
		where MaVTu=@MaVTu and convert(char(7),Ngaynhap,21)=@Namthang
		
		return @tongsln
	end
print N'Tổng số lượng nhập của mã vật tư DD01 trong tháng 1 năm 2002 là: ' 
+ cast(dbo.Tongnhapthang('DD01','2002-01') as char(15))

/*
b) Tongxuatthang(@MaVTu,@Namthang) trả về tổng số lượng đã xuất của vật tư theo năm tháng 
(dữ liệu được lấy từ bảng CTPXUAT)
*/
create function Tongxuatthang(@MaVTu char(4),@Namthang char(7))
	returns int
as
	begin
		declare @tongslx int
		
		select @tongslx=sum(SlXuat)
		from CTPXUAT inner join PXUAT
		on CTPXUAT.SoPX=PXUAT.SoPX
		where MaVTu=@MaVTu and convert(char(7),Ngayxuat,21)=@Namthang
		
		return @tongslx
	end
print N'Tổng số lượng xuất của mã DD01 trong tháng 1 năm 2002 là: '
+cast(dbo.Tongxuatthang('DD01','2002-01') as char(15))
/*
c) Tongnhap(@SoDh,@MaVTu) trả về số lượng đã nhập của vật tư theo số đơn đặt hàng
*/
create function Tongnhap(@SoDh char(4),@MaVTu char(4))
	returns int
as
	begin
		declare @tongnhap int
		
		select @tongnhap=sum(SlDat) 
		from CTDONDH inner join DONDH
		on CTDONDH.SoDH=DONDH.SoDH
		inner join VATTU
		on CTDONDH.MaVTu=VATTU.MaVTu
		where SoDh=@SoDh and MaVTu=@MaVTu
		
		return @tongnhap
	end
print N'Tổng số lượng đã nhập của vật tư TV14 theo số đơn hàng là: ' 
+(dbo.Tongnhap('D003','TV14'))
+(dbo.Tongnhap('D005','TV14'))
+(dbo.Tongnhap('D006','TV14'))

/*
d) Sử dụng hàm Tongnhap ở ý c để viết hàm Connhap(@SoDh,@MaVTu) 
trả về số lượng còn phải nhập của vật tư theo số đơn đặt hàng
*/

/*
e) Ton(@MaVTu,@Namthang) trả về số lượng tồn của vật tư theo năm tháng
*/
create function Ton(@MaVTu char(4),@Namthang datetime)