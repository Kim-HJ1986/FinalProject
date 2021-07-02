<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="../includes/header.jsp"%>
<!-- Begin Page Content -->
<div class="container-fluid">
  
	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<div class="card-body">
			<form  id="frmPost" action="/post/modifyPost" method="post">
			
				<%@include file="./includes/postCommon.jsp" %>
				
				<button type="submit" data-oper='modify' class="btn btn-primary">수정 완료</button>
				<button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
				<button type="submit" data-oper='list' class="btn btn-secondary">목록으로</button>
				
				<input id="boardId" type="hidden" name="boardId" value="${boardId}">
				<input type="hidden" name="postId" value="${post.id}">
				<input type="hidden" name="pageNumber" value="${pagination.pageNumber}">
				<input type="hidden" name="amount" value="${pagination.amount}">
				<input type="hidden" name="searching" value='${pagination.searching}'>
				
			</form>
		</div>
	</div>

</div>
<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->
<%@include file="../includes/footer.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	controlInput('수정');
	
	var frmPost = $("#frmPost");
	
	//처리 우선 순위가 있고 script가 html에 등록되어있는 것보다 앞선다.
	$("button").on("click", function(eventInfo){
		eventInfo.preventDefault();
		
		var oper = $(this).data("oper");
		if(oper === 'remove'){
			frmPost.attr("action", "/post/removePost");
		}else if(oper === 'list'){
			var boardIdInput = frmPost.find("#boardId");
			var pageNumber = $('input[name="pageNumber"]');
			var amount = $('input[name="amount"]');
			
			var searching = $('input[name="searching"]');
			
			frmPost.attr("method", "get");
			frmPost.attr("action", "/post/listBySearch");
			//empty : form에 담겨있는 모든 하위 요소를 없애라
			frmPost.empty();
			frmPost.append(boardIdInput);
			frmPost.append(pageNumber);
			frmPost.append(amount);

			frmPost.append(searching);
		}
		frmPost.submit();
	});
});
</script>





