package www.dream.com.framework.util;

public class StringUtil {
	
	/**
	 * ids 분할하여 정수 배열로 반환
	 * @param ids 숫자가 ,로 구분되어 있습니다.
	 * @return
	 */
	public static int[] convertCommaSepString2IntArray(String ids) {
		String[] splited = ids.split(",");
		int[] ret = new int[splited.length];
		for (int i = 0; i < splited.length; i++) {
			try {
				ret[i] = Integer.parseInt(splited[i]);
			}catch(NumberFormatException e) {
			}
		}
		return ret;
	}
	
	public static boolean hasInfo(String str) {
		//null이면 정보 없고 또는 텅 비어 있어도 정보가 없는 상태임.
		return str != null && ! str.trim().isEmpty();
	}
	
	/*
	public static void main(String[] args) {
		String val = "2,3,4,5";
		int[] sss = convertCommaSepString2IntArray(val);
		for (int s : sss)
			System.out.println(s);
	}
	*/
}
