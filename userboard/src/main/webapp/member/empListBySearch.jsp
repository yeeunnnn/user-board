<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %> <!-- ArrayList -->
<%@page import="java.net.URLEncoder"%>
<%
	// 디버깅 색깔 설정
	final String RESET = "\u001B[0m"; //이 변수는 절대 바꿀 수 없음. (그래서 대문자로 지정)
	final String GREEN = "\u001B[42m";
	System.out.println(GREEN+"hello"+RESET);

	// 유효성 검사(관리자가 아닐 경우 home으로)
	if(!session.getAttribute("loginMemberId").equals("admin") ){
		String msg = URLEncoder.encode("권한 없음", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	}
	
/*1. import할 것 생각하기. db접근할 수 있는 클래스 이름들 짧게 적으려고 java.util import.*/

// controller Layer: 요청 처리

/* 2. Parameter 값 파악 */
	//1. 현재 페이지(String -> (1) 완전 새로운 int로하든지 (방법이 존재하지X) | (2)Wrapper type 기본타입을 참조타입으로 옮겨갈 수 있게 하는 Integer(autoboxing)->int로 변경 | (3) 2번 마저도 생략하게 하는 Integer.parseInt 기본 API 메소드 current변수 생성)
	//2. 검색 단어(String searchWord변수 생성)
	//3. 성별 값

/* 3. [디버깅] 파라미터 값 null 넘어오는지 안 넘어오는지 확인 */
	System.out.println(GREEN+ request.getParameter("currentPage")+"<-- empListBySearch param currentPage" +RESET);
	System.out.println(GREEN+ request.getParameter("searchWord")+"<-- empListBySearch param searchWord" +RESET);
	System.out.println(GREEN+ request.getParameter("rowPerPage")+"<-- empListBySearch param rowPerPage" +RESET);
	
/* 4. null이 나오면 유효성 검사 */
	int currentPage = 1; //변수의 생명주기가 블럭이라서 밖에 선언. 참조타입은 null로 초기화 or 값이 있어야 되면 new 기본값으로 초기화.
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
		/*  받은 값이 없어서 currentPage = 1;로 갈거면, 애초에 currentPage를 1로 설정하면 else를 안써도 됨
		else {
			currentPage = 1;
		}
		*/
		   String col = "emp_no";   
		   String ascDesc = "ASC";
		   
		   if(request.getParameter("col") != null
		      && request.getParameter("ascDesc") != null) {
		      
		      col = request.getParameter("col");
		      ascDesc = request.getParameter("ascDesc");
		   }
		   // ex) col = "birthDate", ascDesc = "ASC"

				   
	String searchWord =""; //null이나 공백이나, 쿼리가 같아서(모델값이 같아서)
	if(request.getParameter("searchWord") != null) { //null이 아니면 
		searchWord = request.getParameter("searchWord");
	}
	
	int rowPerPage = 10; //기본 값이 10개. 아무값도 받지 않으면 행의 수는 10줄.
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	//[디버깅] 유효성 검사를 거친 후 최종값
	System.out.println(currentPage + GREEN+ "<-- empListBySearch currentPage" +RESET);
	System.out.println(searchWord + GREEN+ "<--empListBySearch searchWord" +RESET);
	System.out.println(rowPerPage + GREEN+ "<--empListBySearch rowPerPage" +RESET);
	
//Model Layer: 시니어 백엔드 모델값을 생성하기까지 모든 과정. view에서 출력할 내용. 여기에서는 select의 결과물을 employees의 ArrayList로 만든 것 까지.
	//앞의 controller layer의 결과 변수(currentPage, searchWord)의 모델을 생성하기 위해 필요한 변수 추가
	//controller layer의 결과 변수 가공
	int startRow = (currentPage - 1) * rowPerPage;
	//rowPerPage10일 때, 페이지가 1이면 starRow는 10.
	//startRow = 페이지가 2, rowPerPage20
	System.out.println(startRow + GREEN+ "<--empListBySearch startRow" +RESET); //페이지가 1일때 10이 나오는지
	//DB호출에 필요한 변수 생성
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl="jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser="root";
	String dbPw="java1234";
	
	Class.forName(driver);
	System.out.println(GREEN+ driver +RESET);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//분기되는 쿼리, 동적 쿼리
	String sql = null;
	PreparedStatement stmt = null;//new로 초기화 못함
	//searchWord가 공백이면?
	if(searchWord.equals("")==true){ //if(!searchWord.equals("")) 공백이 아닐때.     여기서도 else 없앨 수 있지만 else if 계속 생길거라 그냥 둠..?
		sql = "SELECT * FROM employees ORDER BY " + col + " " + ascDesc+ " LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow);
		stmt.setInt(2, rowPerPage);
	//searchWord가 공백이 아니면?
	} else {
		/*
			SELECT * FROM employee
			WHERE CONCAT(first_name, ' ', last_name) LIKE '?' //값을 물음표로 대신하는 건데 %x% 작은 따옴표 다 감싼 게 값이니까 
			ORDER BY emp_no ASC LIMIT ?, ?
		*/
		sql = "SELECT * FROM employees WHERE CONCAT(first_name, ' ', last_name) LIKE ? ORDER BY " + col + " " + ascDesc + " LIMIT ?, ?"; 
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchWord+"%"); //서치 앞뒤로 퍼센트를 붙여서 들어감. searchWord의 작은 따옴표는 sql에서 알아서 들어감.
		stmt.setInt(2, startRow);
		stmt.setInt(3, rowPerPage);
	}
	
	System.out.println(stmt+ GREEN+"<-- empListBySearch stmt 완성된 like 동적 쿼리문" +RESET);
	ResultSet rs = stmt.executeQuery(); //얘는 모델이 아님.
	
	//일반적인 자료구조(모델)로 변경
	ArrayList<Emp> empList = new ArrayList<Emp>();//empList=null;이건 안됨
	//empList emp = new Emp<>()이걸 넣으면 매번 한개씩 새로 만들어지니까 누적이 안됨.
		while(rs.next()){
			Emp e = new Emp();
			e.empNo= rs.getInt("emp_no");
			e.birthDate = rs.getString("birth_date");
			e.firstName = rs.getString("first_name");
			e.lastName = rs.getString("last_name");
			e.gender = rs.getString("gender");
			e.hireDate = rs.getString("hire_date");
			empList.add(e);
		}
	//[디버깅]
	System.out.println(empList.size() +GREEN+"<--empListBySearch empList.size()" +RESET);
	
	for(Emp e : empList){
		System.out.println(e.firstName + " " + e.lastName);
	}
	
	//두번째 모델값 lastPage
	String sql1 = "select count(*) from employees";
	PreparedStatement stmt2 = conn.prepareStatement(sql1);
	ResultSet rs2 = stmt2.executeQuery();
	//lastPage를 연산하기 위해 만드는 totalCount
	int totalCount = 0;
	if(rs.next()){ //총 행의 수를 vo타입 totalCount에 복사.
		totalCount = rs2.getInt("count(*)");
	}
	//lastPage가 나누어 0으로 떨어지지 않을 때 한 페이지 더 출력하도록.
	int lastPage = 0;
	if(totalCount % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	
	// 클래스를 만들지 않아도 되는 기본 API Calender 사용해 객체 생성.
	Calendar today = Calendar.getInstance();
	//객체를 만들어 오늘 날짜를 저장해놓음.
	int Year = today.get(Calendar.YEAR);
	int Month = today.get(Calendar.MONTH)+1;
	int Day = today.get(Calendar.DAY_OF_MONTH);//해당하는 달에 있는 일 수를 저장할 수 있음.
	//디버깅
	System.out.println("empListBySearch Year: "+Year);
	System.out.println("empListBySearch Month: "+Month);
	System.out.println("empListBySearch Day: "+Day);
	
	int current = Month * 100 + Day; //현재 월과 일을 숫자로 바꾸는 식
	//View Layer: 주로 프론트. 출력물 관련.
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empListBySearch</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, td {table-layout: fixed}
	 	.center {text-align:center}
	 	.none {text-decoration: none;}
	</style>
</head>
<body>
	<!-- 네비게이션 바 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
       <div class="container" class="center">
		<table class="table table-bordered table-sm" class="center">
		<thead>
			<tr class="center">
				<td colspan="6">
					<h2>EMPLOYEES LIST</h2>
				</td>
			</tr>
			<tr class="center">
				<td colspan="6">
					<form action="<%=request.getContextPath()%>/member/empListBySearch.jsp" method="get">
						<label>이름검색: </label>
						<input type="text" name="searchWord" value="<%=searchWord%>">
						<!--  
						<label>입사년도: </label>
						<input type="number" name="beginYear">
						~
						<input type="number" name="endYear">
						-->
						<button type="submit">조회</button>
					</form>
				</td>
			</tr>
			<tr class="center">
				<th>no<!-- 컬럼명이 아닌, asc와 desc를 클릭하면 각각 오름차순, 내림차순 될 수 있게 태그 지정-->
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=emp_no&ascDesc=ASC">[asc]</a>
					<!--  emp_no를 empNo 별칭으로 바꾸어놓아서 전달 가능. -->
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=emp_no&ascDesc=DESC">[desc]</a>
				</th>
				<th>age<!-- birthDate는 아래에서 age로 계산할 것임 -->
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=birth_date&ascDesc=ASC">[asc]</a>
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=birth_date&ascDesc=DESC">[desc]</a>
				</th>
				<th>firstName
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=first_name&ascDesc=ASC">[asc]</a>
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=first_name&ascDesc=DESC">[desc]</a>
				</th>
				<th>lastName
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=last_name&ascDesc=ASC">[asc]</a>
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=last_name&ascDesc=DESC">[desc]</a>
				</th>
				<th>gender
				<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=gender&ascDesc=ASC">[asc]</a>
				<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=gender&ascDesc=DESC">[desc]</a>
				</th>
				<th>hireDate
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=hire_date&ascDesc=ASC">[asc]</a>
					<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?col=hire_date&ascDesc=DESC">[desc]</a>
				</th>
			</tr>
		</thead>	
		<%	//년/월/일 계속계속 돌아갈 수 있게 미리 선언
			for(Emp e : empList){
				int birthYear = Integer.parseInt(e.birthDate.substring(0,4));
				int birthMonth = Integer.parseInt(e.birthDate.substring(5,7));
				int birthDay = Integer.parseInt(e.birthDate.substring(8));
				int age = Year - birthYear - 1; //생일이 지나면 +1
		%>	
			<tr class="center">
				<td>
					<%=e.empNo%>
				</td>
					<%		
						if(current >= birthDay){
					%>		
						<td>
							<%=age%>
						</td>
					<%
						} else {
					%>
						<td><%=age+1%></td>
					<%			
						}
					%>		
				<td>
					<%=e.firstName%>
				</td>
				<td>
					<%=e.lastName%>
				</td>
				<td>
					<%
						if(e.gender.equals("F")){
					%>
						<img src="<%=request.getContextPath()%>/img/F.jpg" width="50" height="50">
					<%		
						} else {
					%>
						<img src="<%=request.getContextPath()%>/img/M.jpg" width="50" height="50">
					<%		
						}
					%>
				</td>
				<td>
					<%=e.hireDate%>
				</td>
				<%
					}
				%>		
			</table>
			</div>
			<div class="center">
				<%
					if(currentPage > 1){
				%>
						<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?currentPage=<%=currentPage-1%>&rowPerPage=<%=rowPerPage%>&searchWord=<%=searchWord%>">이전</a>
				<%		
					}
				%>
						<%=currentPage%>
				<%	
					if(currentPage < lastPage){
				%>
						<a href="<%=request.getContextPath()%>/member/empListBySearch.jsp?currentPage=<%=currentPage+1%>&rowPerPage=<%=rowPerPage%>&searchWord=<%=searchWord%>">다음</a>
				<%
					}
				%>
			</div>
	<div class="bg-light">
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>		
	</body>
</html>