package vnua.fita.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import vnua.fita.bean.Car;
import vnua.fita.service.CarService;


public class CarServiceImpl implements CarService{

	private String jdbcURL;
	private String jdbcUsername;
	private String jdbcPassword;
	private Connection conn;
	
	// Constructor với các tham số để kết nối 
	public CarServiceImpl(String jdbcURL, String jdbcUsername, String jdbcPassword) {
		this.jdbcURL = jdbcURL;
		this.jdbcUsername = jdbcUsername;
		this.jdbcPassword = jdbcPassword;
	}
	
	// Trả về danh sách ô tô tìm được, nếu keword = null hoặc "" trả về ds tất cả ô tô
	// tìm kiếm theo trường model hoặc make của ô tô có chứa từ khóa keyword
	public List<Car> search(String keyword){
		List<Car> result = new LinkedList<Car>();
		PreparedStatement pst = null;
		try {
			conn = DBConnection.create(jdbcURL, jdbcUsername, jdbcPassword);
			String sqlCommand ="Select * from tblcar ";
			
			// Mệnh đề Where chỉ xuất hiện trong câu sql khi keyword khác null, khác rỗng
			if ((keyword!=null && !"".equals(keyword))){
				sqlCommand += "WHERE "
								+ "model LIKE ? "
								+ " OR "
								+ "make LIKE ?";
			}
			
			pst = conn.prepareStatement(sqlCommand);
			if ((keyword!=null && !"".equals(keyword))){
				pst.setString(1, "%" + keyword.toLowerCase() + "%");
				pst.setString(2, "%" + keyword.toLowerCase() + "%");
			}
			
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				Integer id = rs.getInt(1);
				String model = rs.getString(2);
				String make = rs.getString(3);
				String preview = rs.getString(4);
				String description = rs.getString(5);
				Integer price = rs.getInt(6);
				Car car = new Car(id, model, make, description,  preview, price);
				result.add(car);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			DBConnection.closeConnect(conn);
			DBConnection.closeStatement(pst);
		}
		return result;
	}
	
	// Việc cài đặt dành cho sinh viên và bạn đọc
	public boolean insertCar(Car car) {
		return false;
	}
	
	// Việc cài đặt dành cho sinh viên và bạn đọc
	public boolean updateCar(Car car) {
		return false;
	}
	
	// Việc cài đặt dành cho sinh viên và bạn đọc
	public boolean deleteCar(int carId) {
		return false;
	}
	
	// Việc cài đặt dành cho sinh viên và bạn đọc
	public Car selectCar(int carId) {
		return null;
	}
	
}
