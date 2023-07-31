<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사. (세션값 없으면 home으로 보내기)
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(session.getAttribute("loginMemberId")+"<--removeBoard memberId");
	
	if(request.getParameter("boardNo")==null
	|| request.getParameter("memberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId");
	System.out.println(boardNo+"<--removeBoard boardNo");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>removeBoard</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	 	table, td {
	 		table-layout: fixed;
	 	}
	 	.center {
	 		text-align:center;
	 	}
	</style>
</head>
<body>
	<!-- 상단 메뉴바 -->
	<div>
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
		<form action="<%=request.getContextPath()%>/board/removeBoardAction.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<table class="table table-bordered table-sm">
				<tr class="center">
					<td colspan="2" class="center"><h5><%=boardNo%> 게시글을 삭제하시겠습니까?</h5></td>
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