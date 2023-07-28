<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String YELLOW = "\u001B[43m";
/* 인코딩 */
	request.setCharacterEncoding("UTF-8");

/* controller */
	//session
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	
	if(request.getParameter("boardNo")==null
	|| request.getParameter("commentNo")==null
	|| request.getParameter("commentContent")==null
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("commentNo").equals("")
	|| request.getParameter("commentContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	
/* model */	
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// DB 드라이브, 접속
	Class.forName(driver);
	System.out.println(driver+YELLOW+"<--modifyCommentAction driver"+RESET);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+YELLOW+"<--modifyCommentAction conn"+RESET);
	
	// 1) local
	String modifyCommentSql = "UPDATE comment SET comment_content=?, updatedate=NOW() WHERE board_no=? and comment_no=? and member_id=?";
	PreparedStatement modifyCommentStmt = conn.prepareStatement(modifyCommentSql);
	modifyCommentStmt.setString(1, commentContent);
	modifyCommentStmt.setInt(2, boardNo);
	modifyCommentStmt.setInt(3, commentNo);
	modifyCommentStmt.setString(4, memberId);
	
	int row = modifyCommentStmt.executeUpdate();
	System.out.println(row+YELLOW+"<-- modifyCommentAction row"+RESET);
	
	if(row==1){
		String msg = "Modifications completed"; 
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
	}
%>