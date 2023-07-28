<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String Yellow = "\u001B[43m";
/* controller */
	//session
	if(session.getAttribute("loginMemberId")==null){
		String msg = URLEncoder.encode("로그인하세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
/* model */
	// DB 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// DB 드라이브, 접속
	Class.forName(driver);
	System.out.println(driver+Yellow+"<--addBoard driver"+RESET);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+Yellow+"<--addBoard conn"+RESET);
	
	// localName 선택 쿼리
	String sql = "SELECT local_name localName FROM local";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	// vo타입으로 변경
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs.next()){
		Local l = new Local();
		l.setLocalName(rs.getString("localName"));
		localList.add(l);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addBoard</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, td {table-layout: fixed}
	 	.center {text-align:center}
	 	.none {text-decoration: none;}
	</style>
</head>
<body>
	<!-- 네비게이션 바 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container" class="center">
		<form action="<%=request.getContextPath()%>/board/addBoardAction.jsp" method="post">
			<table class="table table-bordered">
				<tr class="center">
					<td colspan="2"><h4>게시글 추가</h4></td>
				</tr>
				<tr class="center">
					<td>memberId</td>
					<td><input type="text" name="memberId" value="<%=memberId%>" readonly="readonly" class="center"></td>
				</tr>
				<tr class="center">
					<td>localName</td>
					<td>
						<select name="localName">
						<%
							for(Local l : localList){
						%>
							  <option><%=l.getLocalName()%></option>
							
						<%
							}
						%>	
						</select>
					</td>
				</tr>
				<tr class="center">
					<td>boardTitle</td>
					<td><input type="text" name="boardTitle" class="center"></td>
				</tr>
				<tr class="center">
					<td>boardContent</td>
					<td><textarea class="form-control" rows="5" name="boardContent" class="center"></textarea></td>
				</tr>
				<tr class="center">
					<td colspan="2"><button type="submit">입력</button></td>
				</tr>
			</table>
		</form>
	</div>
	
	<!-- fotter  -->
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>