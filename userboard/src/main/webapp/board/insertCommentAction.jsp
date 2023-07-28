<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*"%>
<%
/* 받아온 값: boradNo, memberId(세션값), commentContent */

/* 인코딩 */
   request.setCharacterEncoding("UTF-8");

/* 디버깅 배경색 지정 */
   final String RESET = "\u001B[0m";
   final String CYAN = "\u001B[46m";
   
   //댓글 입력 버튼을 눌러 넘어온 변수 확인
   System.out.println(request.getParameter("boardNo")+CYAN+"<--insertCommentAction param boardNo"+RESET);
   System.out.println(request.getParameter("memberId")+CYAN+"<--insertCommentAction param memberID"+RESET);
   System.out.println(request.getParameter("commentContent")+CYAN+"<--insertCommentAction param commentContent"+RESET);

/* Controller */
// request / response
	   if(request.getParameter("boardNo") == null
	      || request.getParameter("memberId") == null
	      || request.getParameter("boardNo").equals("")
	      || request.getParameter("memberId").equals("")){
	      response.sendRedirect(request.getContextPath()+"/home.jsp");
	      return;
	   }   //몇번째 글인지, 세션값 memberId가 넘어왔는지 확인 후, 넘어왔다면 변수에 int/String 형태로 저장
		   int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		   String memberId = request.getParameter("memberId");
	   
//commentContent 댓글 내용이 null이면 그 페이지에 있도록
	   if(request.getParameter("commentContent") == null
	      || request.getParameter("commentContent").equals("")){
	      response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	      return;
	   }  //댓글 내용 적혔으면 변수에 담기
	      String commentContent = request.getParameter("commentContent");

	   //디버깅
	   System.out.println(boardNo+CYAN+"<--insertCommentAction boardNo"+RESET);
	   System.out.println(memberId+CYAN+"<--insertCommentAction memberId"+RESET);
	   System.out.println(commentContent+CYAN+"<--insertCommentAction commentContent"+RESET);
      
/* Model */
// 1) DB
   String driver = "org.mariadb.jdbc.Driver";
   String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
   String dbuser = "root";
   String dbpw = "java1234";
   //드라이버 로딩
   Class.forName(driver);
   System.out.println(driver+CYAN+"<--insertCommentAction driver"+RESET);
   //DB 접속
   Connection conn = null;
   conn = DriverManager.getConnection(dburl, dbuser, dbpw);
   //디버깅
   System.out.println(conn+CYAN+"<--insertCommentAction conn"+RESET);
   
// 2) 모델 값
   String sql = null;
   PreparedStatement stmt = null;
   //board_no(현재 글) 기준으로 페이지가 보여지기 때문에 board_no를 꼭 가져와야 함.
   sql = "INSERT INTO comment (board_no, comment_content, member_id, createdate, updatedate) VALUES(?, ?, ?, NOW(), NOW())"; //삽입 절에는 정렬 넣을 필요 없음.
   stmt = conn.prepareStatement(sql);
   stmt.setInt(1, boardNo);
   stmt.setString(2, commentContent);
   stmt.setString(3, memberId);
   System.out.println(stmt+CYAN+"<--insertCommentAction stmt"+RESET);
   
// 3) Redirection
   // 오류: msg 표시가 안됨.
   //디버깅용 row
   int row = stmt.executeUpdate();
   System.out.println(row+CYAN+"<--insertCommentAction row"+RESET);
   //행이 수정되어 DB에 저장되었다면, boardOne으로 돌아가 읽힐 수 있도록. boradOne페이지는 boardNo 키 값이 있어야돼서 같이 보냄.
   if(row == 1){
      System.out.println(row+CYAN+"insertCommentAction 성공"+RESET);
      response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
      return;
   } else if(row == 0) {
      System.out.println(row+CYAN+"insertCommentAction 실패"+RESET);
      String msg = URLEncoder.encode("댓글을 입력하세요", "utf-8");
      response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
      return;
   }
%>