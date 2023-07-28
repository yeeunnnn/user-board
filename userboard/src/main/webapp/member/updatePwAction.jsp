<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
/* controller */
	System.out.println(request.getParameter("memberPw")+CYAN+"updatePwAction param memberPw"+RESET);
	System.out.println(request.getParameter("newMemberPw")+CYAN+"updatePwAction param newMemberPw"+RESET);
	// 세션 유효성 검사. (세션값이 없으면 home으로 돌려보내도록)
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}// 세션 값이 있다면 memberId 변수에 값을 복사
	String memberId = (String)session.getAttribute("loginMemberId");
	// 비밀번호 변경 Form에서 memberPw와 newMemberPw 값이 왔는지 확인
	if(request.getParameter("memberPw")==null
		|| request.getParameter("newMemberPw")==null){
		response.sendRedirect(request.getContextPath()+"/member/updatePwForm.jsp?memberId"+memberId);
		return; //비밀번호 값 받은 게 없다면 그 페이지에 남아있게.
	} //받았다면 변수에 값 복사
	String memberPw = request.getParameter("memberPw");
	String newMemberPw = request.getParameter("newMemberPw");
	
/* model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	// 드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--updatePwAction driver"+RESET);
	// connection DB에 접속
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--updatePwAction conn"+RESET);
	// 수정 쿼리
	// 수정할 값 = memeber_pw, member_id
	String sql="UPDATE member SET member_pw=password(?) where member_pw = password(?) and member_id=?"; //where 오른쪽이 기존 것 비교, set은 새로운 값
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, newMemberPw);
	stmt.setString(2, memberPw);
	stmt.setString(3, memberId); //memberId도 비교해줘야 행의 비밀번호가 바뀜
	System.out.println(stmt+CYAN+"<--updatePwAction stmt"+RESET);
	// 수정할 쿼리는 보여줄 게 아니니, ResultSet으로 읽지 않아도 됨. executeUpdate 실행
	int row = stmt.executeUpdate();
	System.out.println(row+CYAN+"<--updatePwAction row"+RESET);
	
/* Redirect */
	String msg = null; // 한글 메세지를 길게 쓰려면 net.* import.
	if(row==1){ //수정에 성공했다면
		msg = "PW is updated"; //informationForm에서는 memberId 대신 session값을 따로 받으니 키를 넘겨주지 않아도됨.
		response.sendRedirect(request.getContextPath()+"/member/informationForm.jsp?msg="+msg);
		return;
	} else if(row==0){
		msg = "Incorrect PW";
		response.sendRedirect(request.getContextPath()+"/member/updatePwForm.jsp?msg="+msg);
		return;
	}
%>