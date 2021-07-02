<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 해더부분과 div 나눈것 -->
<%@include file="../includes/header.jsp"%>
  
<div class="container-fluid">
	<div class="card shadow mb-4">
		<div class="card-body">
			
			<!-- 출력파일 불러오기 -->
			<%@include file="./includes/postCommon.jsp" %>

			<button data-oper='modify' class="btn btn-primary">수정</button>
			<button data-oper='list' class="btn btn-secondary">목록</button>

			<form id="frmOper" action="/post/modifyPost" method="get">
				<input type="hidden" name="boardId" value="${boardId}">
				<input type="hidden" id="postId" name="postId" value="${post.id}">
				<input type="hidden" name="pageNumber" value="${pagination.pageNumber}">
				<input type="hidden" name="amount" value="${pagination.amount}">
				<input type="hidden" name="searching" value='${pagination.searching}'>
			</form>
		</div>

		<%@include file="./includes/replyManagement.jsp"%>

	</div>
</div>
<!-- /.container-fluid -->


</div>
<!-- End of Main Content -->
<%@include file="../includes/footer.jsp"%>


<script type="text/javascript">
$(document).ready(function() {
	var frmOper = $("#frmOper");
	$("button[data-oper='modify']").on("click", function() {
		frmOper.submit();
	});
	
	$("button[data-oper='list']").on("click", function() {
		frmOper.find("#postId").remove();
		frmOper.attr("action", "/post/listBySearch").submit();
	});
	
});
</script>








