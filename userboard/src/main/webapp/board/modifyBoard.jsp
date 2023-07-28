<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	/* 디버깅 색깔 지정 */
	final String RESET = "\u001B[0m";
	final String YELLOW = "\u001B[43m";
	
	/* controller */
	// session
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(session.getAttribute("loginMemberId")+YELLOW+"modifyBoard param memberId"+RESET);
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId");
	
	// request/response
	if(request.getParameter("boardNo")==null
	|| request.getParameter("memberId")==null){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&memberId="+memberId);
		return;
	}

	/* model */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = null;
	// 드라이버 로딩
	Class.forName(driver);
	System.out.println(driver+YELLOW+"<--updatePwAction driver"+RESET);
	// connection DB에 접속
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+YELLOW+"<--updatePwAction conn"+RESET);
	
	String sql = "select board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ? ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);//stmt의 첫번째 물음표 값을 noticeNo로 바꾼다.
	System.out.println("noticeNo값 잘 받아옴: " + stmt);
	
	// 받아온 값 반영
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	if(rs.next()){ //한 개의 글에 대한 거니까 if문으로 한번만 출력.
		board = new Board();
		board.setBoardNo(rs.getInt("boardNo"));
		board.setLocalName(rs.getString("localName"));
		board.setBoardTitle(rs.getString("boardTitle"));
		board.setBoardContent(rs.getString("boardContent"));
		board.setMemberId(rs.getString("memberId"));
		board.setCreatedate(rs.getString("createdate"));
		board.setUpdatedate(rs.getString("updatedate"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>boardOne</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table, td {text-align:center; table-layout: fixed;}
	</style>
</head>
<body>
	<!-- 네비게이션 바 -->
	<div><jsp:include page="/inc/mainmenu.jsp"></jsp:include></div>
	
		<form action="<%=request.getContextPath()%>/board/modifyBoardAction.jsp" method="post">
		<table class="table table-bordered">
			<tr class="center">
				<td colspan="2"><h3>게시글 수정</h3></td>
			</tr>
			<tr>
				<td colspan="2" class="center">
					<%
						if(request.getParameter("msg") != null){
					%>
						<%="오류: "+request.getParameter("msg")%>
						
					<%		
						}
					%>
				</td>
			</tr>
			<tr class="center">
				<td>boardNo</td>
				<td>
					<input type="number" name="boardNo" value="<%=board.getBoardNo()%>" readonly="readonly" class="center"><!-- 프로그램 안에서는 다 카멜 표현식. DB는 안먹으니까 언더바!(바꿔주는 라이브러리도 있음) -->
				</td>
			</tr>
			<tr class="center"><!-- 4행. -->
				<td>localName</td>
				<td>
					<input type="password" name="localName" value="<%=board.getLocalName()%>" readonly="readonly" class="center">
				</td>
			</tr>
			<tr class="center"><!-- 5행. 실제 수정할 내용!! set 안에 적기-->
				<td>
					boardTitle
				</td>
				<td>
					<input type="text" name="boardTitle" value="<%=board.getBoardTitle()%>" class="center">
				</td>
			</tr>
			<tr class="center">
				<td>
					boardContent
				</td>
				<td class="center">
					<textarea class="form-control" rows="5" cols="80" name="boardContent"><%=board.getBoardContent()%></textarea>
				</td>
			</tr>	
			<tr>
				<td colspan="2">
					<button type="submit" class="btn btn-outline-secondary">수정</button>
				</td>
			</tr>
		</table>
	</form>
	<!-- fotter -->
	<div><jsp:include page="/inc/copyright.jsp"></jsp:include></div>
</body>
</html>