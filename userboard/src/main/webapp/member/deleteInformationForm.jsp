<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사. (세션값 없으면 home으로 보내기)
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}// 세션 값이 있다면 memberId 변수에 값을 복사
	String memberId = (String)session.getAttribute("loginMemberId");
	// 디버깅
	System.out.println(memberId+"<--deleteInformationForm memberId");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteInformationForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, td {table-layout: fixed}
	 	.center {text-align:center}
	</style>
</head>
<body>
	<!-- 헤드 -->
	<div class="p-5 bg-primary text-center"></div>
	<!-- 상단 메뉴바 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
     <div class="container mt-3">
		<form action="./deleteInformationAction.jsp" method="post">
			<table class="table table-bordered table-sm">
				<tr class="center">
					<th colspan="2">계정 삭제</th>
				</tr>
				<tr><!-- 오류메세지 삭제되지 않았을 때 메세지 나오도록 -->
					<%
						if(request.getParameter("msg")!=null){
					%>
						<td colspan="2" class="center">오류: <%=request.getParameter("msg")%></td>
					<%
						}
					%>
				</tr>
				<tr class="center">
					<td>비밀번호 확인</td><!-- where절에서 Pw 같은지 확인할 것. -->
					<td><input type="password" name="memberPw" class="center"></td>
				</tr>
				<tr class="center">
					<td colspan="2"><button type="submit" class="btn btn-outline-secondary">삭제</button></td>
				</tr>
			</table>
		</form>
	</div>
		
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>