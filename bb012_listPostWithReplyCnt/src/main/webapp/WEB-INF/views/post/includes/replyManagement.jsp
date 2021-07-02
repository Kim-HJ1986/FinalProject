<!-- 게시글 상세 화면 (readPost.jsp)에서 이 모든 것이 들어가 있으면 너무 복잡해 집니다.
	따라서 분할 정복으로 복잡도를 관리합니다. 이는 유지 보수성 향상으로 이어집니다.-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 댓글 목록 출력 부분 -->
<div class="card-footer">
	<div class="card-header">
	댓글
	<button id="btnOpenReplyModalForNew" class="btn btn-primary btn-xs pull-right">댓글 달기</button>
	</div>
	<div class="card-body">
		<!-- 원글에 달린 목록 페이징으로 출력하기 -->
		<ul id="ulReply">
		</ul>
	</div>
	
	<!-- 페이징 처리 -->
	<div id="replyPaging" class='fa-pull-right'>
	</div>
</div>
		
<!-- 댓글 입력 모달창 -->
<div id="modalReply" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        		<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>	<!-- End of modal-header -->
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label> 
					<input class="form-control" name='replyContent' value='New Reply!!!!'>
				</div>
				<div class="form-group">
					<label>작성자</label> 
					<input class="form-control" name='replyer' value=''>
				</div>
				<div class="form-group">
					<label>Reply Date</label> 
					<input class="form-control" name='replyDate' value=''>
				</div>
				<input id="replyerId" type="hidden">
			</div>	
			<!-- End of modal-body -->
			<div class="modal-footer">
				<button id='btnModifyReply' type="button" class="btn btn-warning">Modify</button>
				<button id='btnRemoveReply' type="button" class="btn btn-danger">Remove</button>
				<button id='btnRegisterReply' type="button" class="btn btn-primary">Register</button>
				<button id='btnCloseModal' type="button" class="btn btn-default">Close</button>
			</div>	<!-- End of modal-footer -->
		</div>	<!-- End of modal-content -->
	</div>	<!-- End of modal-dialog -->
</div>
<!-- End of 댓글 입력 모달창 -->

<script type="text/javascript" src="\resources\js\post\reply.js"></script>
<script type="text/javascript" src="\resources\js\util\dateFormat.js"></script>

