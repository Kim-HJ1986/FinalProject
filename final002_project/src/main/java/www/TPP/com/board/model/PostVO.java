package www.TPP.com.board.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import www.TPP.com.common.model.CommonAttr;
import www.TPP.com.party.model.Party;

@Data
@NoArgsConstructor
public class PostVO extends CommonAttr{
	private String postId;	
	private String postTitle;
	private String sellCount;
	private double rate;
	
	private Party seller;

	public PostVO(String postId, String postTitle, String sellCount, double rate, Party seller) {
		super();
		this.postId = postId;
		this.postTitle = postTitle;
		this.sellCount = sellCount;
		this.rate = rate;
		this.seller = seller;
	}
	
	
}
