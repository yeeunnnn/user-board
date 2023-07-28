<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String YELLOW = "\u001B[43m";
	
	/* 인코딩 */
	request.setCharacterEncoding("UTF-8");
	
	//session 디버깅
	System.out.println(session.getAttribute("loginMemberId")+YELLOW+"modifyBoardAction param loginMemberId"+RESET);
	
	/* controller */
	// session
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	// request/response
	if(request.getParameter("boardNo") == null
		|| request.getParameter("localName") == null
		|| request.getParameter("boardTitle") == null
		|| request.getParameter("boardContent") == null
		|| request.getParameter("boardNo").equals("")
		|| request.getParameter("localName").equals("")
		|| request.getParameter("boardTitle").equals("")
		|| request.getParameter("boardContent").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
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
	System.out.println(driver+YELLOW+"<--modifyBoardAction driver"+RESET);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+YELLOW+"<--modifyBoardAction conn"+RESET);
	
	// 1) local
	String modifyBoardSql = "UPDATE board SET board_title=?, board_content=?, updatedate=NOW() WHERE board_no=?";
	PreparedStatement modifyBoardStmt = conn.prepareStatement(modifyBoardSql);
	modifyBoardStmt.setString(1, boardTitle);
	modifyBoardStmt.setString(2, boardContent);
	modifyBoardStmt.setInt(3, boardNo);
	
	int row = modifyBoardStmt.executeUpdate();
	System.out.println(row+YELLOW+"<-- modifyBoardAction row"+RESET);
	
	if(row==1){
		String msg = "Modifications completed"; 
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	}
%>