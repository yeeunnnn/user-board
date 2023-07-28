<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
/* 디버깅 배경색 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";

/* 1. 인코딩 */
	request.setCharacterEncoding("utf-8");

/* 2. controller */
	//세션값 없으면 home으로 보내기 "null일때"로 설정
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//세션값 memberId 디버깅
	System.out.println(session.getAttribute("loginMemberId")+CYAN+"insertCategoryAction param loginMemberId"+RESET);
	
	//받아온 localName을 변수에 받아 사용
	String localName = request.getParameter("localName");
	//Form에서 넘겨받은 localName 유효성 검사 (null || 공백)
	String msg = null;
	if(request.getParameter("localName")==null
	|| request.getParameter("localName").equals("")){
		msg = URLEncoder.encode("새 카테고리 이름을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/category/insertCategoryForm.jsp?msg="+msg); //다시 Form 화면을 보여줌
		return;
	}
	
	System.out.println(CYAN+localName+"<--insertCategoryAction localName"+RESET);

/* 3. model */
	//DB 관련해 사용할 변수 미리 초기화해놓기.
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard"; //url 마지막에는 프로젝트명 적기
	String dbUser = "root";
	String dbPw = "java1234";
	Connection conn = null;
	PreparedStatement stmt = null; //첫번째 쿼리: localName의 중복을 판단할 SELECT문 (기존 것과 비교)
	PreparedStatement stmt2 = null; //두번째 쿼리: 새로운 localName을 추가할 INSERT문
	ResultSet rs = null;
	
	//mariadb 드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--insertCategoryAction driver"+RESET);
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//1. 중복 검사 쿼리. SELECT 문으로 중복하는 값이 읽혀지면 msg 메세지.
	String sql1="SELECT local_name localName FROM local WHERE local_name=?"; //local에서 local_name을 골라 local_name=?과 비교.
	stmt = conn.prepareStatement(sql1);
	stmt.setString(1, localName);//받아온 localName
	rs = stmt.executeQuery();
	//하나에 대한 vo타입. if로 localName만 비교.
	if(rs.next()){
		System.out.println(CYAN+"insertCategoryAction 카테고리 중복"+RESET);
		msg = URLEncoder.encode("중복된 카테고리 입니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/category/insertCategoryForm.jsp?msg="+msg);
		return;
	}
	//입력 쿼리. INSERT문으로 입력한 카테고리 이름을 저장
	String sql2="INSERT INTO local(local_name, createdate, updatedate) values(?,NOW(),NOW())";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, localName);
	System.out.println(stmt2+CYAN+"<--insertCategoryAction stmt2"+RESET);

/*  Redirect/msg */
	int row = stmt2.executeUpdate(); //row의 수정 성공한 행의 개수를 복사
	System.out.println(CYAN+row+"<--insertCategoryAction row"+RESET);
	//완료 행의 개수에 따라 메세지 주기
	if(row == 1){ //성공하면 메세지와 함께 One에서 성공한 행을 보이도록.
		msg = URLEncoder.encode("추가 완료","utf-8");
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp?msg="+msg); //home은 member 파일에 있지 않아서 /member/home.jsp...로 쓰면 안됨
		return;
	} else if(row == 0){ //실패하면 다시 Form에서 작성할 수 있도록.
		msg = URLEncoder.encode("추가 실패","utf-8");
		response.sendRedirect(request.getContextPath()+"/category/insertCategoryForm.jsp?msg="+msg);
		return;
	}
%>