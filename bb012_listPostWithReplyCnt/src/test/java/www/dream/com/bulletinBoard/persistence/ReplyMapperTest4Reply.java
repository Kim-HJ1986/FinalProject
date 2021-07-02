package www.dream.com.bulletinBoard.persistence;

import static org.junit.Assert.assertNotNull;

import java.util.stream.IntStream;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import www.dream.com.bulletinBoard.model.ReplyVO;
import www.dream.com.common.dto.Criteria;
import www.dream.com.party.model.User;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src\\main\\webapp\\WEB-INF\\spring\\root-context.xml")
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ReplyMapperTest4Reply {
	@Autowired
	private ReplyMapper replyMapper;
	@Autowired
	private ReplyMapper postMapper;

	// @Test
	public void test040GetList() {
		assertNotNull(replyMapper);
		try {
			replyMapper.getReplyListWithPaging("00007", "00007".length() + ReplyVO.ID_LENGTH, new Criteria())
					.forEach(reply -> {
						System.out.println(reply);
					});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// @Test
	public void test000InsertReply() {
		try {
			// 자유게시판 최신글 찾아서 original(원글)로 삼자
			ReplyVO original = postMapper.getList(3, new Criteria()).get(0);
			// 댓글 아무렇게나 만들어서 insert할거야
			User Lee = new User("Lee");
			IntStream.rangeClosed(0, 1).forEach(i -> {
				ReplyVO reply = new ReplyVO("content" + i, Lee);
				replyMapper.insertReply(original.getId(), reply);
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void test000InsertReplyOfReply() {
		try {
			// 자유게시판 최신글 찾아서 original(원글)로 삼자
			// 댓글 아무렇게나 만들어서 insert할거야
			User Lee = new User("Lee");
			IntStream.rangeClosed(0, 1).forEach(i -> {
				ReplyVO reply = new ReplyVO("content" + i, Lee);
				replyMapper.insertReply("0000700009", reply);
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// @Test
	public void test030FindById() {
		try {
			ReplyVO post = postMapper.findReplyById("0000700009");
			System.out.println(post);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
