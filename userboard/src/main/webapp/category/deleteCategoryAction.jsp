<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
/* controller */
	// ID 세션 값 유효성 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// request/response 삭제하기 위한 localName 값 받기
	if(request.getParameter("localName")==null) {
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp");
		return;
	}
	String localName = request.getParameter("localName");
	System.out.println(localName+CYAN+"<--deleteCategoryAction localName"+RESET);

/* model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	//드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--deleteCategoryAction driver"+RESET);
	//DB에 접속
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--deleteCategoryAction conn"+RESET);
	
	// 삭제 쿼리: 들어온 local_name 값이 일치하면 그 행을 삭제(local_name이 primary 키)
	String sql="DELETE FROM local WHERE local_name=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	System.out.println(stmt+CYAN+"<--deleteCategoryAction stmt"+RESET);
	// 삭제한 행 값을 row에 복사
	int row = stmt.executeUpdate();
	System.out.println(row+CYAN+"<--deleteCategoryAction row"+RESET);
	
/* /Redirect */
	String msg = null;
	if(row==1){//삭제에 성공했다면 성공 메세지와 함께 home으로 보내기.
		msg = URLEncoder.encode("카테고리가 삭제되었습니다","utf-8"); //Encoder 사용을 위해 java.net.* import
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp?msg="+msg);
		return;
	}
%>