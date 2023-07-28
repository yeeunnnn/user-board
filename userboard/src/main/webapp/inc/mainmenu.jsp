<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>home</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div>
	<ul class="nav nav-tabs"><!-- 로그인 했을 땐 ~~님. 로그아웃도 있고. --><!-- 메뉴도 리스트인데 -->
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li> <!-- 클라이언트에서 접근하는 거라서 request 해줘야됨. -->	
		<!--
			로그인 전 : 회원가입
			로그인 후 : null이 아닐때. 회원정보/로그아웃(로그인 정보는 세션에 loginMemberId로 저장 (클릭하면 자기정보 볼 수 있고 수정할 수 있고 탈퇴...로그아웃 등...)
		-->
		<%
			if(session.getAttribute("loginMemberId") == null) { //로그인 전
		%>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li> <!-- password하고 물음표. -->
		<%		
			} else { //로그인 후
		%>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/informationForm.jsp">회원정보</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
		<%
			}
		%>
	</ul>
</div>
</body>
</html>