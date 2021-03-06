/*Bài 5: Bài tập về các cấu trúc điều khiển*/

/*CAU 1*/

/*
a) Cho biết đơn giá xuất trung bình của hàng hóa “Đầu DVD Hitachi 1 đĩa” 
trong bảng CTPXUAT là bao nhiêu, nếu > 4000000 thì in ra thông báo “Không nên thay đổi giá bán”, 
ngược lại in ra thông báo “Nên tăng giá bán”
*/

use QLBH;

Declare @dgxuat int; 
set @dgxuat=(select AVG(CTPXUAT.DgXuat) from CTPXUAT where MaVTu = 'DD01')
if @dgxuat > '4000000'
	print 'khong nen thay doi gia ban'
else
	print 'nen tang gia ban'
	
/*
b) Sử dụng hàm Datename để tính xem có đơn đặt hàng nào đã được lập vào ngày chủ nhật không? 
Nếu có thì in ra danh sách các đơn đặt hàng đó, 
nếu không, in ra thông báo “Các ngày lập các đơn đặt hàng đều hợp lệ”
*/

/*
c) Đếm số lần nhập hàng cho đơn đặt hàng D001, 
in ra thông báo tương ứng (cho cả trường hợp đơn đặt hàng chưa được nhập hàng lần nào)
*/

/*
Declare @solandat int;
set @solandat = 
if @solandat = (select(CTPNHAP.MaVTu) 
				from CTPNHAP inner join VATTU on CTPNHAP.MaVTu=VATTU.MaVTu 
				where CTPNHAP.MaVTu = 'DD01')
	print 'So lan nhap don hang la: ' + convert(char(5),@solandat)
	print 'don hang da duoc dat'
else
	print 'don hang chua duoc dat'
*/
select * from DONDH inner join PNHAP on DONDH.SoDH=PNHAP.SoDH
				where PNHAP.SoDH='D001'
				
select * from DONDH right join PNHAP on DONDH.SoDH=PNHAP.SoDH
				where PNHAP.SoDH='D001'
				
/*CAU 2*/
/*
Tạo bảng VATTU_Temp có cấu trúc bảng gồm 2 cột MaVTu, TenVTu 
và dữ liệu giống dữ liệu trong bảng VATTU. 
Sau đó sử dụng cú pháp While viết đoạn chương trình xóa từng dòng dữ liệu trong bảng VATTU_Temp 
với điều kiện câu lệnh bên trong vòng lặp mỗi khi được thực hiện 
chỉ được phép xóa một dòng dữ liệu, 
khi đang xóa có hiển thị thông báo “Đang xóa vật tư ”+ Tên vật tư ra màn hình
*/

create table VATTU_Temp(
	MaVTu varchar(4) not null primary key,
	TenVTu nvarchar(100) null
);

insert into VATTU_Temp(MaVTu, TenVTu) values('DD01','Đầu DVD Hitachi 1 đĩa');
insert into VATTU_Temp(MaVTu, TenVTu) values('DD02','Đầu DVD Hitachi 2 đĩa');

update VATTU_Temp
set TenVTu = N'Đầu DVD Hitachi 1 đĩa'
where MaVTu = 'DD01';

update VATTU_Temp
set TenVTu = N'Đầu DVD Hitachi 2 đĩa'
where MaVTu = 'DD02';

Declare @vattu1 varchar(4), @vattu2 nvarchar(100), @vattu varchar(4);
while @vattu1 = @vattu1
	begin
		delete from VATTU_Temp where MaVTu=@vattu1;
		print N'Đang xóa vật tư ' + 
	end
