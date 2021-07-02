package www.dream.com.common.dto;

import lombok.Data;

@Data
public class Criteria {
	private static final float PAGINATION_TOTAL = 10; // 한 화면에 보여지는 페이지 번호 수
	private int pageNumber;	// pageNumber: 현재 페이지 번호
	private long amount;		// amount :페이지 당 보여줄 데이터 건수
	
	private int startPage, endPage;	// 화면에 출력되는 첫 페이지 번호 및 마지막 페이지 번호
	private boolean prev, next; 	// 앞으로 가기 및 뒤로 가기
	
	private long total; 				// 전체 데이터 건수.

	//next누르니 디폴트 생성자가 제일 먼저 불리는구나
	public Criteria() {
		this.pageNumber = 1;
		this.amount = 10;
	}
	
	public void setTotal(long total) {
		this.total = total;
		calc();
	}
	private void calc() {
		endPage = (int) (Math.ceil(pageNumber / PAGINATION_TOTAL) * PAGINATION_TOTAL);
		startPage = endPage - (int) (PAGINATION_TOTAL - 1);
		int realEnd = (int) Math.ceil((float) total / amount);
		if(endPage > realEnd) {
			endPage = realEnd;
		}
		
		prev = startPage > 1;
		next = endPage < realEnd;
	}
}
