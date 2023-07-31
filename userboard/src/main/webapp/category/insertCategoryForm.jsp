<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	/* 세션 유효성 검사 = 항상 같은 루트로 들어오지 않음. */
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//디버깅
	System.out.println(session.getAttribute("loginMemberId")+"<--insertCategoryForm param loginMemberId");
%>	
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>insertCategoryForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, td {text-align:center; table-layout: fixed;}
		.center {text-align:center; table-layout: fixed;}
		.red {color:#FF0000; text-decoration: none;}
	</style>
</head>
<body>
	<div><!-- 상단 메뉴바 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<form action ="<%=request.getContextPath()%>/category/insertCategoryAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<td colspan="2"><h3>카테고리 추가</h3></td>
				</tr>
				<tr class="red">
					<td colspan="2">
						<!-- insertCategoryAction에서 온 오류 메세지 -->
						<%
							if(request.getParameter("msg")!=null){
						%>
							오류: <%=request.getParameter("msg")%>
						<%
							}
						%>
					 </td>
				</tr>
				<tr><!-- 추가할 것 -->
					<td>카테고리 이름</td>
					<td><input type="text" name="localName" class="form-control"></td>
				</tr>
				<tr>
					<td colspan="2"><button type="submit" class="btn btn-outline-secondary">추가</button></td>
				</tr>
			</table>
		</form>
	</div>
	<div><!-- 하단 footer -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>