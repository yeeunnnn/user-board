<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//세션 유효성 검사. (세션값 없으면 home으로 보내기)
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(session.getAttribute("loginMemberId")+"<--deleteCategoryForm loginMemberId");
	
	// localName 유효성 검사 : 어떤 카테고리를 삭제할 건지 localName값이 넘어오니까.
	if(request.getParameter("localName")==null
	|| request.getParameter("localName").equals("")){ //localName값이 null이거나 공백이면 One으로 보내고 아니면 변수에 값 받기
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp");
		return;
	}
	//받아온 localName 변수에 받기
	String localName = request.getParameter("localName");
	System.out.println(localName+"<--updateCategoryForm localName");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteCategoryForm</title>
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
	<div><!-- 상단 메뉴바 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
     <div class="container mt-3"> 
		<form action="./deleteCategoryAction.jsp" method="post">
			<table class="table table-bordered table-sm">
				<tr class="center">
					<td colspan="2"><h3>카테고리 삭제</h3></td>
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
					<td>삭제할 카테고리</td><!-- 삭제할 카테고리가 무엇인지 value값에 넣어주기 (수정불가 readonly) -->
					<td><input type="text" name="localName" value="<%=localName%>" readonly="readonly" class="center"></td>
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