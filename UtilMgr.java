package board;

import java.io.File;
import java.io.UnsupportedEncodingException;

public class UtilMgr {
	public static String con(String s) {
		String str = null;
		try {
			str = new String(s.getBytes("8859_1"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str;
	}
	
	public static void delete(String s) { // 파일이있을 시 삭제하는 메소드
		File file = new File(s);
		if(file.isFile()) {
			file.delete();
		}
	}
}
