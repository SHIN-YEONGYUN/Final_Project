<%@ page import="travelspot.PlaceDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<script src="/js/jquery-3.6.4.min.js"></script>
<script src="/js/travelspot/travelspot_post_theme.js"></script>
<script src="/js/travelspot/travelspot_comment.js"></script>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9a02700d6a520b1b4d23a9886f1160e0&libraries=services&autoload=false"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9a02700d6a520b1b4d23a9886f1160e0&libraries=services"></script>

<link href="/css/travelspot/import.css" rel="stylesheet" type="text/css"/>

</head>
<body>
<%@ include file="../home/header.jsp"%>
 
<!-- 관광명소이름 -->
<div class="font_title margin"> ${placedto.title}
<img src="../img/heart (2).png" id="like" style="float:right">
<img src="../img/share.png" width=30vw height=30vh style="float: right" id="share">
<input type="hidden" id="like_id" value="${userdto}"/>

</div>

<!-- 관광명소 메뉴바 -->
<hr class="hrmargin">
<div class="postmenu">
<p class="font_content" id="images" style="cursor: pointer">여행지 사진 모아보기</p>
<p class="font_content" id="info" style="cursor: pointer">여행지 상세정보</p>
<p class="font_content" id="comments" style="cursor: pointer">여행지 한줄평 남기기</p>
</div>
<hr class="hrmargin">

<div class="weather" style="float:right;"></div><!-- 날씨 들어갈 자리 -->
<div class="result"> </div><!-- ajax 이용 결과물 출력하는 곳 -->

<div class="parent">
<a href="#"><img src="../img/top.png" width="5%" height="5%"></a>
<a href="#" onclick="location.href = document.referrer;"><img src="../img/prev.png" width="5%" height="5%"></a>
</div>



</body>
</html>
