<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
/* controller */
	System.out.println(request.getParameter("memberPw")+CYAN+"deleteInformationAction param memberPw"+RESET);
	// ID 세션 값 유효성 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} //세션 값 있다면 변수에 복사해 사용
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println(memberId+CYAN+"<--deleteInformationAction memberId"+RESET);
	// 받아온 PW 유효성 검사
	if(request.getParameter("memberPw")==null) {
		response.sendRedirect(request.getContextPath()+"/member/deleteInformationForm.jsp?memberId"+memberId);
		return;
	} //Pw값이 들어왔다면 변수에 복사해 사용
	String memberPw = request.getParameter("memberPw");
	System.out.println(memberPw+CYAN+"<--deleteInformationAction memberId"+RESET);
	
/* model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	//드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--deleteInformationAction driver"+RESET);
	//DB에 접속
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--deleteInformationAction conn"+RESET);
	// ? 아이디의, ? 비밀번호를 삭제
	String sql="DELETE FROM member WHERE member_id=? and member_pw = password(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId); 
	stmt.setString(2, memberPw);
	System.out.println(stmt+CYAN+"<--deleteInformationAction stmt"+RESET);
	// 수정했으면 row에 복사
	int row = stmt.executeUpdate();
	System.out.println(row+CYAN+"<--deleteInformationAction row"+RESET);
	
/* Redirect */
	String msg = null;
	if(row==1){//삭제에 성공했다면 성공 메세지 보내고, home으로 보내기.
		msg = "delete";
		session.invalidate(); //기존 세션을 지우고 갱신
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	} else if(row==0){//실패했으면 실패 메세지
		msg = "not deleted"; //실패했다면 오류메세지, 세션값과 함께 Form으로 보냄
		response.sendRedirect(request.getContextPath()+"/member/deleteInformationForm.jsp?msg="+msg);
		return;
	}
%>