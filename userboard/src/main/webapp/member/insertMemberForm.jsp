<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertMemberForm</title>
<meta charset="UTF-8">
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, td {text-align:center; table-layout: fixed;}
		.red {text-align:center; color:#FF0000; text-decoration: none;}
	</style>
</head>
<body>
	<!-- 상단 메뉴바 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<!-- /web0502는 ContextPath를 통해 받아오고, 나머지 주소값은 /폴더명/파일명.jsp -->	
	<form action ="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
		<!-- Action에서 온 오류값이 있으면 나타냄 -->
		<div class="red">	
			<%
				if(request.getParameter("msg")!=null){
			%>
				오류: <%=request.getParameter("msg")%>
			<%
				}
			%>
		</div>
		<div class="container">
			<table class="table table-bordered"><!-- 받은 Id와 Pw값을 Action으로 넘겨줌 -->
				<tr>
					<th colspan="2">회원가입</th>
				</tr>
				<tr>
					<td>새로운 ID</td>
					<td><input type="text" name="memberId" class="form-control"></td>
				</tr>
				<tr>
					<td>새로운 PW</td>
					<td><input type="text" name="memberPw" class="form-control"></td>
				</tr>
				<tr>
					<td colspan="2"><button type="submit" class="btn btn-outline-secondary">입력</button></td>
				</tr>
			</table>
		</div>
	</form>
	<div><!-- 하단 footer -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>