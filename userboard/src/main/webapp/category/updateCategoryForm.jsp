<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	/* 인코딩 */
	request.setCharacterEncoding("utf-8");
	
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(session.getAttribute("loginMemberId")+"updateCategoryForm param loginMemberId");

	// categoryOne에서 받은 localName 유효성 검사
	if(request.getParameter("localName")==null //Form에서 받아온 값이 없거나, 공백인데 submit했다면
	|| request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath()+"/category/categoryOne.jsp"); //다시 Form 화면 보여줌
		return;
	}
	//받아온 localName 변수에 받아 사용
	String localName = request.getParameter("localName");
	System.out.println(localName+"<--updateCategoryForm localName");
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateCategoryForm</title>
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
	<div><!-- 상단 메뉴바 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	  <div class="container">
		<form action="./updateCategoryAction.jsp" method="post"><!-- 입력 받은 값을 Action으로 보냄 -->
			<table class="table table-bordered">
				<tr>
					<td colspan="2"><h3>카테고리 수정</h3></td>
				</tr>
				<tr class="center"><!-- Action에서 온 오류 메세지를 출력 -->
					<%
						if(request.getParameter("msg")!= null){
					%>		
							<td colspan="2">오류: <%=request.getParameter("msg")%></td>
					<%			
						}
					%>
				</tr>
				<tr>
					<td>현재 카테고리 이름</td><!-- 기존 비밀번호는 name도 똑같이. -->
					<td>
						<input type="text" name="localName" value="<%=localName%>" readonly="readonly" class="center" class="form-control">
					</td>
				</tr>
				<tr>
					<td>새 카테고리 이름</td><!-- 새 비밀번호는 name 이름을 바꿔야 구분 가능. -->
					<td>
						<input type="text" name="newLocalName" class="center" class="form-control">
					</td>
				</tr>
				<tr>
					<td colspan="2" class="center"><button type="submit" class="btn btn-outline-secondary">수정</button></td>
				</tr>
			</table>
		</form>
	  </div>
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>