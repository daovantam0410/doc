package vnua.fita.service;

import java.util.List;

import vnua.fita.bean.Car;

public interface CarService {
	
	public List<Car> search(String keyword);
	
	public boolean insertCar(Car car);
	
	public boolean updateCar(Car car);
	
	public boolean deleteCar(int carId);
	
	public Car selectCar(int carId);
}
