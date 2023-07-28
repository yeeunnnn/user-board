<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//session 유효성 검사
	if(session.getAttribute("loginMemberId")==null
	|| session.getAttribute("loginMemberId").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println(memberId+"<--removeComment memberId");
	//request/response
	if(request.getParameter("commentNo")==null
	|| request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	System.out.println(commentNo+"<--removeComment commentNo");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>removeComment</title>
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
	<div><!-- 네비게이션 바 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="center">
		<%
			if(request.getParameter("msg")!=null){
		%>
			<%=request.getParameter("msg")%>
		<%		
			}
		%>
	</div>
     <div class="container mt-3"> 
		<form action="<%=request.getContextPath()%>/comment/removeCommentAction.jsp" method="post">
			<input type="hidden" name="commentNo" value="<%=commentNo%>">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<table class="table table-bordered table-sm">
				<tr class="center">
					<td colspan="2" class="center">
						<h5>댓글을 삭제하시겠습니까?</h5>
					</td>
				</tr>
				<tr class="center">
					<td>ID</td>
					<td>
						<input class="center" type="text" name="memberId" value="<%=memberId%>" readonly="readonly">
					</td>
				</tr>
				<tr class="center">
					<td>PW</td>
					<td>
						<input type="text" name="memberPw">
					</td>
				</tr>
				<tr class="center">
					<td colspan="2"><button type="submit" class="btn btn-outline-secondary" class="center">삭제</button></td>
				</tr>
			</table>
		</form>
	</div>
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>