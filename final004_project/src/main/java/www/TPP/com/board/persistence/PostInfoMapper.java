package www.TPP.com.board.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import www.TPP.com.board.model.PostInfoVO;

public interface PostInfoMapper {
	public List<PostInfoVO> getPostInfoVOList(String postId);

	public PostInfoVO getPostInfoVO(@Param("postId") String postId, @Param("postInfoId") String postInfoId);
	
	
}
