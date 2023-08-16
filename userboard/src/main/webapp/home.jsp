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
	
	/* 1. 요청 분석 controller */
	//1) session JSP내장(기본)객체(Built in Objsect)(객체=객체변수의 줄임말=참조변수)(response session basic context 등)
	
	//2) request / response
	int currentPage = 1; //이렇게 해두고, 받아온 걸로 바꿔주기
	int rowPerPage = 10;
	int startRow = 0;
	
	//현재 페이지
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage +CYAN+"<--home currentPage" +RESET);
	//총 행의 수
	if(request.getParameter("rowPerPage")!=null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	System.out.println(rowPerPage +CYAN+"<--home rowPerPage" +RESET);
	//시작 페이지
	startRow = (currentPage - 1) * rowPerPage;
	System.out.println(startRow +CYAN+"<--home startRow" +RESET);
	
	//전체라는 메뉴를 클릭(localName으로 클릭됨)했을 때 그 값이 '전체' 데이터로 인식되어야 함
	String localName = "전체";
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
	}
	System.out.println(localName+CYAN+"<--home localName"+RESET);
	
	/* 2. 모델 계층(데이터를 만드는 과정) */
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn+CYAN+"<--home conn"+RESET);
	/*
		SELECT '전체' localName, COUNT(local_name) cnt FROM board
		UNION ALL 
		SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name
		UNION ALL SELECT local_name, 0 cnt FROM local WHERE local_name NOT IN (SELECT local_name FROM board)
		+보드에는 없지만, local에 있는 카테고리 이름을 불러와야함.
	*/

	//1) 서브메뉴 결과셋(모델) = 사이드 카테고리 바. UNION ALL로 두 쿼리를 집합하려면 열 수가 같아야하기 때문에 '전체'를 추가
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name UNION ALL SELECT local_name, 0 cnt FROM local WHERE local_name NOT IN (SELECT local_name FROM board)";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	
	//2) 게시판 목록에 대한 결과셋(모델) = 지역별 게시글 (전체일때 | 아닐때)
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = null; //null도 되고 큰 문제 없으면 "" 공백으로 초기화.
	/*
		SELECT
			board_no boardNo, //클릭하면 상세보기로 가게 하려고
			local_name localName,
			board_title boardTitle,
			createdate
		FROM board
		WHERE local_name = ?
		ORDER BY createdate DESC //가장 최신 순으로 보려고. 내림차순.
		LIMIT ?, ?
	*/
	
	if(localName.equals("전체")){ //where절을 뺌
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board ORDER BY createdate DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, startRow);
		boardStmt.setInt(2, rowPerPage);
		boardRs = boardStmt.executeQuery();
		System.out.println(boardStmt+CYAN+"<--home stmt"+RESET);
		//모델 값이 많아지면 stmt도 헷갈려지니까 boardStmt처럼 만들기.
	} else {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board WHERE local_name=? ORDER BY createdate DESC LIMIT ?,?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, localName);//변수 값으로 수정해야되니까 set
		boardStmt.setInt(2, startRow);
		boardStmt.setInt(3, rowPerPage);
		boardRs = boardStmt.executeQuery();//DB쿼리 결과셋 모델
		System.out.println(boardStmt+CYAN+"<--home stmt"+RESET);
	}
	
	// 3) lastPage
	String catSql = "select count(*) from board";
	String lastPageSql = " where local_name = ?";
	PreparedStatement catStmt = null;
    if (localName.equals("전체")) {
    	catStmt = conn.prepareStatement(catSql);
    } else {
    	catStmt = conn.prepareStatement(catSql+lastPageSql);
    	catStmt.setString(1, localName);
    }
    
	ResultSet catRs = catStmt.executeQuery();
	int totalRow = 0;
	if(catRs.next()){
		totalRow = catRs.getInt("count(*)");
	}
	
	//마지막 페이지
	int lastPage = totalRow/rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	
	/* 모델 데이터 */
	// 1. 사이드 subMenuList
	// 없는 값을 새로 생성하고, 조합했으니까 HashMap 사용
	//VO 대신 HashMap 타입을 사용 위에 "java.util.*" import
	//하나는 이름으로 사용할 거, 하나는 실제 들어올 값. <String, String> 말고 object는 모든 타입이 들어올 수 있음
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	// 2. 클릭시 이름과 타이틀 보이기. //애플리케이션에서 사용할 모델
	//있는 값을 그대로 사용할 수 있을 때는 HashMap 아닌 VO타입으로 사용 -> class 값 이용.
	ArrayList<Board> boardList = new ArrayList<Board>(); //처음부터 미리 사이즈가 0인게 나으니까
	//boardRs --> boardList
	while(boardRs.next()) {
		Board b = new Board();
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}
	System.out.println(boardList.size()+CYAN+"<-- home stmt"+RESET);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>home</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- JQuery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	<script>
	    if (window.jQuery) {  
	        // jQuery가 로드되었을 때 실행될 코드
	        $(document).ready(function () {
	            const urlParams = new URLSearchParams(window.location.search);
	            const msg = urlParams.get('msg');
	
	            if (msg) {
	                alert(msg);
	            }
	        });
	    } else {
	        // jQuery가 로드되지 않았을 때 실행될 코드
	        console.log('jQuery is not loaded.');
	    }
		</script>
	<style>
		table, td {
			text-align:center;
			table-layout: fixed;
		}
		.white {
			color:#FFFFFF;
			text-decoration: none;
		}
		.deco {
			color:#000000;
			}
		.black {
			color:#000000;
			text-decoration: none;
			}
		.right {
		  float: right;
		}
	</style>