<script type="text/javascript">
	var ulReply = $("#ulReply");
	var postId = "${post.id}";
	var currentPageNum = 1;
	var replyPaging = $("#replyPaging");
	
	showReplyList(1);
	
	function showReplyList(pageNum){
		replyService.getReplyList(
			{
				orgId : postId,
				page : pageNum || 1
			},
			function(listReplyWithCount) {
				var criteria = listReplyWithCount.first;
				var listReply = listReplyWithCount.second;
				if(listReply == null || listReply.length == 0){
					//정보가 없을 시 ul에 담긴 내용 청소
					ulReply.html("");
					return;
				}
				//댓글이 있으면 li로 만들어서 ul에 담을 것
				strLiTags = printReplyOfReplyByRecursion(listReply, false);
				ulReply.html(strLiTags);
				
				replyPaging.html(criteria.pagingDiv);
			},
			function(errMsg){
				alert("댓글 조회 오류 :" + errMsg);
			}		
		);
	}
	
	//replyService 모듈
	replyService.getReplyList(
		{orgId:postId, page:1},
		function(listReply) {
			for (var i = 0, len = listReply.length || 0; i < len; i++){
				console.log(listReply[i]);
			}
		},
		function(errMsg){
			alert("댓글 조회 오류 :" + errMsg);
		}		
	);
	
	var modalReply = $("#modalReply");
	var inputReplyContent = modalReply.find("input[name='replyContent']");
	var inputReplyer = modalReply.find("input[name='replyer']");
	var inputReplyDate = modalReply.find("input[name='replyDate']");

	var btnRegisterReply = $("#btnRegisterReply");
	var btnModifyReply = $("#btnModifyReply");
	var btnRemoveReply = $("#btnRemoveReply");
	
	//댓글에서 대댓글 전체 조회
	ulReply.on("click", "li i", function(e) {
		e.preventDefault();
		
		var clickedLi = $(this).closest("li");
		var reply_id = clickedLi.data("reply_id");
		
		replyService.getReplyListOfReply(
				reply_id,
				function(listReplyWithHierarchy) {
					//먼저번에 조회한 결과인 ul은 청소하고 댓글 내용만 기억시키자.
					var ul = clickedLi.find("ul");
					ul.remove();
					strLiTags = clickedLi.html();
					strLiTags += printReplyOfReplyByRecursion(listReplyWithHierarchy, true);
					clickedLi.html(strLiTags);
				},
				function(errMsg){
					alert("댓글 조회 오류 :" + errMsg);
				}		
			);
	});
	
	/*내것이 앞에 것 보다 깊으면 재귀호출하고 앞의 것의 닫기 tag를 완성
	<ul>
		<li>3 첫 대댓글</li>
		<li>3 둘 대댓글
			<ul>
				<li>6 첫 대대댓글</li>
				<li>6 둘 대대댓글</li>
			</ul
		</li>
		<li>3 셋 대댓글 </li>
	</ul>
	*/
	
	function printReplyOfReplyByRecursion(listReplyWithHierarchy, wrapWithUl){
		var strRet = "";
		if(wrapWithUl){
			strRet = "<ul>";
		}
		for (var i = 0, len = listReplyWithHierarchy.length || 0; i < len; i++){
			strRet += '<li class="clearfix" data-reply_id = "' + listReplyWithHierarchy[i].id +'">';
			strRet += '	<div>';
			strRet += '		<div>';
			if (listReplyWithHierarchy[i].replyCnt > 0){
				strRet += '				<i>[' + listReplyWithHierarchy[i].replyCnt + ']</i>';
			}
			strRet += '			<strong>' + listReplyWithHierarchy[i].writer.name + '</strong>';
			strRet += '			<small>' + dateFormatService.getWhenPosted(listReplyWithHierarchy[i].updateDate) + '</small>';
			strRet += '			<button class="btn btn-primary btn-xs pull-right">대댓글 달기</button>'
			strRet += '		</div>';
			strRet += '		<p>' + listReplyWithHierarchy[i].content + '</p>';
			strRet += '	</div>';
			if (listReplyWithHierarchy[i].listReply.length != 0){
				strRet += printReplyOfReplyByRecursion(listReplyWithHierarchy[i].listReply, true);
			}
			strRet += '</li>';
		}
		if(wrapWithUl){
			strRet += "</ul>";
		}
		return strRet;
	}
	
	
	//댓글 신규 용도의 모달 창 열기.
	$("#btnOpenReplyModalForNew").on("click", function(e) {
		modalReply.data("original_id", postId);
		modalReply.data("display_target", null);
		showModalForCreate();
	});
	
	//대댓글 신규 용도의 모달 창 열기 -> li button(자손 결합자)
	ulReply.on("click", "li button", function(e) {
		e.preventDefault();
		
		var clickedLi = $(this).closest("li");
		modalReply.data("original_id", clickedLi.data("reply_id"));

		//추가 버튼을 누른 대대댓이 포함된 댓글
		var grandFather =  clickedLi.parents("#ulReply li").last();
		if (grandFather.length == 0){
			modalReply.data("display_target", clickedLi);
		}else{
			modalReply.data("display_target", grandFather);
		}
		
		
		showModalForCreate();
	});
	
	function showModalForCreate(){
		//모달에 들어있는 모든 내용 청소
		modalReply.find("input").val("");
		//신규 댓글 등록할 때 등록일자는 defualt처리. 따라서 보여 줄 필요가 없어요.
		inputReplyDate.closest("div").hide();
		
		btnModifyReply.hide();
		btnRemoveReply.hide();
		btnRegisterReply.show();
		
		modalReply.modal("show");
	}
	
	$("#btnCloseModal").on("click", function(e) {
		//모달에 들어있는 모든 내용 청소
		modalReply.find("input").val("");
		modalReply.modal("hide");
	});
	
	//목록에서 특정 댓글을 클릭하면 해당 댓글의 상세 정보를 Ajax-rest로 읽고 이를 모달창에 보여준다.
	//특정 댓글은 동적으로 추가된 것이기에 이벤트 위임 방식("li")을 활용하여야 한다.
	ulReply.on("click", "li p", function(e) {
		var clickedLi = $(this).closest("li");
		modalReply.data("display_target", clickedLi.parents("#ulReply li").last());
		
		replyService.getReply(
			clickedLi.data("reply_id"),	
			function(replyObj) {
				//수정 또는 삭제 시 댓글의 아이디가 필요합니다.
				modalReply.data("reply_id", replyObj.id);
				inputReplyContent.val(replyObj.content);
				inputReplyer.val(replyObj.writer.name);
				inputReplyDate.val(dateFormatService.getWhenPosted(replyObj.updateDate));
				
				inputReplyer.attr("readonly", true);
				inputReplyDate.attr("readonly", true);
				
				btnModifyReply.show();
				btnRemoveReply.show();
				btnRegisterReply.hide();
				
				modalReply.modal("show");
			},
			function(errMsg){
				alert("댓글 조회 오류 :" + errMsg);
			}
		);
	});
	
	//모달 창에서 내용을 사용자가 입력한 다음에 등록 버튼을 누르면 댓글로 등록하고 목록을 1쪽부터 다시 보여준다.
	btnRegisterReply.on("click", function(e) {
		var reply = {
			content:inputReplyContent.val()
		};
		
		replyService.addReply(
			modalReply.data("original_id"),
			reply,
			function(newReplyId) {
				modalReply.find("input").val("");	//들어있는 값 청소
				modalReply.modal("hide");
				
				displayUpdateContents(1);
			},
			function(errMsg){
				alert("댓글 등록 오류 :" + errMsg);
			}		
		);
	});
	
	//댓글 상세 내용이 모달창에 나타났으며 작성자가 그 내용을 수정하고 수정 버튼을 누르면 DB에 내용을 반영하고
	//모달창을 닫고 목록으로 돌아온다.
	btnModifyReply.on("click", function(e) {
		replyService.updateReply(
			{
				id:modalReply.data("reply_id"),
				content:inputReplyContent.val()
			},	
			function(resultMsg) {
				modalReply.modal("hide");
				
				//댓글 수정한 경우와 대댓을 수정한 경우로 나누어 반응시켜야 합니다.
				displayUpdateContents(currentPageNum);
			},
			function(errMsg){
				alert("댓글 수정 오류 :" + errMsg);
			}
		);
		
	});

	//댓글 상세 내용이 모달창에 나타났으며 작성자가 삭제 버튼을 누르면 DB에 내용을 반영하고
	//모달창을 닫고 목록으로 돌아온다.
	btnRemoveReply.on("click", function(e) {
		replyService.removeReply(
			modalReply.data("reply_id"),
			function(delResult) {
				modalReply.modal("hide");
				
				//댓글 삭제한 경우와 대댓을 삭제한 경우로 나누어 반응시켜야 합니다.
				displayUpdateContents(currentPageNum);
			},
			function(errMsg){
				alert("댓글 삭제 오류 :" + errMsg);
			}		
		);
	});
	
	function displayUpdateContents(targetPage){
		displayTargetLi = modalReply.data("display_target");
		if (displayTargetLi == null){
			//해당 쪽 목록을 다시 보여준다.
			showReplyList(targetPage);
		} else{
			var reply_id = $(displayTargetLi).data("reply_id");
			
			replyService.getReplyListOfReply(
					reply_id,
					function(listReplyWithHierarchy) {
						//먼저번에 조회한 결과인 ul은 청소하고 댓글 내용만 기억시키자.
						var ul = $(displayTargetLi).find("ul");
						ul.remove();
						strLiTags = displayTargetLi.html();
						strLiTags += printReplyOfReplyByRecursion(listReplyWithHierarchy, true);
						displayTargetLi.html(strLiTags);
					},
					function(errMsg){
						alert("댓글 조회 오류 :" + errMsg);
					}		
				);
			
			replyService.getAllReplyCountOfReply(
					reply_id,
					function(cnt) {
						//먼저 조회한 결과인 ul은 청소하고 댓글 내용만 기억시키자.
						var iTagForCntDisplay = $(displayTargetLi).find("i");
						var strongTagForCntDisplay = $(displayTargetLi).find("strong");
						if (cnt == 0){
							if (iTagForCntDisplay.length != 0)
								$(iTagForCntDisplay).remove();
						}else{
							if (iTagForCntDisplay.length == 0){
								strongTagForCntDisplay.before("<i>[" + cnt + "]</i>");
							}else{
								iTagForCntDisplay.html("[" + cnt + "]");
							}
						}
					},
					function(errMsg){
						alert("댓글 개수 조회 오류 :" + errMsg);
					}	
			);
		}
	}
	//페이징 중 하나를 선택하면 해당 쪽의 댓글 목록을 조회하여 갱신한다.
	replyPaging.on("click", "li a", function(e) {
		e.preventDefault();
		
		var clickedAnchor = $(this);
		currentPageNum = clickedAnchor.attr("href");
		
		showReplyList(currentPageNum);
	});

	
</script>








