package www.dream.com.bulletinBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import www.dream.com.bulletinBoard.model.ReplyVO;
import www.dream.com.bulletinBoard.persistence.ReplyMapper;
import www.dream.com.common.dto.Criteria;
import www.dream.com.framework.util.ComparablePair;

@Service
public class ReplyService {
	@Autowired
	private ReplyMapper replyMapper;
	
	/**---------------------댓글 서비스 관리-------------------------*/
	//LRCUD
	
	public int getCountOfReply(String replyId) {
		int idLength = replyId.length() + ReplyVO.ID_LENGTH;
		return replyMapper.getAllReplyCount(replyId, idLength);
	}
	
	/** 댓글 초기화면 */
	public ComparablePair<Criteria, List<ReplyVO>> getReplyListWithPaging(String originalId, Criteria cri){
		int idLength = originalId.length() + ReplyVO.ID_LENGTH;
		cri.setTotal(replyMapper.getReplyCount(originalId, idLength));
		ComparablePair<Criteria, List<ReplyVO>> ret = new ComparablePair<>(cri, replyMapper.getReplyListWithPaging(originalId, idLength, cri));
		return ret;
	}
	
	public List<ReplyVO> getReplyListOfReply(String replyId) {
		int idLength = replyId.length() + ReplyVO.ID_LENGTH;
		List<ReplyVO> justRead = replyMapper.getReplyListOfReply(replyId, idLength);
		
		return ReplyVO.buildCompositeHierarchy(justRead);
		//return justRead;
	}
				
	/** id 값으로 Post 및 Reply, Reply of Reply 객체 조회 */
	public ReplyVO findReplyById(String id) {
		return replyMapper.findReplyById(id);
	}

	/** 댓글 등록하기*/
	public int insertReply(String originalId, ReplyVO reply) {
		return replyMapper.insertReply(originalId, reply);
	}
	
	/** 댓글 수정 처리*/
	public int updateReply(ReplyVO reply) {
		return replyMapper.updateReply(reply);
	}
	
	/** 게시글 삭제 처리 */
	public int deleteReplyById(String id) {
		return replyMapper.deleteReplyById(id);
	}


	

}