</head>
<body>
	<%
		// request.getRequestDispatcher("/inc/mainmenu.jsp").include(request, response);
		// 이코드 액션태그로 변경하면 아래와 같다
	%>
<!-- 네비게이션 바 -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
<!--[시작] subMenuList 모델 출력 서브메뉴(세로) --------------------------------------------->

<div class="p-5 bg-light">
<div class="row">
	
		<%
			if(session.getAttribute("loginMemberId") != null){
		%>
			<h5>&nbsp;&nbsp;카테고리&nbsp;&nbsp;<a href="<%=request.getContextPath()%>/category/categoryOne.jsp"><button class="btn btn-outline-warning">관리</button></a></h5>
		<%		
			} else {
		%>
			<h5>&nbsp;&nbsp;카테고리</h5>
		<%		
			}
		%>
	<div class="col-sm-2">
		<ul class="nav nav-pills flex-column" class="center">
			<%
				for(HashMap<String, Object> m : subMenuList) {
			%>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
						<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
					</a><!-- hashMap은 변수 호출할 때 get으로. -->
				</li>
			<%		
				}
			%>
		</ul>
	</div>
<!--[끝] subMenuList -------------------------------------------------------------->

<!--[시작] 상세 목록 boardList --------------------------------------------------------------->
	<!-- 카테고리별 게시글 5개씩 -->
	<div class="col-sm-8">
			<!-- 로그인 했다면 게시글 추가 버튼 보이도록 -->
			<%
				if(session.getAttribute("loginMemberId")!=null){
			%>
				<a href="<%=request.getContextPath()%>/board/addBoard.jsp"><button class="right btn btn-outline-warning">게시글 추가</button></a>
			<%
				}
			%>
		<table class="table table-bordered">
			<tr class="table-warning">
				<th>localName</th>
				<th>boardTitle</th>
				<th>createdate</th>
			</tr>
			<!-- 나중에는 EL, JSTL 태그를 사용
					    <c:foreach var="b" items="boardList"> var를 쓰면 reflecttion API 작용. b가 어디에서 왔는지 파악.ex)"사람"을 보고 그 사람이 "여자"인지 거꾸로 올라가 알아보는.
							<tr>
								<td></td>
								<td></td>
							</tr>
						</c:foreach>
			 -->
			
			<% 
				if (boardList.isEmpty()) {
			%>
				<tr>
					<td colspan="3">
						<h5>게시글이 없습니다.</h5>
					</td>
				</tr>
			<%		
				}
				//Board 클래스의 객체 b를 one만큼 반복.
				for(Board b : boardList){
			%>
			<tr>
				<td><%=b.getLocalName()%></td>
				<td>
					<a class="deco" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
						<%=b.getBoardTitle()%>
					</a>
				</td>
				<td><%=b.getCreatedate()%></td>
			</tr>
			<%
				}
			%>			
			<tr>
				<td colspan = "3">
				<%
					if(currentPage > 1){
				%>
					<!-- "광명" 선택 후 '이전', '다음' 누르면 "전체"가 나오는 문제: localName 키 값을 주지 않아서 아무것도 선택안했을 때("전체")의 상태로 초기화 됨. -->
					<a class="black" href="<%=request.getContextPath()%>/home.jsp?localName=<%=localName%>&currentPage=<%=currentPage-1%>"><button type="button" class="btn btn-outline-secondary">이전</button></a>
				<%
					}
				%>	
					<%=currentPage%>
				<%
					if(currentPage < lastPage){
				%>	
					<a class="black" href="<%=request.getContextPath()%>/home.jsp?localName=<%=localName%>&currentPage=<%=currentPage+1%>"><button type="button" class="btn btn-outline-secondary">다음</button></a>
				<%
					} else {
				%>
					 &nbsp;
				<%		
					}
				%>	
				</td>
			</tr>
		</table>
	</div>
			<!-- 로그인 폼 -->
		<div class="col-sm-2">
			<%
				if(session.getAttribute("loginMemberId") == null) { // 로그인 전이면 로그인폼 출력
			%><!-- 로그인 할 경우 Action으로 넘겨주기 -->
				<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
					<table class="table table-bordered">
						<tr>
							<td>아이디</td>
							<td><input type="text" name="memberId" value="admin" class="form-control"></td><!-- 관리자:admin 일반:user1 -->
						</tr>
						<tr>
							<td>패스워드</td>
							<td><input type="password" name="memberPw" value="1234" class="form-control"></td>
						</tr>
						<tr>
							<td colspan="2"><button type="submit" class="btn btn-outline-warning">로그인</button></td>
						</tr>
					</table>
				</form>
			<%
				} else {
					String logInId = (String)session.getAttribute("loginMemberId");
			%>
				<div class="row">
					<div class="row-sm-4"></div>
					<div class="row-sm-4">
						<table class="table">
							<tr>
								<td><%=logInId%>님 반갑습니다!</td>
							</tr>
						</table>
					</div>
					<div class="row-sm-4"></div>
				</div>
			<%		
				}
			%>
			</div>
	</div>
</div>	

<!--[끝] boardList-------------------------------------------------------------- -->		
	<div class="bg-light"><!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>

</body>
</html>
