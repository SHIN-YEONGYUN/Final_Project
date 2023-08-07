<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<link rel="icon" href="img/favicon.png">
<link rel="stylesheet" type="text/css" href="/css/reset.css" />
<link rel="stylesheet" type="text/css" href="/css/community.css" />
<link rel="stylesheet" type="text/css" href="/css/searchForm.css" />
<script defer="defer" src="/js/jquery-3.6.4.min.js"></script>
<script defer="defer" src="/js/community.js"></script>
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
			<select name="item" class="select-category"
				style="border-radius: 4px; border: 2px solid #2463D3; margin: 4px; width: 5em; height: 62px; font-size: 16px; text-align: center;">
				<option>지역</option>
				<option>제목</option>
				<option>작성자</option>
			</select> <input type="text" id="search-input" name="searchword"
				class="search-input" placeholder="검색어를 입력하세요"> <input
				type="submit" value="검색" class="search-button">
		</form>

		<!-- 		<form action="">
			<select id="printtype" name="printtype">
				<option value="like">인기순</option>
				<option value="newest">최신순</option>
			</select> 
		</form> -->

		<article id="record" class="on">
			<ol class="topTen">
				<h2>
					'여행기록'의 '${param.item}'카테고리에서 '${param.searchword}' 키워드를 검색한 결과입니다. 
					<%-- 					<p>colname: ${searchmap.colname}</p>
					<p>item: ${searchmap.item}</p>
					<p>colvalue: ${searchmap.colvalue}</p>
					<p>limitindex: ${searchmap.limitindex}</p>
					<p>limitcount: ${searchmap.limitcount}</p>
					<p>searchitem: ${searchmap.searchitem}</p> --%>
				</h2>

			</ol>
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
						<tr>
							<c:if test="${board.board_title == '여행기록'}">

								<td>${board.id}</td>
								<td>${board.place}</td>
								<td><a
									href="${pageContext.request.contextPath}/detail?boardId=${board.id}">${board.title}</a></td>
								<td>${board.writer}</td>
								<td>${board.views}</td>
								<td>${board.likecount}</td>
								<td>${board.writingtime}</td>
							</c:if>
						</tr>
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
					<h2>'추천해주세요'의 '${param.item}'카테고리에서 '${param.searchword}' 키워드를 검색한 결과입니다. </h2>
					<br>
					<br>
					<br>
					<br>
					<br>
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
					<c:forEach items="${boardList}" var="board">
						<c:if test="${board.board_title == '추천해주세요'}">
							<tr>
								<td>${board.id }</td>
								<td>${board.place }</td>
								<td><a
									href="${pageContext.request.contextPath}/detail?boardId=${board.id}">${board.title}</a></td>
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

<%-- 	<%
	HashMap<String, Object> searchmap = (HashMap) request.getAttribute("searchmap");
	String searchitem = (String) searchmap.get("searchitem");
	String searchword = (String) searchmap.get("colvalue");
	int totalBoardCnt = (Integer) request.getAttribute("totalCnt");
	int totalPage = 0;
	if (totalBoardCnt % 9 == 0) {
		totalPage = totalBoardCnt / 9;
	} else {
		totalPage = (totalBoardCnt / 9) + 1;
	}
	%>
	<div class="pages">
		<p style="font-size: 20px; display: inline-block">◀</p>
		<%
		for (int i = 1; i <= totalPage; i++) {
			String stringi = String.valueOf(i);
		%>
		<c:url var="url" value="/community/search">
			<c:param name="item" value="${searchmap['searchitem']}" />
			<c:param name="searchword" value="${searchmap['colvalue']}" />
			<c:param name="page" value="${i}" />
		</c:url>
		<a style="font-size: 20px;" href="<c:out value= "${url}" />"><%=stringi%></a>
		<%
		}
		%>
		<p style="font-size: 20px; display: inline-block;">▶</p>

	</div> --%>

<!-- 스크롤: 위치 수정 필요 -->
	<div style="position: fixed; bottom: 1%; right: 1%;">
		<a href="#"><img src="../img/top.png" width="20px" height="20px"></a>

	</div>


	<!-- footer -->

	<div style="position: fixed; bottom: 1%; right: 1%;">
		<a href="#"><img src="../img/top.png" width="20px" height="20px"></a>
	</div>
</body>
</html>