package www.dream.com.bulletinBoard.service;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.bulletinBoard.model.PostVO;
import www.dream.com.bulletinBoard.persistence.ReplyMapper;
import www.dream.com.common.dto.Criteria;
import www.dream.com.framework.langPosAnalyzer.PosAnalyzer;
import www.dream.com.framework.util.StringUtil;
import www.dream.com.hashTag.model.HashtagVO;
import www.dream.com.hashTag.persistence.HashTagMapper;

/**
 * 이는 ReplyVO와 PostVO의 클래스 설계도를 기반으로
 * 해당 Table을 Top전략으로 통합하여 만들었기에 
 * ReplyMapper는 통합해 놓았다.
 * PostService를 ReplyService와 분리하였다.
 * @author Jun_Kim
 *
 */
@Service
public class PostService {
	@Autowired
	private ReplyMapper postMapper;
	@Autowired
	private HashTagMapper hashTagMapper;

	// LRCUD
	public long getSearchTotalCount(int boardId,Criteria cri) {
		if(cri.hasSearching()) {
			return postMapper.getSearchTotalCount(boardId, cri);
		}else {
			return postMapper.getTotalCount(boardId);
			//return postMapper.getTotalCount(boardId, PostVO.DESCRIM4POST); 안돼서 버림!
		}
	}
	
	/**
	 * mapper 함수의 인자 개수가 여러개 일 때는 필수적으로 @Param을 넣어야 합니다. 이를 실수하지 않기 위하여 한개여도 명시적으로
	 * 넣어 주세요.
	 */
	public List<PostVO> getListByHashTag(int boardId, Criteria cri){
		if(cri.hasSearching()) {
			return postMapper.getListByHashTag(boardId, cri);
		}else {
			return postMapper.getList(boardId, cri);
		}
	}


	/** id 값으로 Post 객체 조회 */
	public PostVO findPostById(String id) {
		return (PostVO) postMapper.findReplyById(id);
	}

	public int insert(BoardVO board, PostVO post) {
		//게시글 등록처리 (insert)
		int affectedRows =  postMapper.insert(board, post);
		//단어와 출현빈도를 찾아냄.
		Map<String, Integer> mapOccur = PosAnalyzer.getHashTags(post);
		//단어들만 추출해냄.
		Set<String> setHashTag = mapOccur.keySet();
		//단어가 비어있지 않다면 기존 사전에 등록되어 있던 해쉬태그를 찾는다.
		createHashTagAndMapping(post, mapOccur, setHashTag);
		return affectedRows;
	}
	
	private void createHashTagAndMapping(PostVO post, Map<String, Integer> mapOccur, Set<String> setHashTag) {
		if(setHashTag.isEmpty()) {
			//게시글에서 단어가 나타나지 않았으면 처리할 것이 없군요.
			return;
		}
		
		Set<HashtagVO> setExisting = hashTagMapper.findExisting(setHashTag);
		//기존에 있는 것들과는 짝 지어 주어야합니다.
		for (HashtagVO hashtag : setExisting) {
			//기존에 있던 곳에서만 기억시킨다.
			hashtag.setOccurCnt(mapOccur.get(hashtag.getHashtag()));
		}
		
		//setHashTag에 남은 것들은 신규 처리해야할 것들입니다. 
		for (HashtagVO hashtag : setExisting) {
			setHashTag.remove(hashtag.getHashtag());
		}
		Set<String> setNewHashTag = setHashTag;
		if(!setNewHashTag.isEmpty()) {
			//새로운 단어를 HashTag 테이블에 등록해줍니다.
			int[] ids = StringUtil.convertCommaSepString2IntArray(hashTagMapper.getIds(setNewHashTag.size()));
			int idx = 0;
			Set<HashtagVO> setHT = new HashSet<>();
			for (String hashTag : setNewHashTag) {
				HashtagVO newHashtag = new HashtagVO(ids[idx++], hashTag);
				newHashtag.setOccurCnt(mapOccur.get(hashTag));
				setHT.add(newHashtag);
			}
			hashTagMapper.createHashTag(setHT);
			//새 단어를  단어집에 넣었으니 기존 단어가 된 것입니다.
			setExisting.addAll(setHT);
		}
		
		//기존 단어 및 신규 단어와 짝짓기(매핑)하는 것.
		hashTagMapper.insertMapBetweenPost(setExisting, post.getId());
	}

	/** 게시글 수정 처리 */
	public boolean updatePost(PostVO post) {
		return postMapper.updatePost(post) == 1;
	}
	
	/** id 값으로 Post 객체 조회 */
	public boolean deletePostById(String id) {
		return postMapper.deleteReplyById(id) == 1;
	}
	
}
