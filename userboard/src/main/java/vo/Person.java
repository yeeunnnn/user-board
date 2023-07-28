package vo;

import java.util.Calendar;

public class Person {
	private int birth; //field 은닉
	/*
	private int getBirth() { //메소드 getter 은닉. Birh를 쓰기 전용으로 만들기 위해, 읽는 건 은닉
		return birth;
	}
	*/
	public void setBirth(int birth) {
		if(birth > 0){
		this.birth = birth;
		}
	}
	
	public int getAge() { //캡슐화 된 메소드에서 나이를 구해 볼 수 있게 함.
		if(this.birth > 0 ) {
			Calendar c = Calendar.getInstance();
			int y = c.get(Calendar.YEAR);
			return y-this.birth;
	}
		return 0;
	}
}
