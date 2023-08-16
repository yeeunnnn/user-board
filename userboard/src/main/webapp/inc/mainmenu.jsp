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
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	
	<!-- 폰트 -->
	<link href="https://fonts.googleapis.com/css2?family=Days+One&display=swap" rel="stylesheet">
	<style>
		.font {
			font-family: 'Days One', sans-serif;
		}
	</style>
</head>
<body>
	<div class="bs-component">
        <nav class="navbar navbar-expand-lg bg-light" data-bs-theme="light">
          <div class="container-fluid">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/home.jsp">User Board</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor03" aria-controls="navbarColor03" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarColor03">
              <ul class="navbar-nav me-auto">
              <%
				if(session.getAttribute("loginMemberId") == null) { //로그인 전
			  %>
                <li class="nav-item">
                  <a class="nav-link active" href="<%=request.getContextPath()%>/home.jsp">Home
                  </a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a>
                </li>
              <%		
				 } else { //로그인 후
			  %>
			  	<li class="nav-item">
                  <a class="nav-link active" href="<%=request.getContextPath()%>/home.jsp">Home
                  </a>
                </li>
			  	<li class="nav-item">
                  <a class="nav-link" href="<%=request.getContextPath()%>/member/informationForm.jsp">회원정보</a>
                </li>
                <%
                	if(session.getAttribute("loginMemberId").equals("admin")){
                %>
                	<li class="nav-item">
	                  <a class="nav-link" href="<%=request.getContextPath()%>/member/empListBySearch.jsp">직원정보</a>
	                </li>
                <%		
                	}
                %>
                <li class="nav-item">
                  <a class="nav-link" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a>
                </li>
               <%
				 }
			   %> 
              </ul>
            </div>
          </div>
        </nav>
	</div>
	<!-- 헤드 -->
	<div class="p-5 bg-light text-center">
		<h3 class="font">User Board</h3>
	</div>
</body>
</html>