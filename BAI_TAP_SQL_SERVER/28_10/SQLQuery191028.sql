use QLBH

/*===Bài 8: TRIGGER===*/

/*CAU1: Tạo trigger khi thêm mới dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn dữ liệu như yêu cầu bên dưới:*/
/*
Xây dựng trigger khi thêm mới dữ liệu vào bảng PNHAP với tên tg_PNHAP_Them. 
Trong đó cần kiểm tra các ràng buộc dữ liệu phải hợp lệ: 
       - Ngày nhập hàng phải sau ngày đặt hàng
*/
create trigger tg_PNHAP_Them on PNHAP
for insert
as
	declare @NgayDH datetime, @ErrMessage char(200)
	select @NgayDH=NgayDH from Inserted,DONDH
		where Inserted.SoDH=DONDH.SoDH
		if @NgayDH > (select Ngaynhap from Inserted)
		begin
			rollback tran
			set @ErrMessage = N'Ngày nhập hàng phải sau ngày đặt hàng'+convert(char(10),@NgayDH,103)
			print @ErrMessage
		end

/*
Xây dựng trigger khi thêm mới dữ liệu vào bảng CTPNHAP với tên tg_CTPNHAP_Them. 
Trong đó cần kiểm tra các ràng buộc dữ liệu:
        - Số lượng nhập hàng <= (Số lượng đặt – Tổng số lượng đã nhập vào trước đó)
*/	

create trigger tg_CTPNHAP_Them on CTPNHAP
for insert
as
	declare @ErrMessage char(200), @SlDat int
	select @SLDat=SlDat from Inserted,VATTU,CTDONDH
		where Inserted.MaVTu=VATTU.MaVTu and VATTU.MaVTu=CTDONDH.MaVTu
		if (select Slnhap from Inserted) > @SlDat - (select Slnhap from Inserted)
		begin
			rollback tran
			set @ErrMessage = N'Số lượng nhập hàng <= (Số lượng đặt – Tổng số lượng đã nhập vào trước đó)'
			set @ErrMessage = N'Số lượng nhập hàng <=' + (@SlDat - (select Slnhap from Inserted))
			print @ErrMessage
			return
		end 

/*
CÂU 2. Tạo trigger khi xoá dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn dữ liệu như yêu cầu bên dưới:
*/

/*
a. Xây dựng trigger khi xoá dữ liệu trong bảng PXUAT với tên tg_PXUAT_XOA. Trong đó cần thực hiện hành động:
        - Tự động xoá các dòng dữ liệu liên quan bên  bảng CTPXUAT
*/

create trigger tg_PXUAT_XOA on PXUAT
for delete
as
	delete CTPXUAT where SoPX in (select SoPX from Deleted)

/*
b. Xây dựng trigger khi xoá dữ liệu trong bảng PNHAP với tên tg_PNHAP_XOA. Trong đó cần thực hiện hành động:
         - Tự động xoá các dòng dữ liệu liên quan bên bảng CTPNHAP

*/

create trigger tg_PNHAP_XOA on PNHAP
for delete
as
	delete CTPNHAP where SoPN in (select SoPN from Deleted)
	
/*
CÂU 3. Tạo trigger khi sửa dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn dữ liệu như yêu cầu bên dưới:
*/

/*
a. Xây dựng trigger khi sửa dữ liệu trong bảng PNHAP với tên tg_PNHAP_SUA. 
Trong đó cần  kiểm tra các ràng buộc dữ liệu phải hợp lệ:
   - Không cho phép sửa đổi giá trị của các cột: số nhập hàng, số đặt hàng
   - Kiểm tra giá trị mới của cột ngày nhập hàng phải sau ngày đặt hàng
*/

create trigger tg_PNHAP_SUA on PNHAP
for update
as
	declare @ErrorMessage char(200), @NgayDH datetime
	if (update(SoPN) or update(SoDH))
		begin
			rollback tran
			set @ErrorMessage = N'Không được phép sửa giá trị SoPN và SoDH'
			print @ErrorMessage
			return
		end
	select @NgayDH = NgayDH from DONDH,PNHAP
		where DONDH.SoDH=PNHAP.SoDH
	if (@NgayDH > (select Ngaynhap from Upadted))
		begin
			rollback tran
			set @ErrorMessage = N'Giá trị mới của cột ngày nhập hàng phải sau ngày đặt hàng'
			print @ErrorMessage
			return
		end
		
/*
b. Xây dựng trigger khi sửa dữ liệu trong bảng PXUAT với tên tg_PXUAT_SUA. 
Trong đó cần  kiểm tra các ràng buộc dữ liệu phải hợp lệ:
	- Không cho phép sửa đổi giá trị của cột số phiếu xuất.
    - Kiểm tra giá trị mới của ngày xuất phải cùng năm tháng với giá trị cũ của 
*/

create trigger tg_PXUAT_SUA on PXUAT
for update
as
	declare @ErrorMessage char(200)
	if(update(SoPX))
		begin
			rollback tran
			set @ErrorMessage = N'Không cho phép sửa đổi giá trị của cột số phiếu xuất'
			print @ErrorMessage
			return
		end
	select Ngayxuat from 
	
	
	