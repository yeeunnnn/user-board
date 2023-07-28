<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String Yellow = "\u001B[43m";
/* controller */
	// 1) session
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	// 2) reqeust/response
	if(request.getParameter("localName") == null
		|| request.getParameter("boardTitle") == null
		|| request.getParameter("boardContent") == null
		|| request.getParameter("localName").equals("")
		|| request.getParameter("boardTitle").equals("")
		|| request.getParameter("boardContent").equals("")){ //
		
		response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp");
		return;
	}
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");

/* model */
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// DB 드라이브, 접속
	Class.forName(driver);
	System.out.println(driver+Yellow+"<--addBoardAction driver"+RESET);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+Yellow+"<--addBoardAction conn"+RESET);
	
	// 1) local
	String addBoardSql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) values(?,?,?,?,Now(),Now())";
	PreparedStatement addBoardStmt = conn.prepareStatement(addBoardSql);
	addBoardStmt.setString(1, localName);
	addBoardStmt.setString(2, boardTitle);
	addBoardStmt.setString(3, boardContent);
	addBoardStmt.setString(4, memberId);
	int row = addBoardStmt.executeUpdate();
	
	System.out.println(row+Yellow+"<-- addBoardAction row"+RESET);
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	
%>	