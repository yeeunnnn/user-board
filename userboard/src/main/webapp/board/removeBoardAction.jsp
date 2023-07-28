<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
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
	System.out.println(session.getAttribute("loginMemberId")+CYAN+"<--removeBoardAction memberId"+RESET);
	
	// request/responses
	if(request.getParameter("boardNo")==null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println(boardNo+CYAN+"<--removeBoardAction memberId"+RESET);
	
	if (request.getParameter("memberId") == null
    || request.getParameter("memberPw") == null
    || request.getParameter("memberId").equals("")
    || request.getParameter("memberPw").equals("")) {
	    String msg = URLEncoder.encode("입력해주세요", "UTF-8");
	    response.sendRedirect(request.getContextPath() + "/board/removeBoard.jsp?boardNo="+boardNo+"&msg="+msg);
	    return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	System.out.println(memberId+" <-- removeBoardAction");
	System.out.println(memberPw+" <-- removeBoardAction");
	
/* model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	
	//드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--removeBoardAction driver"+RESET);
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--deleteInformationAction conn"+RESET);
	
	//게시물 삭제
	// 1. memberPw 를 확인
	String selectBoardCntSql = "SELECT count(*) FROM member WHERE member_id = ? and member_pw = password(?)"; //password 처리해줘야함
	PreparedStatement stmt = conn.prepareStatement(selectBoardCntSql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	ResultSet boardCntRs = stmt.executeQuery();
	int idCnt = 0;
	if(boardCntRs.next()){
		idCnt = boardCntRs.getInt(1);
	}
	System.out.println(idCnt+" <-- removeBoardAction idCnt");
	
	// 2. memberId와 memberPw가 일치할 시 삭제
	int row = 0;
	if(idCnt > 0){
		String removeBoardSql="DELETE FROM board WHERE board_no=?";
		PreparedStatement removeStmt = conn.prepareStatement(removeBoardSql);
		removeStmt.setInt(1, boardNo);
		System.out.println(removeStmt+CYAN+"<--removeBoardAction removeStmt"+RESET);
		
		// 수정했으면 row에 복사
		row = removeStmt.executeUpdate();
		System.out.println(row+CYAN+"<--removeBoardAction row"+RESET);
	}
	
/* Redirect */
	String msg = null;
	if(row==1){//삭제에 성공했다면 성공 메세지 보내고, home으로 보내기.
		msg = URLEncoder.encode("삭제 완료", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	} else if(row==0){//실패했으면 실패 메세지
		msg = URLEncoder.encode("삭제 실패", "UTF-8"); //실패했다면 오류메세지, 세션값과 함께 Form으로 보냄
		response.sendRedirect(request.getContextPath()+"/board/removeBoard.jsp?boardNo="+boardNo+"&memberId="+memberId+"&msg="+msg);
		return;
	}
%>