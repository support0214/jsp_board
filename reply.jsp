<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="bean" class="board.BoardBean" scope="session" />
<%
	String nowPage = request.getParameter("nowPage");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body style="background-color: beige;">
	<table align="center" width="500px"  style="background-color: darkgoldenrod; height: 30px">
		<tr>
			<td align="center">답변하기</td>
		</tr>
	</table>
	<form method="post" name="boardReply" action="boardReply">
		<table align="center">
			<tr>
				<td align="center">성 명</td>
				<td><input name="name" size="5"></td>
			</tr>
			<tr>
				<td align="center">제 목</td>
				<td><input name="subject" size="48" value="답변 : <%=bean.getSubject()%>"></td>
			</tr>
			<tr>
				<td align="center">내 용</td>
				<td><textarea name="content" rows="10" cols="50">
				<%=bean.getContent() %>
				</textarea></td>
			</tr>
			<tr>
				<td align="center">비밀번호</td>
				<td><input type="password" name="pass" size="13" required></td>
				
			</tr>

			<tr>
				<td colspan="2"><hr></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" value="답변등록">&emsp;
					<input type="reset" value="다시쓰기">&emsp;
					<input type="button" value="뒤로" onclick="history.back()">
				</td>
			</tr>
		</table>
		<!-- 나의 정보 -->
		<input type="hidden" name="ip" value="<%=request.getRemoteAddr() %>">
		<!-- 앞에서 넘어온 값 -->
		<input type="hidden" name="nowPage" value="<%=nowPage %>">
		
		<!-- 부모글의 정보 -->
		<input type="hidden" name="ref" value="<%=bean.getRef() %>">
		<input type="hidden" name="pos" value="<%=bean.getPos() %>">
		<input type="hidden" name="depth" value="<%=bean.getDepth() %>">
	</form>
</body>
</html>