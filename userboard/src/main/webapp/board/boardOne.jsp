<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %><!-- ArrayList -->
<%@ page import="vo.*" %><!-- 하나에 대한 이름, 글, 내용 등등이 나올 때 vo타입 사용. -->
<% 	
	/* 받아온 값
		boardNo, currentPage, rowPerPage
	*/
	
/* 디버깅 배경색 지정 */
	final String RESET = "\u001B[0m";
	final String CYAN = "\u001B[46m";
	
/* 인코딩 */
	request.setCharacterEncoding("utf-8");
	
/* Controller */
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String loginId = (String)session.getAttribute("loginMemberId");
	// request / response
	// 디버깅
	System.out.println(request.getParameter("boardNo")+CYAN+"<--boardOne param boardNo"+RESET);
	
	//만약 boardNo가 들어오지 않았으면 선택된 글이 없으니, home으로 보내기.
	if(request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return; //return문 잊지말 것
	}  //No값이 있다면 변수에 넣기.
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// 2) 댓글 목록 페이징할 값
	//현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+CYAN+"<--boardOne currentPage" +RESET);
	
	//출력되는 총 행의 수
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage")!=null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	System.out.println(rowPerPage+CYAN+"<--boardOne rowPerPage" +RESET);
	//시작 페이지
	int startRow = 0;
	startRow = (currentPage - 1) * rowPerPage;
	System.out.println(startRow+CYAN+"<--boardOne startRow" +RESET);
	
	//마지막 페이지는 model에서.

/* Model 2. 모델 계층 */
	// DB 연결에 사용할 변수
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	// DB 드라이브, 접속
	Class.forName(driver);
	System.out.println(driver+CYAN+"<--boardOne driver"+RESET);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--boardOne conn"+RESET);
	
	// 1) board one 상세보기 결과셋
	String oneSql = null;
	PreparedStatement oneStmt = null;
	ResultSet oneRs = null;
	//쿼리 생성 boardNo를 기준으로 출력하니까 board_no 있어야함.
	oneSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no=?";
	oneStmt = conn.prepareStatement(oneSql); 
	oneStmt.setInt(1, boardNo);
	//읽기용 쿼리 만들기
	oneRs = oneStmt.executeQuery();
	//디버깅
	System.out.println(oneStmt+CYAN+"<--boardOne 글 상세 stmt"+RESET);
	
	// board one 쿼리를 vo타입으로 변경
	Board board = null;
	if(oneRs.next()){ //한 개의 글에 대한 거니까 if문으로 한번만 출력.
		board = new Board();
		board.setBoardNo(oneRs.getInt("boardNo"));
		board.setLocalName(oneRs.getString("localName"));
		board.setBoardTitle(oneRs.getString("boardTitle"));
		board.setBoardContent(oneRs.getString("boardContent"));
		board.setMemberId(oneRs.getString("memberId"));
		board.setCreatedate(oneRs.getString("createdate"));
		board.setUpdatedate(oneRs.getString("updatedate"));
	}
	
	// 2) 댓글 리스트 결과셋
	String commentListSql = null;
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	//쿼리 생성
	commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? LIMIT ?, ?";
	commentListStmt = conn.prepareStatement(commentListSql); 
	commentListStmt.setInt(1, boardNo);
	commentListStmt.setInt(2, startRow);
	commentListStmt.setInt(3, rowPerPage);
	commentListRs = commentListStmt.executeQuery();

	// 2-1) 두번째 쿼리 ArrayList vo타입으로 변경
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	//여러개의 댓글이 나와야하니까 while문으로 많은 행을 읽고, ArrayList에 넣어줌. ('댓글' 하나에는 'memberId', 'commentContent'.. 등등이 포함)
	while(commentListRs.next()){
		Comment c = new Comment();
		c.setCommentNo(commentListRs.getInt("commentNo")); //오류: select에서 불러오지 않고 commentNo 변수에 값을 넣음.
		c.setBoardNo(commentListRs.getInt("boardNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate")); //오류: select에서 createdate와, updatedate를 불러오지 않아 null값으로 출력됨.
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
	}
	System.out.println(commentList.size()+CYAN+"boardOne commentList size"+RESET);
	
	// 3) 마지막 페이지
	PreparedStatement lastPageStmt = conn.prepareStatement("select count(*) from comment where board_no = ?");
	lastPageStmt.setInt(1, boardNo);
	ResultSet lastPageRs = lastPageStmt.executeQuery();
	
	int totalRow = 0;
	if(lastPageRs.next()){ //변수 vo타입. int형에 rs값을 넣어 사용.
		totalRow = lastPageRs.getInt("count(*)");
	}
	int lastPage = totalRow/rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
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
		table, td {
			text-align:center;
			table-layout: fixed;
			}
		.center {
			text-align:center;
		}
		.none {
			text-decoration: none;
			}
		.right {
		  float: right;
		}
	</style>
</head>
<body>
<!-- 3. view  -->
<!-- 네비게이션 바 -->
	<div><jsp:include page="/inc/mainmenu.jsp"></jsp:include></div>
	<br>
