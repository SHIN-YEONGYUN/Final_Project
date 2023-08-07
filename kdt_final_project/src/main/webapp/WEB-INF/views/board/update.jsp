<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<link rel="icon" href="img/favicon.png">
<link rel="stylesheet" type="text/css" href="css/reset.css" />
<link rel="stylesheet" type="text/css" href="css/writing.css" />
<script src = "ckeditor/ckeditor.js"></script>
</head>
<body>
<%@ include file="../../views/home/header.jsp"%>
<section>
    <form action="/update" method="POST">
    <input type="hidden" name="id" value="${board.id}" />
    <select id="board_title" name="board_title">
    	<option value="none" selected disabled>===== 게시판 선택 =====</option>
    	<option value="여행기록" ${board.board_title == '여행기록' ? 'selected' : ''}>여행기록</option>
    	<option value="추천해주세요" ${board.board_title == '추천해주세요' ? 'selected' : ''}>추천해주세요</option>
    </select>
    <select id="place" name="place">
    	<option value="none" selected disabled>===== 지역 선택 =====</option>
    	<option value="인천" ${board.place == '인천' ? 'selected' : ''}>인천</option>
    	<option value="광주" ${board.place == '광주' ? 'selected' : ''}>광주</option>
    	<option value="부산" ${board.place == '부산' ? 'selected' : ''}>부산</option>
    	<option value="울산" ${board.place == '울산' ? 'selected' : ''}>울산</option>
    	<option value="강원" ${board.place == '강원' ? 'selected' : ''}>강원</option>
    	<option value="경기도" ${board.place == '경기도' ? 'selected' : ''}>경기도</option>
    </select>
    <input type=text id="hashtag" name="hashtag" placeholder="#해시태그">
    <input type="hidden" id="writer" name="writer" value="${nickname }" readonly><br>
    <input type=text id="title" name=title value="${board.title}"/>
    <br/>
    <textarea id = "contents" name = "contents" >${board.contents}</textarea>
	<script>
		CKEDITOR.replace('contents',{filebrowserUploadUrl:'/mine/imageUpload.do'});
	</script>
    <input type="submit" value="수정완료" id="submit" />
    </form>
</section>

<div style="position:fixed; bottom:1%; right:1%;">
<a href="#"><img src="../img/top.png" width="20px" height="20px"></a>
</div>
</body>
</html>