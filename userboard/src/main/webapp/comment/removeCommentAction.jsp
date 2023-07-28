<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@page import="java.net.*"%>
<%
/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
/* controller */
	// session
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(session.getAttribute("loginMemberId")+CYAN+"<--removeCommentAction memberId"+RESET);
	
	// request/responses
	if(request.getParameter("commentNo")==null
	|| request.getParameter("boardNo")==null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(commentNo+CYAN+"<--removeCommentAction commentNo"+RESET);
	System.out.println(boardNo+CYAN+"<--removeCommentAction boardNo"+RESET);
	
	if (request.getParameter("memberId") == null
    || request.getParameter("memberPw") == null
    || request.getParameter("memberId").equals("")
    || request.getParameter("memberPw").equals("")) {
	    String msg = URLEncoder.encode("입력해주세요", "UTF-8");
	    response.sendRedirect(request.getContextPath() + "/comment/removeComment.jsp?commentNo=" + commentNo + "&msg=" + msg);
	    return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	System.out.println(memberId+" <-- removeCommentAction");
	System.out.println(memberPw+" <-- removeCommentAction");
	
/* model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	//드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--removeCommentAction driver"+RESET);
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--removeCommentAction conn"+RESET);
	
	//댓글 삭제
	// 1. memberPw 를 확인
	String selectCommentCntSql = "SELECT count(*) FROM member WHERE member_id = ? and member_pw = password(?)"; //password 처리해줘야함
	PreparedStatement stmt = conn.prepareStatement(selectCommentCntSql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	ResultSet commentCntRs = stmt.executeQuery();
	int idCnt = 0;
	if(commentCntRs.next()){
		idCnt = commentCntRs.getInt(1);
	}
	System.out.println(idCnt+" <-- removeCommentAction idCnt");
	
	// 2. memberId와 memberPw가 일시할 시 삭제
	int row = 0;
	if(idCnt > 0){
		String removeBoardSql = "DELETE FROM comment WHERE comment_no = ?";
		PreparedStatement deleteStmt = conn.prepareStatement(removeBoardSql);
		deleteStmt.setInt(1, commentNo);
		System.out.println(deleteStmt+CYAN+"<--removeCommentAction deleteStmt"+RESET);
		
		// 삭제했으면 row에 복사
		row = deleteStmt.executeUpdate();
		System.out.println(row+CYAN+"<--removeCommentAction row"+RESET);
	}
	
/* Redirect */
	String msg = null;
	if(row==1){//삭제에 성공했다면 성공 메세지 보내고, home으로 보내기.
		msg = URLEncoder.encode("삭제 완료", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	} else if(row==0){//실패했으면 실패 메세지
		msg = URLEncoder.encode("삭제 실패", "UTF-8"); //실패했다면 오류메세지, 세션값과 함께 Form으로 보냄
		response.sendRedirect(request.getContextPath()+"/comment/removeComment.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
		return;
	}
%>