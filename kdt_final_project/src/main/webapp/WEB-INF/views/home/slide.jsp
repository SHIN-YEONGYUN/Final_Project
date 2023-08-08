<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Slide</title>
<link rel="stylesheet" href="../css/reset.css">
<link rel="stylesheet" href="../css/home/slide.css">
</head> 
<body>
<div class="section">
	<input type="radio" name="slide" id="slide01" checked>
	<input type="radio" name="slide" id="slide02">
	<input type="radio" name="slide" id="slide03">
	<div class="slide-wrap">
		<ul class="slidelist">
			<li>
				<a class="list">
					<label for="slide02" class="left"></label>
					<div class="textbox">
						<p class="desc">여행의 즐거움,<br>
						행복한 여정을 함께합니다.<p>
						<h3><a href="/travelspot/list">여행지 추천 바로가기</a></h3>
					</div>
					<img src="../img/Mainimg.png"></a>
					<label for="slide02" class="right"></label>
				</a>
			</li>
			<li>
				<a class="list">
					<label for="slide01" class="left"></label>
					<div class="textbox">
						<p class="desc">당신의 경험을 공유하고<br>
						여행지를 추천받으세요.<p>
						<a href="/community"><h3>커뮤니티 바로가기</h3></a>
					</div>
					<img src="../img/Mainimage2.png">
					<label for="slide01" class="right"></label>
				</a>
			</li>
			<!-- <li>
				<a class="list">
					<label for="slide02" class="left"></label>
					<div class="textbox">
						<h3>세번째 슬라이드</h3>
						<p>세번째 슬라이드 입니다.</p>
					</div>
					<img src="./img/slide.jpg">
					<label for="slide01" class="right"></label>
				</a>
			</li> -->
		</ul>
	</div>
</div>
</body>
</html>