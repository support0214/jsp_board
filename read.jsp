<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardBean" %>
<jsp:useBean id="bMgr" class="board.BoardMgr" />
<%
	request.setCharacterEncoding("UTF-8");
	int num = Integer.parseInt(request.getParameter("num"));

	String nowPage = request.getParameter("nowPage");
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
	
	bMgr.upCount(num);
	BoardBean  bean = bMgr.getBoard(num);
	session.setAttribute("bean", bean);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body style="background-color: beige;">
<script>
	function download(filename) {
		downFrm.filename.value = filename;
		downFrm.submit();
	}
	function list() {
		listFrm.submit();
	}
</script>
<table align=center width=1000>
    <tr>
        <td bgcolor="lightgray" height=25 align=center>글읽기</td>
    </tr>
    <tr>
        <td colspan=2>
            <table width=100%>
                <tr>    
                    <td align=center bgcolor="lightgray">이름</td>
                    <td><%=bean.getName() %></td>
                    <td align=center bgcolor="lightgray">등록 날짜</td>
                    <td><%=bean.getRegdate() %></td>
                </tr>
                <tr>
                    <td align=center bgcolor="lightgray">제 목</td>
                    <td colspan=3><%=bean.getSubject() %></td>
                </tr>
                <tr>
                    <td align=center bgcolor="lightgray">첨부 파일</td>
                    <td colspan=3>
                    <% 
                        if(bean.getFilename()!=null && !bean.getFilename().equals("파일없음"))
                        {
                    %>
                        <a href="javascript:download('<%=bean.getFilename() %>')"><%=bean.getFilename() %></a>&nbsp;&nbsp;
                        <font color=blue>(<%=bean.getFilesize() %> KBytes)</font>
                    <% } else { %>
                            등록된 파일이 없습니다.
                            <% } %>        
                    </td>
                </tr>
                <tr>
                    <td colspan=4>
                    <%=bean.getContent() %>
                    </td>
                </tr>
                <tr>
                    <td colspan=4 align=right>
                        <%=bean.getIp() %> 로부터 글을 남기셨습니다 / 조회수 : <%=bean.getCount() %>
                    </td>
                </tr>
            </table>    
        </td>
    </tr>
    
    <tr>
        <td align="center" colspan="2">
        <hr>
        [ 
        <a href="javascript:list()">리스트</a> | 
        <a href="update.jsp?nowPage=<%=nowPage%>&num=<%=num%>">수정</a> | 
        <a href="reply.jsp?nowPage=<%=nowPage%>">답변</a> | 
        <a href="delete.jsp?nowPage=<%=nowPage%>&num=<%=num%>">삭제</a> 
        ]
        </td>
    </tr>
</table>
	<form name="downFrm" method="post" action="download.jsp">
		<input type="hidden" name="filename">
	</form>

	<form name="listFrm" method="post" action="list.jsp">
		<input type="hidden" name="nowPage" value="<%=nowPage %>">
		
		<% if(!(keyWord == null || keyWord.equals(""))) { %>
			<input type="hidden" name="keyField" value="<%=keyField %>">
			<input type="hidden" name="keyWord" value="<%=keyWord %>">
		<% } %>
		
	</form>
</body>
</html>






