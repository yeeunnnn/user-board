package vo;
//필드 정보은닉 + 필드 캡슐화
public class Data3 {
	private int x; //정보은닉
	private int y; // 정보은닉
	//메소드는 실행돼야 하니까 public 얘까지 private이면 안됨
	
	public int getX() { // 읽기 캡슐화 메서드 소문자 get + 필드명은 첫글자 대문자.
		//int x = 10; 얘를 없애면 this로 자동인식.
		return this.x; //return this.x; x는 원래 외부에 노출이 안되는데 노출이 되도록 읽게 함.(네 나이를 칠판에 적어봐=>결국 볼 수 있음. 근데 다른반 애가 나보고 적으라하면 안보여줌(if문으로 보여줄 사람 정할 수 있음))
	}
	//Class이름을 쓰는 static은 this를 못씀. 자기 자신이 클래스 자체라서.
	public int getY() { // 읽기 캡슐화 메서드 소문자 get + 필드명은 첫글자 대문자.
		return this.y; //return this.x; x는 원래 외부에 노출이 안되는데 노출이 되도록 읽게 함.(네 나이를 칠판에 적어봐=>결국 볼 수 있음. 근데 다른반 애가 나보고 적으라하면 안보여줌(if문으로 보여줄 사람 정할 수 있음))
	}
	
	public void setX(int x) { // 읽기 캡슐화 메서드 소문자 get + 필드명은 첫글자 대문자.
		if(x<0) {
			return;
		}
		this.x = x;
	}
	public void setY(int y) { // 읽기 캡슐화 메서드 소문자 get + 필드명은 첫글자 대문자.
		this.y = y;
	}
	
	//객체를 만들때마다 d3_n의 각각에 x가 있음.
	//Data d3_1 = new Data3();
	//d3_1.getX();
	//Data d3_2 = new Data();
	//d3_2.getX();
}
