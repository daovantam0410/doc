package vnua.fita.bean;

import java.util.Date;

public class User {

	private String name;
	private boolean male;
	private Date birthday;
	
	public User() {
		
	}
	
	public User(String name, boolean male, Date birthday) {
		this.name = name;
		this.male = male;
		this.birthday = birthday;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isMale() {
		return male;
	}
	public void setMale(boolean male) {
		this.male = male;
	}
	public Date getBirthday() {
		return birthday;
	}
	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}
}
