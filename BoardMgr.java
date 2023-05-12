package board;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class BoardMgr {
	private DBConnectionMgr pool;
	private static final String SAVEFOLDER = "D:\\KJW\\04_jsp\\ch12_board\\src\\main\\webapp\\fileUpload";
	private static final String ENCTYPE = "UTF-8";
	private static final int MAXSIZE = 5*1024*1024*1024;
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = null;
	
	public BoardMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public void insertBoard(HttpServletRequest req) {
		MultipartRequest multi = null;
		
		String filename = null;
		int filesize = 0;

		try {
			con = pool.getConnection();
			File file = new File(SAVEFOLDER);
			/* 저장할 폴더가 없을때를 대비하여 만들어줌
			if(!file.exists()) // 파일이 존재하는가 ?
				file.mkdir(); // 파일이 없으면 하나 만들어줘
			*/	
			multi = new MultipartRequest(req, SAVEFOLDER, MAXSIZE, ENCTYPE, new DefaultFileRenamePolicy());
			if(multi.getFilesystemName("filename") != null) {
				filename = multi.getFilesystemName("filename");
				filesize = (int)multi.getFile("filename").length();
			}
			sql = "insert into board values(SEQ_BOARD.NEXTVAL,?,?,?,0,SEQ_BOARD.CURRVAL,0,SYSDATE,?,?,0,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, multi.getParameter("name"));
			pstmt.setString(2, multi.getParameter("subject"));
			pstmt.setString(3, multi.getParameter("content"));
			pstmt.setString(4, multi.getParameter("pass"));
			pstmt.setString(5, multi.getParameter("ip"));
			pstmt.setString(6, filename);
			pstmt.setInt(7, filesize);
			pstmt.executeUpdate();
				
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
		
		public int getTotalCount(String keyField, String keyWord) {
			int totalCount = 0;
			try {
				con = pool.getConnection();
				if(keyWord.equals("null") || keyWord.equals("")) {
					sql = "select count(num) from board";
					pstmt = con.prepareStatement(sql);
				} else {
					sql = "select count(num) from board where " + keyField + " like ?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, "%" + keyWord + "%");
				}
				rs = pstmt.executeQuery();
				if(rs.next()) {
					totalCount = rs.getInt(1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt);
			}
			return totalCount;
	}
		
	public ArrayList<BoardBean> getBoardList(String keyField, String keyWord, int start, int end) {
		ArrayList<BoardBean> alist = new ArrayList<BoardBean>();
		
		try {
			con = pool.getConnection();
			if(keyWord.equals("null") || keyWord.equals("")) {
				sql = "select BT2.* from(select rownum R1, BT1.* from(select * from board order by ref desc, pos)BT1)BT2 where R1 >= ? and R1 <= ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
			} else {
				sql = "select BT2.* from(select rownum R1, BT1.* from(select * from board order by ref desc, pos)BT1 where " +keyField+ " like ?)BT2 where R1 >= ? and R1 <= ?";
				pstmt = con.prepareStatement(sql);
				// pstmt.setString(1, keyField);
				pstmt.setString(1, "%" + keyWord + "%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
			}
			rs = pstmt.executeQuery();
			while(rs.next()) {
				BoardBean bean = new BoardBean();
				bean.setNum(rs.getInt("num"));
				bean.setName(rs.getString("name"));
				bean.setSubject(rs.getString("subject"));
				bean.setContent(rs.getString("content"));
				bean.setPos(rs.getInt("pos"));
				bean.setRef(rs.getInt("ref"));
				bean.setDepth(rs.getInt("depth"));
				bean.setRegdate(rs.getString("regdate"));
				bean.setCount(rs.getInt("count"));
				alist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return alist;
	}
	
//	public static void main(String[] args) {
//		new BoardMgr().insert();
//	}
//	
//	public void insert() {
//		try {
//			con = pool.getConnection();
//			sql = "insert into board(num,name,subject,content,pos,ref,depth,regdate,count,pass)"
//					+ " values(?,'이름','제목','내용',0,?,0,'2023/05/11',0,'1234')";
//			pstmt = con.prepareStatement(sql);
//			for(int i = 500; i<612; i++) {
//				pstmt.setInt(1, i);
//				pstmt.setInt(2, i);
//				pstmt.executeUpdate();
//			}
//		} catch (Exception e){
//			e.printStackTrace();
//		} finally {
//			pool.freeConnection(con, pstmt);
//		}
//	}
	
	public void upCount(int num) {
		try {
			con = pool.getConnection();
			sql = "update board set count = count + 1 where num = " + num;
			pstmt = con.prepareStatement(sql);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public BoardBean getBoard(int num) {
		BoardBean bean = new BoardBean();
		try {
			con = pool.getConnection();
			sql = "select * from board where num = " + num;
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				bean.setNum(rs.getInt(1));
				bean.setName(rs.getString(2));
				bean.setSubject(rs.getString(3));
				bean.setContent(rs.getString(4));
				bean.setPos(rs.getInt(5));
				bean.setRef(rs.getInt(6));
				bean.setDepth(rs.getInt(7));
				bean.setRegdate(rs.getString(8));
				bean.setPass(rs.getString(9));
				bean.setIp(rs.getString(10));
				bean.setCount(rs.getInt(11));
				bean.setFilename(rs.getString(12));
				bean.setFilesize(rs.getInt(13));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}

	
	// 파일 다운로드
	public void downLoad(HttpServletRequest request, HttpServletResponse response, JspWriter out, PageContext pageContext) {
		String filename = request.getParameter("filename");
		File file = new File(UtilMgr.con(SAVEFOLDER + File.separator + filename));
		byte b[] = new byte[(int)file.length()];
		
		// Accept-Ranges 해더가 존재하면, 중단된 다운로드 한곳부터 이어서 다운로드
		response.setHeader("Accept-Ranges", "bytes");
		String strClient= request.getHeader("User-Agent");
		if(strClient.indexOf("MSIE6.0") != -1) { // 버전에 따라다름
			response.setContentType("application/smnet; charset=UTF-8");
			response.setHeader("Content-Disposition", "filename=" + filename + ";");
		} else {
			response.setContentType("application/smnet; charset=UTF-8");
			response.setHeader("Content-Disposition", "attachment;filename=" + filename + ";");
		}
		
		// out 임시저장공간
		try {
			out.clear();
			out = pageContext.pushBody();
			if(file.isFile()) {
				BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
				BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
				int read = 0;
				while((read=fin.read(b)) != -1) {
					outs.write(b, 0, read);
				}
				outs.close();
				fin.close();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
		public void updateBoard(BoardBean upBean) {
			try {
				con = pool.getConnection();
				sql = "update board set name = ?, subject = ?, content = ? where num = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, upBean.getName());
				pstmt.setString(2, upBean.getSubject());
				pstmt.setString(3, upBean.getContent());
				pstmt.setInt(4, upBean.getNum());
				pstmt.executeUpdate();
				
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt);
			}
			
		}

		public boolean deleteBoard(int num) {
			boolean flag = false;
			try {
				con = pool.getConnection();
				sql = "select count(*) from board where ref = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					int result = rs.getInt(1);
					if(result == 1) {
						flag = true;
						sql = "select filename from board where num = ?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, num);
						rs = pstmt.executeQuery();
						if(rs.next() && rs.getString(1) != null) {
							File file = new File(SAVEFOLDER + "/" + rs.getString(1));
							if(file.exists()) {
								UtilMgr.delete(SAVEFOLDER + "/" + rs.getString(1));
							}
						}
						
						sql = "delete from board where num = ?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, num);
						pstmt.executeUpdate();
						
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return flag;
		}
		
		// 답변글의 위치값 증가 (기존에 댓글이 있는 경우만 위치 조절해줌)
		public void replyUpBoard(int ref, int pos) {
			try {
				con = pool.getConnection();
				sql = "update board set pos = pos + 1 where ref = ? and pos > ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, pos);
				pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				pool.freeConnection(con, pstmt);
			}
		}
		
		// 처음 댓글을 달 경우 
		public void replyBoard(BoardBean bean) {
			try {
				con = pool.getConnection();
				sql = "insert into board values(SEQ_BOARD.NEXTVAL,?,?,?,?,?,?,SYSDATE,?,?,0,null,null)";
				
				int depth = bean.getDepth() + 1;
				int pos = bean.getPos() + 1;
				
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, bean.getName());
				pstmt.setString(2, bean.getSubject());
				pstmt.setString(3, bean.getContent());
				pstmt.setInt(4, pos);
				pstmt.setInt(5, bean.getRef());
				pstmt.setInt(6, depth);
				pstmt.setString(7, bean.getPass());
				pstmt.setString(8, bean.getIp());
				pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				pool.freeConnection(con, pstmt);
			}
		}
}









