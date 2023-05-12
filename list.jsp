<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, board.*" %>
<jsp:useBean id="bMgr" class="board.BoardMgr" />
<%
	request.setCharacterEncoding("UTF-8");
	int totalRecord = 0; // 전체레코드 수
	int numPerPage = 10; // 한 페이지당 레코드 수
	int pagePerBlock = 5; // 블록당 보여줄 페이지 수 [1][2][3][4][5] 
	
	int totalPage = 0; // 전체페이지 수 ex) 72개 [1][2][3][4][5][6][7][8]
	int totalBlock = 0; // 전체블록 수 ex) 2개
	
	int nowPage = 1; // 현재 해당하는 페이지
	int nowBlock = 1; // 현재 해당하는 블록
	
	int start = 0; // DB테이블에 select 시작번호
	int end = 0; // 가져온 레코드중에서 10개씩만 가져오기
	int listSize = 0; // 현재 읽어온 게시물의 수

	String keyWord = "", keyField="";
	if(request.getParameter("keyWord") != null) {
		keyWord = request.getParameter("keyWord");
		keyField = request.getParameter("keyField");
	}
	
	/* [처음으로] 누를 때 */
	if(request.getParameter("reload") != null) {
		if(request.getParameter("reload").equals("true")) {
			keyWord = "";
			keyField = "";
		}
	}
	
	if(request.getParameter("nowPage") != null) {
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}
	
	start = ((nowPage*numPerPage) - numPerPage) + 1;
	end = nowPage*numPerPage;
	totalRecord = bMgr.getTotalCount(keyField, keyWord);
	totalPage = (int)Math.ceil((double)totalRecord / numPerPage);  // 전체페이지 수
	nowBlock = (int)Math.ceil((double)nowPage / pagePerBlock);	   // 현재블럭 계산
	totalBlock = (int)Math.ceil((double)totalPage / pagePerBlock); // 전체블럭 계산
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	a:link{text-decoration:none; color:black;}
	a:hover{text-decoration:yes; color:blue;}
	a:visited{text-decoration:none; color:black;}
</style>
<script>
	function read(num) {
		readFrm.num.value = num;
		readFrm.action = "read.jsp";
		readFrm.submit();
	}
	function list() {
		listFrm.action = "list.jsp";
		listFrm.submit();
	}
	function block(value) {
		readFrm.nowPage.value = <%=pagePerBlock%>*(value-1)+1;
		readFrm.submit();
	}
	function paging(page) {
		readFrm.nowPage.value = page;
		readFrm.submit();
	}
</script>
</head>
<body style="background-color: beige;">

	<h2 align="center">JSPBoard</h2>
	<table align="center" width="700px">
		<tr>
			<td colspan="5" >Total : <%=totalRecord %>Articles(<%=nowPage %> / <%=totalPage %>)Page</td>
		</tr>		
		<tr bgcolor="#BDBDBD">
			<th width="10%">번호</th>
			<th width="40%">제목</th>
			<th width="15%">이름</th>
			<th width="25%">날짜</th>
			<th width="10%">조회수</th>
		</tr>
		<%
			ArrayList<BoardBean> alist = bMgr.getBoardList(keyField, keyWord, start, end);
			listSize = alist.size();
			
			for(int i = 0; i < end; i++) {
				if(i == listSize)
					break;
				BoardBean bean = alist.get(i);
				
				int num = bean.getNum();
				String subject = bean.getSubject();
				String name = bean.getName();
				String regdate = bean.getRegdate().substring(0,10);
				int count = bean.getCount();
				int depth = bean.getDepth();
		%>
		<tr>
			<td><%=totalRecord-(nowPage-1)*numPerPage-i %></td>
			<td>
				<%
					if(depth > 0) {
						for(int j = 0; j < depth; j++) {
							out.print("&emsp;");
						}
						out.print("⨽");
					}
				%>
				<a href="javascript:read('<%=num%>')"><%=subject %></a>
			</td>
			<td><%=name %></td>
			<td><%=regdate %></td>
			<td><%=count %></td>
		</tr>
		<%
			}	
		 %>
		<tr>
			<td colspan="5"><br/><br/></td>
		</tr>
		<tr>
			<!-- 페이징처리 시작 -->
			<td colspan="3">
			<%
			// 블록 1 [1][2][3][4][5]  블록2  [6][7][8][9][10] 블록3 [11]
				int pageStart = (nowBlock-1) * pagePerBlock + 1; // 블록1 = 1, 블록2 = 6, 블록3 = 11
				/*
				int totalRecord 총 게시물
				int numPerPage 페이지당 레코드 개수()
				int pagePerBlock 
				int totalPage 총 페이지 개수
				int totalBlock 총 블럭 개수
				int nowPage 현재 페이지
				int nowBlock 현재 블럭
				*/
				int pageEnd = (pageStart+pagePerBlock) <= totalPage ? pageStart+pagePerBlock : totalPage+1;
				if(totalPage != 0) {
					if(nowBlock > 1) {
			%>
						<a href="javascript:block('<%=nowBlock-1 %>')">prev...</a>
			<%
					}
					for(; pageStart<pageEnd; pageStart++){
			%>
						<a href="javascript:paging('<%=pageStart %>')">[<%=pageStart %>]</a>
						 
			<%			
					}
					if(totalBlock > nowBlock){
			%>
						<a href="javascript:block('<%=nowBlock+1 %>')">...next</a> 
			<%
					}
				}
			%>	
			</td>
			<!-- 페이징처리 끝 -->
			
			<td colspan="2">
				<a href = "post.jsp" >[글쓰기]</a>&nbsp;
				<a href = "javascript:list()">[처음으로]</a>
			</td>			
		</tr>
		
</tr>
	</table>
	<hr width="700"/>
	<form name="searchFrm" method="get" action="list.jsp">
		<table align="center" width="800">
			<tr>
				<td align="center">
					<select name="keyField">
						<option value="name">이름</option>
						<option value="subject">제목</option>
						<option value="content">내용</option>
					</select>
					<input name="keyWord" required>
					<input type="submit" value="찾기">
					<input type="hidden" name="nowPage" value="1">
				</td>
			</tr>
		</table>
	</form>
	
	<!-- [처음으로] 누르면 화면이 reload -->
	<form name="listFrm" method="post">
		<input type="hidden" name="reload" value="true">
		<input type="hidden" name="nowPage" value="1">
	</form>
	
	<!-- 제목을 누르면 상세보기 페이지로 이동할때 파라미터 값 -->
	<form name="readFrm" method="get">
		<input type="hidden" name="num">
		<input type="hidden" name="nowPage" value="<%=nowPage %>">
		<input type="hidden" name="keyField" value="<%=keyField %>">
		<input type="hidden" name="keyWord" value="<%=keyWord %>">
	</form>
</body>
</html>