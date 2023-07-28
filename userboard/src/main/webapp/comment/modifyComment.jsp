<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
/* 디버깅 색상 지정 */
	final String RESET = "\u001B[0m";
	final String PURPLE = "\u001B[45m";
	
	System.out.println(request.getParameter("boardNo"));
	System.out.println(request.getParameter("commentNo"));
	
/* controller */
	// session
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String logInId = (String)session.getAttribute("loginMemberId");

	
	// request/response
	if(request.getParameter("commentNo")==null
	|| request.getParameter("boardNo")==null
	|| request.getParameter("commentNo").equals("")
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("memberId")==null
	|| request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId"); //memberId를 받아야함
	
	//로그인 아이디와 작성자가 일치하는지 확인하는 코드(유효성 검사)
	if(!logInId.equals(memberId)){
		String msg = URLEncoder.encode("로그인 아이디와 작성자가 일치하지 않습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
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
	System.out.println(driver+PURPLE+"<--modifyComment driver"+RESET);
	// connection DB에 접속
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+PURPLE+"<--modifyComment conn"+RESET);
	
	String sql = "select board_no boardNo, member_id memberId, comment_no commentNo, comment_content commentContent, createdate, updatedate FROM comment WHERE board_no = ? and comment_no = ? and member_id = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, commentNo);
	stmt.setString(3, logInId); //memberId와 logInId는 다른 것임
	//읽어줄 쿼리 생성문
	ResultSet rs = stmt.executeQuery();
	System.out.println(stmt+PURPLE+"<--modifyComment stmt"+RESET);
	
	Comment comment = null;
	if(rs.next()){ //한 개의 글에 대한 거니까 if문으로 한번만 출력.
		comment = new Comment();
		comment.setBoardNo(rs.getInt("boardNo"));
		comment.setCommentNo(rs.getInt("commentNo"));
		comment.setMemberId(rs.getString("memberId"));
		comment.setCommentContent(rs.getString("commentContent"));
		comment.setCreatedate(rs.getString("createdate"));
		comment.setUpdatedate(rs.getString("updatedate"));
	}
	System.out.println(comment.getBoardNo());
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>modifyComment</title>
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
	
		<form action="<%=request.getContextPath()%>/comment/modifyCommentAction.jsp?commentNo=<%=comment.getCommentNo()%>" method="post">
		<table class="table table-bordered">
			<tr class="center">
				<td colspan="2"><h3>댓글 수정</h3></td>
			</tr>
			<tr>
				<td colspan="2" class="center">
					<%
						if(request.getParameter("msg") != null){
					%>
						오류: <%=request.getParameter("msg")%>
						
					<%		
						}
					%>
				</td>
			</tr>
			<tr class="center">
				<td>boardNo</td>
				<td>
					<input type="number" name="boardNo" value="<%=comment.getBoardNo()%>" readonly="readonly" class="center"><!-- 프로그램 안에서는 다 카멜 표현식. DB는 안먹으니까 언더바!(바꿔주는 라이브러리도 있음) -->
				</td>
			</tr>
			<tr class="center">
				<td>memberId</td>
				<td>
					<input type="text" name="memberId" value="<%=comment.getMemberId()%>" readonly="readonly" class="center">
				</td>
			</tr>
			<tr class="center"><!-- 5행. 실제 수정할 내용!! set 안에 적기-->
				<td>
					CommentContent
				</td>
				<td>
					<textarea class="form-control" rows="5" cols="80" name="commentContent"><%=comment.getCommentContent()%></textarea>
				</td>
			</tr>
			<tr class="center">
				<td>
					createdate
				</td>
				<td class="center">
					<input type="text" value="<%=comment.getCreatedate()%>" readonly="readonly">
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