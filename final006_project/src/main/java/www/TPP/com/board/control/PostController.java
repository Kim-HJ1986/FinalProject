package www.TPP.com.board.control;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import www.TPP.com.board.model.PostVO;
import www.TPP.com.board.service.BoardService;
import www.TPP.com.board.service.PostInfoService;
import www.TPP.com.board.service.PostService;
import www.TPP.com.common.paging.Criteria;
import www.TPP.com.party.model.Seller;
import www.TPP.com.party.service.PartyService;
import www.TPP.com.product.service.ProductService;

@Controller
@RequestMapping("/post/*")
public class PostController {
	@Autowired
	private PostService postService;
	@Autowired
	private BoardService boardService;
	@Autowired
	private PostInfoService postInfoService;
	@Autowired
	private ProductService productService;
	@Autowired
	private PartyService partyService;
	
	@GetMapping(value = {"postList"})
	public void listBySearch(@RequestParam("boardId") String boardId, 
			@ModelAttribute("pagination") Criteria fromUser, Model model) {
		model.addAttribute("boardId", boardId);
		model.addAttribute("boardName", boardService.getBoard(boardId).getBoardName());
		model.addAttribute("postList", postService.getPostList(fromUser));
		fromUser.setTotal(postService.getTotalCount(boardId, fromUser));
	}
	
	@GetMapping(value = "managementProduct")
	public void managementProduct(@RequestParam("boardId") String boardId,
			@RequestParam("sellerId") String sellerId, @ModelAttribute("pagination") Criteria fromUser, Model model) {
		model.addAttribute("boardId", boardId);
		model.addAttribute("boardName", boardService.getBoard(boardId).getBoardName());
		model.addAttribute("postListBySellerId", postService.getPostListBySellerId(sellerId));
		fromUser.setTotal(postService.getTotalCount(boardId, fromUser));
	}

	@GetMapping(value = { "readPost", "modifyPost" })
	public void findPostById(@RequestParam("boardId") String boardId,
			@RequestParam("postId") String postId, @ModelAttribute("pagination") Criteria fromUser, Model model) {
		model.addAttribute("post", postService.getPost(boardId, postId));
		model.addAttribute("boardId", boardId);
		model.addAttribute("postInfoList", postInfoService.getPostInfoVOList(postId));
		model.addAttribute("postList", postService.getPostList(fromUser));
		model.addAttribute("productList", productService.getProductListByPostId(postId));
	}
	
	@GetMapping(value="registerPost")
	public void registerPost(@RequestParam("boardId") int boardId,
			@ModelAttribute("pagination") Criteria fromUser, Model model) {
		model.addAttribute("boardId", boardId);
		model.addAttribute("postList", postService.getPostList(fromUser));
	}

	@PostMapping(value="registerPost")
	public String registerPost(@RequestParam("boardId") int boardId, 
			PostVO newPost, RedirectAttributes rttr, Model model) {
		Seller writer = new Seller();
		newPost.setSellerId(writer.getBusinessName());
		postService.registerPost(newPost);
		

		//listBySearch??? ?????? ???????????? ?????? ????????? ?????????? ????????? ????????? ???????????? ?????? ?????? ???????????? ??? ??? ??????.
		return "redirect:/post/managementProduct?sellerId=seller2";
	}
	
}
