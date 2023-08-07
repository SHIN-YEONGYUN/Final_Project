<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<script src="/js/jquery-3.6.4.min.js"></script>
<link href="/css/travelspot/import.css" rel="stylesheet" type="text/css"/>

<script>
$(document).ready(function() {

	//js url parameter 가져오기
	let urlParams = new URL(location.href).searchParams;
	let commentid = urlParams.get('id');//댓글번호
	let boardId = urlParams.get('boardId'); //게시글 번호
});
</script>

</head>
<body>
<header>
<%@ include file="../home/header.jsp" %>
</header>
<hr style="width: 66vw; margin: 0 auto;">
<form id="reportCommentForm" action="/comments/report" method="post">
<div id="reportComment">
<div class="font_title">댓글 신고창<hr><br>
<div class="readonly">작성된 댓글 번호</div><input type="text" name="commentId" class="readonlyinput" value="${commentid }" readonly ><br>
<div class="readonly">댓글 작성자 닉네임</div><input type="text" name="reportedId" class="readonlyinput" value="${reportedId }" readonly ><br>
<div class="readonly">신고자 닉네임</div><input type="text" name="userNickname" class="readonlyinput" value="${nickname }" readonly="readonly"><br>
<input type="text" name="userId" value="${userid }" hidden="hidden">
<input type="text" name="contentId" value="${boardId }" hidden="hidden">
<div class="readonly">신고카테고리</div>
<select name="reportCategory" id="reportCategory">
 <option value="음란물">음란물</option>
 <option value="과도한 욕설" selected>과도한 욕설</option>
 <option value="광고">광고</option>
 <option value="스팸">스팸</option>
 <option value="사회분위기 저해">사회분위기 저해</option>
</select><br>
<div class="readonly">신고내용 </div>
<textarea id="reportcontents" name="reportContents">
관리자가 해당 내용을 참고하여 댓글 블라인드 여부를 결정할 예정입니다.
어떠한 점이 불편했는지 작성해주시면 감사하겠습니다.
</textarea><br>
<button type="submit" class="savebutton">저장</button>
</div>
</div>
</form>


</body>
</html>
