<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body style="background-color: beige;">
	<table align="center" width="500px"  style="background-color: burlywood; height: 30px">
		<tr>
			<td align="center">수정하기</td>
		</tr>
	</table>
	<form method="post" name="" action="" enctype="multipart/form-data">
		<table align="center">
			<tr>
				<td align="center">성 명</td>
				<td><input name="name" size="5"></td>
			</tr>
			<tr>
				<td align="center">제 목</td>
				<td><input name="subject" size="48"></td>
			</tr>
			<tr>
				<td align="center">내 용</td>
				<td><textarea name="content" rows="10" cols="50"></textarea></td>
			</tr>
			<tr>
				<td align="center">비밀번호</td>
				<td><input type="password" name="pass" size="13">수정시에는 비밀번호가 필요합니다</td>
				
			</tr>

			<tr>
				<td colspan="2"><hr></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" value="수정완료">
					<input type="reset" value="다시수정">
					<input type="button" value="뒤로" onclick="location.href='list.jsp'">
				</td>
			</tr>
		</table>
		<input type="hidden" name="ip" value="<%=request.getRemoteAddr() %>">
	</form>
</body>
</html>