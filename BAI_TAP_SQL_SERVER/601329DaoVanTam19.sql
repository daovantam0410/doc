

create function Hocphanbatbuoc(@MaCN char(6))
	returns table
as
	return (select HOCPHAN.MaHP, TenHP, SoTC, Hinhthuc 
			from HOCPHAN inner join TIENTRINH
			on HOCPHAN.MaHP=TIENTRINH.MaHP
			where MaCN=@MaCN)
			
select * from Hocphanbatbuoc('TH01')

create trigger Sua_CHUYENNGANH on CHUYENNGANH
	for update
as
	begin
	declare @dem int, @TenCN nvarchar(50)
	if(UPDATE(Manganh)and UPDATE(MaCN))
		begin
			print N'Không được sửa mã chuyên ngành và mã ngành!'
			rollback tran
		end
	select @TenCN from inserted
	select @dem = COUNT(TenCN) from CHUYENNGANH where TenCN=@TenCN
	if @dem >=2
		begin
			print N'Tên chuyên ngành '+@TenCN+' đã tồn tại, không được sửa !'
			rollback tran
		end
	end

