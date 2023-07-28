<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate(); //기존 세션을 지우고 갱신
	response.sendRedirect(request.getContextPath()+"/home.jsp");//밖에서 다시 접근하는 거니까 Context해야됨.
%>