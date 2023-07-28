<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %> <!-- net 패키지 안에 URLEncoder. 한글로 표시되어야 할 msg 메세지를 깨지지 않고 보이게 해줌. -->
<%@ page import="vo.*" %>
<%
	/* 디버깅 배경색 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";

/* 1. 인코딩 */
	request.setCharacterEncoding("utf-8");

/* 2. 세션 유효성 검사 */
	//로그인 되어있는 상태면 여기에 올 수 없음.
	if(session.getAttribute("loginMemberId")!=null){
		response.sendRedirect(request.getContextPath()+"/home.jsp"); //홈으로 보냄
		return;
	}

/* 3. 요청값 유효성 검사 */
	if(request.getParameter("memberId")==null //Form에서 받아온 값이 없거나, 공백인데 submit한거면
	|| request.getParameter("memberPw")==null
	|| request.getParameter("memberId").equals("")
	|| request.getParameter("memberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp"); //다시 Form 화면 보여줌
		return;
	}
	//받아온 값이 있으면 변수에 받기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println(CYAN+memberId+"<--memberId"+RESET);
	System.out.println(CYAN+memberPw+"<--memberPw"+RESET);
	
/* 4. 유효성 검사 후 객체 ParamMember에 값 넣어 사용하기  */
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
/* 5. DB */
	//DB 관련해 사용할 변수 미리 초기화해놓기.
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard"; //url 마지막에는 프로젝트명 적기
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null; //첫번째 쿼리는 ID가 중복인지 아닌지 판단할 SELECT문
	PreparedStatement stmt2 = null; //두번째 쿼리는 새로운 ID와 PW를 새롭게 추가할 INSERT문
	ResultSet rs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//첫번째 쿼리. SELECT 문으로, 있는 쿼리를 읽어서 중복하는 값이 읽혀지면 중복되었다고 msg 메세지.
	String sql="SELECT member_id FROM member WHERE member_id=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	rs = stmt.executeQuery();
	//읽을 땐 ResultSet으로.
	if(rs.next()){
		System.out.println(CYAN+"insertMemberAction id 중복"+RESET);
		String msg = URLEncoder.encode("중복된 ID 입니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	
	//두번째 쿼리. INSERT문으로, 입력한 ID와 PW를 DB에 저장.
	String sql2="INSERT INTO member(member_id, member_pw, createdate, updatedate) values(?,PASSWORD(?),NOW(),NOW())";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, paramMember.getMemberId());
	stmt2.setString(2, paramMember.getMemberPw());
	System.out.println(stmt2+CYAN+"<--stmt"+RESET);
	//insert는 그냥 insert 하고 끝. rs로 읽지 않아도 됨. 확인 작업은 아래 Redirection.
	
	
/* 6. Redirect/msg */
	int row = stmt2.executeUpdate();
	System.out.println(CYAN+row+"<--insertMemberAction row"+RESET);
	//완료 행의 개수에 따라 메세지 주기
	
	String msg = null;
	if(row == 1){
		msg = URLEncoder.encode("회원가입 완료", "utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg); //home은 member 파일에 있지 않아서 /member/home.jsp...로 쓰면 안됨
		return;
	} else {
		msg = URLEncoder.encode("회원가입 실패","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
%>