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
<script src="/js/weather_modal.js"></script>
<link rel="stylesheet" href="/css/home/weather(modal).css">
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


<!-- 날씨 -->
<button id="btn-modal">
<div id="weather" style="position: absolute; top:50%; right : 5%; float:right">
<img id="imgsrc" src="">
<div class="city" style="font-size : 0.6vw;display: inline-box;"></div>
<div style="font-size : 0.6vw; display: inline-box;" class="current_temp" ></div>
</div>
</button>
<div id="modal" class="modal-overlay" style="z-index: 9999;">

        <div class="modal-window">
            <div class="title">
                <h2>weather</h2>
            </div>
            <div class="close-area">X</div><br><br>
            
            <div class="content">
            
            <div  style="text-align: center"><img id="imgsrcd" src=""  style="width:30%;"></div>
            
            <div style="padding-top: 20%">
    		<div style="float : right; margin : -20px 10px 30px 130px; font-size : 11pt">
            <div class="temp_min"></div>
            <div class="temp_max"></div>
            <div class="humidity"></div>
            <div class="wind"></div>
            <div class="cloud"></div>
            </div>
   			</div>
    <div style="float : left; margin-top : -40%;">
        <div class="city" style="font-size : 13pt"></div>
        <div class="current_temp" style="font-size : 50pt"></div>
        <div class="weather_description" style="font-size : 20pt"></div>
    </div>
                 
            </div>
        </div>
    </div>
<div class="result"> </div><!-- ajax 이용 결과물 출력하는 곳 -->

<div class="parent">
<a href="#"><img src="../img/top.png" width="5%" height="5%"></a>
<a href="#" onclick="location.href = document.referrer;"><img src="../img/prev.png" width="5%" height="5%"></a>
</div>



</body>
</html>
