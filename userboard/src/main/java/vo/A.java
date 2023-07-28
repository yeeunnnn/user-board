package vo;

public class A {
	private String getFirstName() {
		return "구디";
	}

	private String getSecondName() {
		return "아카데미";
	}
	
	public String getFullName() {
		return this.getFirstName()+this.getSecondName();
	}
}
