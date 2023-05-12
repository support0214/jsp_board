package board;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/boardUpdate")
public class BoardUpdateServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		String nowPage = request.getParameter("nowPage");
		
		BoardBean upBean = new BoardBean();
		upBean.setNum(Integer.parseInt(request.getParameter("num")));
		upBean.setName(request.getParameter("name"));
		upBean.setSubject(request.getParameter("subject"));
		upBean.setContent(request.getParameter("content"));
		upBean.setPass(request.getParameter("pass"));
		
		HttpSession session = request.getSession();
		BoardBean inBean = (BoardBean)session.getAttribute("bean");
		
		BoardMgr bMgr = new BoardMgr();
		if(inBean.getPass().equals(upBean.getPass())) {
			bMgr.updateBoard(upBean);
			String url = "read.jsp?nowPage=" + nowPage + "&num=" + upBean.getNum();
			response.sendRedirect(url);
		} else {
			out.print("<script>");
			out.print("alert('비밀번호가 맞지않습니다');");
			out.print("history.back();");
			out.print("</script>");
		}	
	}
	
}