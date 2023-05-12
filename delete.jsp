<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardBean" %>
<jsp:useBean id="bMgr" class="board.BoardMgr" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body style="background-color: beige;">
<%
	int num = Integer.parseInt(request.getParameter("num"));
	String nowPage = request.getParameter("nowPage");
	
	if(request.getParameter("pass") != null) {
		String inPass = request.getParameter("pass");
		BoardBean bean = (BoardBean)session.getAttribute("bean");
		String dbPass = bean.getPass();
		
		if(dbPass.equals(inPass)) {
			boolean result = bMgr.deleteBoard(num);
			if(result) {
				String url = "list.jsp?nowPage="+nowPage;
				response.sendRedirect(url);
			} else {
				out.print("<script>");
				out.print("alert('댓글이 있으므로 삭제할 수 없습니다');");
				out.print("history.go(-2);");
				out.print("</script>");	
			}       
		} else {
			out.print("<script>");
			out.print("alert('비밀번호가 맞지않습니다');");
			out.print("history.back();");
			out.print("</script>");
		}

	} else {
%>




	<form method="post" name="delFrm" action="delete.jsp">
		<table align="center" width="600px" style="text-align: center;">
			<tr style="background-color: aliceblue; height: 30px;">
				<td>사용자의 비밀번호를 입력해주세요</td>
			</tr>
			<tr>
				<td>
					<input type="password" size="10" name="pass" required>
				</td>
			</tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td>
						<input type="submit" value="삭제완료">
						<input type="reset" value="다시쓰기">
						<input type="button" value="뒤로" onclick="history.go(-1)">
				</td>
			</tr>
		</table>
		<input type="hidden" name="num" value="<%=num %>">
		<input type="hidden" name="nowPage" value="<%=nowPage %>">
	</form>
	<%		
	}
%>
</body>
</html>