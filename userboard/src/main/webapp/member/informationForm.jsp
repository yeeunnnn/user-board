<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
/* controller */
	System.out.println(session.getAttribute("loginMemberId")+CYAN+"informationForm param loginMemberId"+RESET);
	
	/* 세션 유효성 검사 */
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
/* 3. model */	
	// 회원 정보 보여주기 위해 읽기 전용 ResultSet
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--informationForm driver"+RESET);
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--informationForm conn"+RESET);
	// 보여줄 쿼리는 한명에 대한 정보니까 vo로 바꿀 때 if문으로 작성
	// 가져올 값 = 아이디(변경 불가), 가입일(변경 불가)
	String sql="SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member where member_id=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId); //조건이 맞는지 검사할 값은 Id만 (Id는 프라이머리키(행을 대표))
	System.out.println(stmt+CYAN+"<--informationForm stmt"+RESET);
	//정보를 보여주기만 함. 읽어줄 ResultSet, 쿼리 만드는 executeQuery 사용.
	ResultSet rs = stmt.executeQuery();
	//Member 클래스의 객체 member를 초기화
	Member member = null;
	if(rs.next()){
		member = new Member(); //선언
		member.setMemberId(rs.getString("memberId"));//private 인 필드는 getter/setter로 가져옴. get/set 뒤 처음 문자는 대문자.
		member.setCreatedate(rs.getString("createdate"));//여기서는 새 객체인 member에 값을 추가(수정)하는 것이니까 set
	}
	System.out.println(member.getMemberId()+CYAN+"<--informationForm memberId"+RESET);
	System.out.println(member.getCreatedate()+CYAN+"<--informationForm createdate"+RESET);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>informationForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, td {
			text-align:center;
			table-layout: fixed;
		}
	</style>
</head>
<body>
	<!-- 상단 메뉴바 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="bg-light">
		<div class="container">
			<table class="table table-bordered">
				<tr>
					<th colspan="2">회원정보 확인</th>
				</tr>
				<tr class="center"><!-- 오류 메세지 -->
					<%
						if(request.getParameter("msg")!= null){
					%>
							<td colspan="2"><%=request.getParameter("msg")%></td>
					<%			
							}
					%>
				</tr>
				<tr>
					<td>ID</td><!-- memberId는 지금 접속해있는 세션값(loginMemberId)으로, 세션 유효성 검사에서 받은 값을 출력 -->
					<td><%=memberId%></td>
				</tr>
				<tr><!--  -->
					<td>가입 날짜</td><!-- Member 클래스의 접근제한자가 private이기 때문에 getter/setter를 이용 -->
					<td><%=member.getCreatedate()%></td>
				</tr>
	
				<tr>
					<td colspan="2"><!-- 각각 Form으로 이동 -->
						<a href="<%=request.getContextPath()%>/member/updatePwForm.jsp"><button class="btn btn-outline-secondary">비밀번호 변경</button></a>
						<a href="<%=request.getContextPath()%>/member/deleteInformationForm.jsp"><button class="btn btn-outline-secondary">삭제</button></a>
					</td>
				</tr>
			</table>
		</div>
	  </div>
	<div><!-- 하단 footer -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>