<!-- [시작] borad one 결과셋 -------------------------------------------------->	
	<div class="container">
	<!-- 글 상세 보기 if문 -->
	<table class="table table-bordered">
		<tr><!-- board 의(.) boardTitle을 출력. -->
			<td colspan="2"><h3><%=board.getBoardTitle()%></h3> 글 상세</td>
		</tr>
		<tr>
			<td>boardNo</td>
			<td><%=board.getBoardNo()%></td>
		</tr>
		<tr>
			<td>localName</td>
			<td><%=board.getLocalName()%></td>
		</tr>
		<tr>
			<td>boardTitle</td>
			<td><%=board.getBoardTitle()%></td>
		</tr>
		<tr>
			<td>boardContent</td>
			<td><%=board.getBoardContent()%></td>
		</tr>
		<tr>
			<td>memberId</td>
			<td><%=board.getMemberId()%></td>
		</tr>
		<tr>
			<td>createdate</td>
			<td><%=board.getCreatedate()%></td>
		</tr>
		<tr>
			<td>updatedate</td>
			<td><%=board.getUpdatedate()%></td>
		</tr>
		<%
			if(loginId.equals(board.getMemberId())){
		%>
		<tr><!-- 상세 글을 수정/삭제할 수 있는 Form/Action -->
			<td colspan="2">
				<a class="none" href="<%=request.getContextPath()%>/board/modifyBoard.jsp?boardNo=<%=boardNo%>&memberId=<%=board.getMemberId()%>"><button type="button" class="btn btn-outline-secondary">수정</button></a>
				<a class="none" href="<%=request.getContextPath()%>/board/removeBoard.jsp?boardNo=<%=boardNo%>&memberId=<%=board.getMemberId()%>"><button type="button" class="btn btn-outline-secondary">삭제</button></a>	
			</td>
		</tr>
		<%	
			}
		%>
	</table>
	</div>
<!-- [끝] borad one --------------------------------------------------------->	

<!-- [시작] comment 입력: 세션유무에 따른 분기 ------------------------------------->	
	<div>
      <div class="container">
	<%
		if(session.getAttribute("loginMemberId") != null){ //로그인이 되어있을 때만 보도록.
			String loginMemberId = (String)session.getAttribute("loginMemberId"); // 세션값이 null이 아니면 현재 로그인 사용자의 아이디 받기.
	%>
		<div class="center">
			<div class="text-danger">
							<%
								if(request.getParameter("msg")!=null){
							%>
								알림: <%=request.getParameter("msg")%>
							<%
								}
							%>
			</div>
		</div>
		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
			<input type="hidden" name = "boardNo" value="<%=board.getBoardNo()%>">
			<input type="hidden" name = "memberId" value="<%=loginMemberId%>">
			<table class="table table-bordered">
				<tr>
					<td>댓글</td>
					 <td><!-- commentContent 내용을 DB에 저장하도록 Action에 보냄 -->
					 	<textarea class="form-control" rows="2" name="commentContent"></textarea>
					 </td>
				</tr>	 
				<tr>
					<td colspan="2">
					    <button type="submit" class="btn btn-outline-warning">입력</button>
					 </td>
				</tr>
			</table>
		</form>	
		<%	
			}
		%>
	</div>
   </div>
<!-- [끝] comment -------------------------------------------------------------->

<!-- [시작] comment List -------------------------------------------------------->
<div class=container>
	<table class="table table-bordered">
		<tr>
			<td colspan="6"><h5>댓글 리스트</h5></td>
		</tr>
		<tr>
			<th>memberId</th>
			<th>commentContent</th>
			<th>createdate</th>
			<th>updatedate</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			if (commentList.isEmpty()) {
		%>
			<tr>
				<td colspan="6">
					<h5 class="text-secondary">댓글이 없습니다.</h5>
				</td>
			</tr>
		<%	
			}
			//commentList는 여러개의 댓글 객체를 보여줘야하니까 반복문 사용.(반복문 사용을 위해 ResultSet->VO타입(util의 ArrayList))
			for(Comment c : commentList){
		%>
		<tr>	
			<td><%=c.getMemberId()%></td>
			<td><%=c.getCommentContent()%></td>
			<td><%=c.getCreatedate()%></td>
			<td><%=c.getUpdatedate()%></td>
			
			<td><!-- 댓글을 수정할 수 있는 Form/Action -->
				<% //유효성 검사
					if(loginId.equals(c.getMemberId())){
				%>
					<a class="none" href="<%=request.getContextPath()%>/comment/modifyComment.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>&memberId=<%=c.getMemberId()%>"><button type="button" class="btn btn-outline-secondary">수정</button></a>
				<%
					}
				%>
			</td>
			<td><!-- 댓글을 삭제할 수 있는 Form/Action -->
				<% //유효성 검사
					if(loginId.equals(c.getMemberId())){
				%>
					<a class="none" href="<%=request.getContextPath()%>/comment/removeComment.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>&memberId=<%=c.getMemberId()%>"><button type="button" class="btn btn-outline-secondary">삭제</button></a>
				<%
					}
				%>
			</td>
		</tr>
		<%
			}
		%>
	
		<tr><!-- '이전' '다음' 버튼 -->
			<td colspan="6">
			<%	
				if(currentPage > 1){ //현재 페이지가 1이면 '이전' 링크가 없어야함.
			%>
				<a class="none" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>&rowPerPage=<%=rowPerPage%>"><button type="button" class="btn btn-outline-secondary">이전</button></a>
			<%
				}
			%>
				<%=currentPage%>	
			<%	
				if(currentPage < lastPage){
			%>
				<a class="none" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>&rowPerPage=<%=rowPerPage%>"><button type="button" class="btn btn-outline-secondary">다음</button></a>
			<%
				}
			%>
			</td>
		</tr>
	</table>
</div>
<!-- [끝] comment List ----------------------------------------------------------->
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>