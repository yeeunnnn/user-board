<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.util.*" %>
<!-- vo타입 만들지 않음. -->
<%
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);


    String sql = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local LIMIT 0, 1";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	//VO 대신 HashMap 타입을 사용 위에 "java.util.*" import
	//하나는 이름으로 사용할 거, 하나는 실제 들어올 값. <String, String> 말고 object는 모든 타입이 들어올 수 있음
	HashMap<String, Object> map = null; //if해서 rs.next 있을 때만 하면 되니까. 빈 맵은 안만듦. ArrayList는 0개짜리 먼저 만들어놓음
	if(rs.next()){ //쿼리를 읽어줌 키는 무조건 String값. 키|값, 키|값, ...
		//디버깅 코드. 확인해서 지움.
		//System.out.println(rs.getString("localName"));
		//System.out.println(rs.getString("country"));
		//System.out.println(rs.getString("worker"));
		map = new HashMap<String, Object>();
		map.put("localName", rs.getString("localName"));//앞이 키이름, 뒤가 값. map.put(키이름, 값)
		map.put("country", rs.getString("country"));
		map.put("worker", rs.getString("worker"));
		//[광명 대한민국 박성환] 이렇게 한 행만 받을 수 있음
		//만약 vo타입 이었다면 L.머시기 L.머시기 이렇게 했던 것처럼.
	}
	System.out.println((String)map.get("localName"));
	System.out.println((String)map.get("country"));
	System.out.println((String)map.get("worker"));
//-----------------------------------------------------------------------------------------------

	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
    String sql2 = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local";
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();//size는 몇개가 들어있는지 중요한 거 빵 개.. length가 7이라도 8개째 넣으면 늘어남.
	while(rs2.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs2.getString("localName"));
		m.put("country", rs2.getString("country"));
		m.put("worker", rs2.getString("worker"));
		list.add(m);
	}
//-----------------------------------------------------------------------------------------------

	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
    String sql3 = "SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
	stmt3 = conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();//size: 몇개가 들어있는지. 0개. | length는 7로 선언해도 8개째 넣으면 늘어남.
	while(rs3.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs3.getString("localName"));
		m.put("cnt", rs3.getInt("cnt"));
		list3.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>localListByMap.jsp</title>
</head>
<body>
	<table>
		<tr>
			<th>localName</th>
			<th>country</th>
			<th>worker</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
		<tr>
			<td><%=m.get("localName")%></td>
			<td><%=m.get("country")%></td>
			<td><%=m.get("worker")%></td>
		</tr>
		<%		
			}
		%>
	</table>
		<hr>
		<h2>rs3 결과셋</h2>
		<ul>
		<li><!-- 전체도 출력하고 싶을 때. 전체 개수. 원래는 전체 개수 쿼리도 불러와야함. rollup withup..? -->
			<a href="">전체</a>
		</li>
		
			<%
				for(HashMap<String, Object> m : list3){
			%>
				<li>
					<a href="">
						<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
					</a>
				</li>
			<%		
				}
			%>
		</ul>
</body>
</html>