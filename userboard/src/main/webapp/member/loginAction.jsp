<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.net.*" %>
<%@ page import= "vo.*" %>
<% //null일때도 안보여주고 공백일때도 안보여주고. null을 보낼 수 없다.? 로그인 성공했으면 공백 보내고, 로그인 실패했으면 실패했다고........
   //로그인 한 사람이 다시 들어오지 못하게 막아야 함. 들어오면 getParameter값을 못받아서 에러남	
	/* 디버깅 배경색 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
	//1. session 유효성 검사가 우선임
	if(session.getAttribute("loginMemberId")!=null){ //받아온 멤버값이 있으면 home으로 보내라.
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//2. 요청값 유효성 검사
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println(memberId+CYAN+"<--memberId"+RESET);
	System.out.println(memberPw+CYAN+"<--memberPw"+RESET);
//--------------------------------------------------------vo타입 묶기
	//유효성 검사 됐으면 paramMember에 그 값을 집어넣어라. 다른 데서 쓸 때도 따로따로 쓰지 말고 paramMember만 부르면 되니까.
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);

	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	System.out.println(stmt+CYAN+"<--loginAction stmt"+RESET);
	rs = stmt.executeQuery();
	if(rs.next()){ //로그인 성공. 있으면 돌리고 
		//세션에 로그인 정보(memberId) 저장
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션 정보 : " +CYAN+ session.getAttribute("loginMemberId")+RESET);
	} else { //로그인 실패. 없으면 말고.
		System.out.println("로그인 실패");
		
	}
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>