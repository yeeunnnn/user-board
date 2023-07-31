<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
	//디버깅
	System.out.println(session.getAttribute("loginMemberId")+CYAN+"updatePwForm param loginMemberId"+RESET);
	
	/* 세션 유효성 검사 */
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println(memberId+CYAN+"updatePwForm param memberId"+RESET);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updatePwForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, td {
			text-align:center; table-layout: fixed;
			}
	</style>
</head>
<body>
	<!-- 상단 메뉴바 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">
	<form action="./updatePwAction.jsp" method="post"><!-- 입력 받은 값을 Action으로 보냄 -->
		<table class="table table-bordered">
			<tr>
				<th colspan="2">비밀번호 변경</th>
			</tr>
			<tr class="center"><!-- 오류 메세지 -->
				<%
					if(request.getParameter("msg")!= null){
				%>		<!-- "오류: "글씨는 밖에 써야 출력이 된다. -->
						<td colspan="2">오류: <%=request.getParameter("msg")%></td>
				<%			
						}
				%>
			</tr>
			<tr class="center">
				<td>기존 비밀번호</td><!-- 기존 비밀번호는 name도 똑같이. -->
				<td>
					<input type="password" name="memberPw" class="center">
				</td>
			</tr>
			<tr class="center">
				<td>새 비밀번호</td><!-- 새롭게 넘겨주는 값이니 name 바꿔 보내기 -->
				<td>
					<input type="password" name="newMemberPw" class="center">
				</td>
			</tr>
			<tr>
				<td colspan="2" class="center"><button type="submit" class="btn btn-outline-secondary">변경</button></td>
			</tr>
		</table>
	</form>
	</div>
		
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>