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
<link rel="stylesheet" type="text/css" href="css/community.css" />
<link rel="stylesheet" type="text/css" href="css/searchForm.css" />
<script defer="defer" src="js/jquery-3.6.4.min.js"></script>
<script defer="defer" src="js/community.js"></script>
</head>
<body>
<%@ include file="../views/home/header.jsp"%>
<div></div>
<section>
	<ul>
		<li id="recordTap" class="on font_title"><a href="">여행기록</a></li>
		<li id="recommendTap" class="font_title"><a href="">추천해주세요</a></li>
	</ul>
	
		<form action="/community/search" method="get" class="search-form">
			<select name="category" class="select-category" style="border-radius:4px; border: 2px solid #2463D3; margin: 4px; width: 5em; height:62px;  font-size: 16px; text-align:center;">
			    <option>지역</option>
				<option>제목</option>
				<option>작성자</option>
			</select> <input type="text" id="search-input" name="searchword" class="search-input"
				placeholder="검색어를 입력하세요"> <input type="submit" value="검색"
				class="search-button">
		</form>
    
    <form action="">
    	<select id="printtype" name="printtype">
    		<option value="like">인기순</option>
    		<option value="newest">최신순</option>
    	</select>
    </form>
    
    
    
	<article id="record" class="on">
		<%-- <ol class="topTen">
			<c:forEach items="${top10List}" var="board">
				<c:if test="${board.board_title == '여행기록' }">
					<li id="top${board.id}">
						<div class="thumbnail">썸네일 입니다</div>
						<h5 class="title">${board.title}</h5>
						<div class="writerinfo">
							<span class="profile"></span>
							<span class="writer">${board.writer}</span>
						</div>
						<div class="info">
							<span class="views">views ${board.views}</span>
							<span class="likeCount">like ${board.likecount}</span>
							<span class="wirteTime">${board.writingtime}</span>
						</div>
					</li>
				</c:if>
			</c:forEach>
		</ol> --%>
		<table>
			<thead>			
				<tr>
					<th>번호</th>
					<th>지역</th>
					<th>제목</th>
					<th>작성자</th>
					<th>조회수</th>
					<th>공감수</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${boardList}" var="board" varStatus="loop">
				<!-- && !top10Ids.contains(board.id) && loop.index >= 10} <-조건 삭제 -->
    				<c:if test="${board.board_title == '여행기록'}">
        				<tr>
            				<td>${board.id}</td>
            				<td>${board.place}</td>
            				<td><a href="${pageContext.request.contextPath}/detail?boardId=${board.id}">${board.title}</a></td>
            				<td>${board.writer}</td>
            				<td>${board.views}</td>
            				<td>${board.likecount}</td>
            				<td>${board.writingtime}</td>
        				</tr>
    				</c:if>
				</c:forEach>
			</tbody>
		</table>
		<ol class="pageNum">
			<li><a href="">1</a></li>
			<li><a href="">2</a></li>
			<li><a href="">3</a></li>
			<li><a href="">4</a></li>
			<li><a href="">5</a></li>
		</ol>
	</article>
	<article id="recommend">
		<table>
			<thead>			
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>조회수</th>
					<th>공감수</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${boardList }" var="board">
					<c:if test="${board.board_title == '추천해주세요' }">
						<tr>
							<td>${board.id }</td>
							<td>${board.place }</td>
							<td><a href="${pageContext.request.contextPath}/detail?boardId=${board.id}">${board.title}</a></td>
							<td>${board.writer }</td>
							<td>${board.views }</td>
							<td>${board.likecount }</td>
							<td>${board.writingtime }</td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
		<ol class="pageNum">
			<li><a href="">1</a></li>
			<li><a href="">2</a></li>
			<li><a href="">3</a></li>
			<li><a href="">4</a></li>
			<li><a href="">5</a></li>
		</ol>
	</article>
	<a href="/writing" id="writingbtn">글쓰기</a>
</section>

<!-- footer -->

<div style="position:fixed; bottom:1%; right:1%;">
<a href="#"><img src="../img/top.png" width="20px" height="20px"></a>
</div>
</body>
</html>
