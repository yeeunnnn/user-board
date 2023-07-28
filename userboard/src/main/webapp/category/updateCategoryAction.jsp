<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %><!-- 인코딩은 주소값으로 보낼때만 해주면 됨 -->
<%@ page import="vo.*" %>
<%
/* 인코딩 */
	request.setCharacterEncoding("utf-8");

/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
/* controller */
	//세션 값 유효성 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//받은 localName과 newLocalName 유효성 검사
	//localName을 먼저 변수에 받아 사용
	String localName = request.getParameter("localName");
	//localName = URLEncoder.encode(localName, "utf-8"); 오류: localName을 인코딩하면 '대구'로 가지않고 한글 아닌 값으로 가게 됨.
	System.out.println(localName+CYAN+"<--updateCategoryAction localName"+RESET);
	
	//newLocalName을 먼저 변수에 받아 사용
	String newLocalName = request.getParameter("newLocalName");
	System.out.println(newLocalName+CYAN+"<--updateCategoryAction newLocalName"+RESET);
	
	if(request.getParameter("localName")==null
		|| request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp");
		return;
	}
	String msg = null;
	if(request.getParameter("newLocalName")==null
		|| request.getParameter("newLocalName").equals("")){
		msg = URLEncoder.encode("새 비밀번호를 입력하세요", "utf-8");
		localName = URLEncoder.encode(localName, "utf-8");
		response.sendRedirect(request.getContextPath()+"/category/updateCategoryForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
/* model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	//insert에서 했던 중복 검사처럼 중복된 이름이면 오류메세지로 알려주기
	PreparedStatement stmt = null; 
	PreparedStatement stmt2 = null; 
	ResultSet rs = null;
	
	// 드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--updateCategoryAction driver"+RESET);
	// connection DB 접속
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--updateCategoryAction conn"+RESET);

	// 1. 첫번째 쿼리: 중복 판단 SELECT문
	String sql1="SELECT local_name localName FROM local WHERE local_name=?";
	stmt = conn.prepareStatement(sql1);
	stmt.setString(1, newLocalName);
	rs = stmt.executeQuery();
	
	//vo타입으로 변경. 조건문 형태로 localName 하나에 대해서만 중복검사 실행되게 함.
	if(rs.next()){
		System.out.println(CYAN+"updateCategoryAction 카테고리 중복"+RESET);
		msg = URLEncoder.encode("중복된 카테고리", "utf-8");
		localName = URLEncoder.encode(localName, "utf-8"); //오류 있었음: localName이 한글이라서 변수값에도 인코딩을 해줘야함.
		//중복값이 있으면 updateCategoryForm으로 오류 메세지 보내기, Form은 (어떤 카테고리 수정하는지)localName을 필요로 해서 키 값도 넘겨줘야함.
		response.sendRedirect(request.getContextPath()+"/category/updateCategoryForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}

	// 2. 두번째 쿼리: 새로운 이름 추가하는 INSERT문
	// 새로 입력했으니까 (기존 것, 새 것) 두 개를 받아와야 함.
	String sql2="UPDATE local SET local_name=?, updatedate=NOW() WHERE local_name=?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, newLocalName);
	stmt2.setString(2, localName);
	System.out.println(stmt2+CYAN+"<--updateCategoryAction stmt2"+RESET);

/*  Redirect/msg */
	int row = stmt2.executeUpdate();
	System.out.println(CYAN+row+"<--updateCategoryAction row"+RESET);
	//완료 행 값에 따라 메세지 주기
	if(row == 1){ //수정돼서 row가 1이면 메세지와 함께 One에서 확인하도록 함.
		msg = URLEncoder.encode("수정 완료","utf-8");
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp?msg="+msg); //home은 member 파일에 있지 않아서 /member/home.jsp...로 쓰면 안됨
		return;
	} else if(row == 0){ //수정 실패했으면 다시 localName+msg를 Form으로 보내줌. 위에서 중복검사로 한번 걸러주기 때문에 잘 쓰이지 않을 수 있음.
		msg = URLEncoder.encode("수정 실패","utf-8");
		localName = URLEncoder.encode(localName, "utf-8"); //주소값에 보낼땐 주소가 인식할 수 있게 기계어?로 바꿔줌
		response.sendRedirect(request.getContextPath()+"/category/updateCategoryForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
%>