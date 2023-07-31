<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	/* 디버깅 배경색 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
	/* 인코딩 */
	request.setCharacterEncoding("utf-8");
	
	/* 1. controller */
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println(memberId+CYAN+"categoryOne param memberId"+RESET);
	
	/* 2. model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	
	//드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--categoryOne driver"+RESET);
	//DB 접속
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--categoryOne conn"+RESET);
	
	// 카테고리 목록 결과셋(모델값)
	String subMenuSql = "SELECT local_name localName, createdate, updatedate FROM local ORDER BY updatedate desc";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	// 각 카테고리 객체들은 값이 하나가 아니라, 상세보기 속성 값, 댓글을 가지고 있어서 while을 사용
	ArrayList<Local> local = new ArrayList<Local>();
	while(subMenuRs.next()){ 
		Local l = new Local();
		l.setLocalName(subMenuRs.getString("localName"));
		l.setCreatedate(subMenuRs.getString("createdate"));
		l.setUpdatedate(subMenuRs.getString("updatedate"));
		local.add(l);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>categoryOne.jsp</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, tr, td {text-align:center; table-layout: fixed;}
		.red {color:#FF0000; text-decoration: none;}
		h1, h2, h3, h4, h5 {
			font-family: 'Days One', sans-serif;
			}
	</style>
</head>
<body>
<!-- 메인메뉴(가로) -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">
		<table class="table table-bordered table-sm">
			<tr>
				<td colspan="5">
					<h3>카테고리 조회</h3>
				</td>
			</tr>
			<!-- 오류 메세지 -->
			<tr class="red">
				<%
					if(request.getParameter("msg")!= null){
				%>
					<td colspan="5"><%=request.getParameter("msg")%></td>
				<%			
					}
				%>
			</tr>
			<tr>
				<td colspan="5">
					<a href="<%=request.getContextPath()%>/category/insertCategoryForm.jsp" class="btn btn-outline-secondary">추가</a>
				</td>
			</tr>
			<tr>
				<th>카테고리 이름</th>
				<th>생성일</th>
				<th>수정일</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			<%	    //for each문으로 전체 카테고리를 나열
					for(Local l : local) {
			%>
				<tr>
					<td><%=l.getLocalName()%></td>
					<td><%=l.getCreatedate()%></td>
					<td><%=l.getUpdatedate()%></td>
					<td><a href="<%=request.getContextPath()%>/category/updateCategoryForm.jsp?localName=<%=l.getLocalName()%>" class="btn btn-outline-secondary">수정</a></td><!--  pw 만드려면 테이블에 pw 추가. 기본값 '1234' -->
					<td><a href="<%=request.getContextPath()%>/category/deleteCategoryForm.jsp?localName=<%=l.getLocalName()%>" class="btn btn-outline-secondary">삭제</a></td>
				</tr>
			<%
					}
			%>	
		</table>
	</div>
		<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>