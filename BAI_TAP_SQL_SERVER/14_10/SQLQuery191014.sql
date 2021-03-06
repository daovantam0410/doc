use QLBH;

/*--- CAU 1 ---*/

/*
-	Chèn thêm 1 bản ghi vào bảng NHACC
*/
 
/*lệnh 1*/
create procedure themNHACC
 as
	insert into NHACC values('C09',N'Đào Văn Tâm',N'Hà Nội','123456789')
/*lệnh 2*/
 Exec themNHACC
 
/*
-	Xóa 1 bản ghi khỏi bảng NHACC (chú ý ràng buộc khóa ngoại)
*/

/*lệnh 1*/
alter procedure themNHACC
as
	delete from NHACC where MaNCC = 'C09'
/*lệnh 2*/
Exec themNHACC

/*
-	Sửa 1 bản ghi có trong bảng NHACC (chú ý ràng buộc khóa ngoại)
(Các giá trị chèn/xóa/sửa do SV tự chọn.)
*/
/*lệnh 1*/
alter procedure themNHACC
as
	update NHACC set
	DiaChi = N'Số 27, tổ 2, Giang Biên, Long Biên, Hà Nội'
	where MaNCC = 'C08'
/*lệnh 2*/
Exec themNHACC

/*
-	Tính và in ra màn hình tổng toàn bộ tiền nhập trong tháng 01/2002
*/

/*lệnh 1*/
create proc Tongtiennhap
as
	begin
		declare @tongtiennhap int
		select @tongtiennhap = SUM(DgNhap)from CTPNHAP left join PNHAP 
											on CTPNHAP.SoPn=PNHAP.SoPN 
											where CONVERT(char(7),Ngaynhap,21)='2002-01'
		print N'Tổng số tiền nhập trong tháng 01/2002 là: '+cast(@tongtiennhap as char(15))
	end
	go
/*lệnh 2*/
Exec Tongtiennhap

/*
-	Tính và in ra màn hình tổng toàn bộ tiền xuất 01/2002
*/
/*lệnh 1*/
create proc Tongtienxuat
as
	begin
		declare @tongtienxuat int
		select @tongtienxuat = SUM(DgXuat) from CTPXUAT left join PXUAT
											on CTPXUAT.SoPX=PXUAT.SoPX
											where CONVERT(char(7),Ngayxuat,21)='2002-01'
		print N'Tổng số tiền xuất trong tháng 01/2002 là: '+cast(@tongtienxuat as char(15))									
	end
	go
/*lệnh 2*/
Exec Tongtienxuat