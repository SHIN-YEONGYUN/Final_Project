<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<script src="http://localhost:8099/js/jquery-3.6.4.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9a02700d6a520b1b4d23a9886f1160e0"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=APIKEY&libraries=services,clusterer,drawing"></script>
<script src="http://localhost:8099/js/travelspot_post.js"></script>

<link href="/css/import.css" rel="stylesheet" type="text/css"/>

</head>
<body>
<%@ include file="../views/home/header.jsp"%>

<!-- 관광명소이름 -->
<div class="font_title margin"> ${placedto.title} </div>
<p>${placedto.seq}</p>

<!-- 관광명소 메뉴바 -->
<hr class="hrmargin">
<div class="postmenu">
<p class="font_content" id="images">여행지 사진 모아보기</p>
<p class="font_content" id="info">여행지 상세정보</p>
<p class="font_content" id="comments">여행지 한줄평 남기기</p>
</div>
<hr class="hrmargin">

<div class="textarea-outerbox">
<p class="font_content">여행지 한줄평💭</p><br>  
<textarea id="contents" class="textarea-innerbox font_comment" cols="110" rows="4" placeholder="여행지에 대한 한줄평을 남겨주세요"> </textarea><br>
<input class="savebutton" type="submit" value="저장">
</form>
</div>
				
<!-- 댓글 노출 https://chlee21.tistory.com/156 참고-->
<c:forEach items="${commentsList }" var="comments">
<div class="comments-outerbox"><div class="comments-innerbox">
<p>${comments.contents }</p>
<p>닉네임 ${comments.writer }</p>
<p>작성일자 ${comments.writingtime}</p> 
<!-- 작성자에게만 보이는 버튼 -->
<input class="deletebutton" type="button" value="삭제">
<input class="updatebutton" type="button" value="수정">

</div></div>
</c:forEach>

<div style="position:fixed; bottom:3%; right:-10%;">
<a href="#"><img src="../img/top.png" width="5%" height="5%"></a></div>

<!-- 개선사항 -->
<!-- 여행지 사진 모아보기 아래 구분선만 색 변경x -->
<!-- 댓글 작성하는 textarea 글씨(not bod)로 변경-->
<!-- 버튼: 좋아요 (신고버튼) -->
</body>
</html>