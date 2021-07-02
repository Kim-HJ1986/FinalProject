<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:useBean id="tablePrinter" class="www.dream.com.framework.printer.TablePrinter"/>

<div class="form-group">
	<label>아이디</label> <input name="id" value="${post.id}"	class="form-control" readonly>
</div>
<div class="form-group">
	<label>제목</label> <input id="title" name="title" value="${post.title}" class="form-control" readonly>
</div>
<div class="form-group">
	<label>내용</label>
	<textarea id="txaContent" name="content" class="form-control" rows="3" readonly>${post.content}</textarea>
</div>
<div class="form-group">
	<label>작성자</label> 
	<input value="${post.writer.name}" class="form-control" readonly>
</div>
<div class="form-group">
	<label>조회수</label> <input value="${post.readCnt}" readonly>
	<label>좋아요</label> <input value="${post.likeCnt}" readonly>
	<label>싫어요</label> <input value="${post.dislikeCnt}" readonly>
</div>
<div class="form-group">
	<label>등록시점 : </label>
	<fmt:formatDate pattern="yyyy-MM-dd" value="${post.registrationDate}" />
	<label>, 수정시점 : </label>
	<fmt:formatDate pattern="yyyy-MM-dd" value="${post.updateDate}" />
</div>

<script type="text/javascript">
	<!-- 신규 화면에서 필요한 것들 title과 content에 readonly 없어야함-->
	<!-- 수정 화면에서 필요한 것들 title과 content에 readonly 없어야함-->
	function controlInput(includer){
		if(includer === '수정' || includer === '신규'){
			$('#title').attr("readonly", false);
			$('#txaContent').attr("readonly", false);
		}
	}
</script>

