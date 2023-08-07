<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<script src="/js/jquery-3.6.4.min.js"></script>

<link href="/css/travelspot/import.css" rel="stylesheet" type="text/css" />
<script
	src="/js/travelspot/travelspot_list_theme.js"></script>

</head>
<body>
	<%@ include file="../home/header.jsp"%>

	<%
	String[] themes = new String[] { "alone", "couple", "friends", "family" };
	String[] themeName = new String[] { "#혼자여행", "#힐링여행", "#캠핑여행", "#가족여행" };
	%>

	<!-- 6개씩 배치-->
	<div class="themeContainer">
		<%
		for (int i = 0; i < themes.length; i++) {
		%>
		<div class="themeItem-list">
			<a href="list_theme?theme=<%=themes[i]%>&page=1"
				class="font_title themeName" id=<%=themes[i]%>><%=themeName[i]%></a>
		</div>
		<%
		}
		%>
	</div>
	<br>

	<!-- 검색창 -->
	<form action="/travelspot/themesearch" method="get" class="search-form">
		<select name="item" class="search-item">
			<option value="none" disabled>검색카테고리</option>
			<option value="title">장소명</option>
			<option value="address">주소</option>
		</select> <input type="text" id="search-input" name="searchword"
			class="search-input" placeholder="검색어를 입력하세요"> <input
			type="submit" value="검색" class="search-button">
	</form>

	<div class="container">
		<c:forEach items="${placelist }" var="placeDTO">
			<div class="item">
				<!-- style="border: 0.3px solid #2463d3" -->
				<img class="placeprofile" src=${placeDTO.image1} id=${placeDTO.contentId}>
				<p class="placeName font_title" id=${placeDTO.contentId}>${placeDTO.title}</p>
				<h1 class="placeLocation font_content" id=${placeDTO.contentId}></h1>
				<p>${placeDTO.address}</p>
				<br>
				<p style="display: inline; float: left;">조회수 ${placeDTO.viewcnt }</p>
				<p style="display: inline; float: right;">좋아요 ${placeDTO.likecnt }</p>
				<br>
			</div>
		</c:forEach>
	</div>

	<%
	int totalCnt = (Integer) request.getAttribute("totalCnt");
	String theme = String.valueOf(request.getAttribute("theme"));
	int currentPage = (Integer) request.getAttribute("page"); //현재 페이지 번호
	int countPage = 10; //한 화면에 출력될 페이지 수
	int countList = 9; //한 화면에 출력될 게시물 수

	int totalPage = totalCnt / countList; //총 페이지수
	if (totalCnt % countList > 0) {//게시물수가 한 화면에 출력될 게시물수로 나누어 떨어지지 않으면 페이지 수 추가
		totalPage++;
	}

	int totalBlock = (int) (Math.ceil((double) totalPage / countPage));//총블럭 갯수: 2
	int currentBlock = (int) (Math.ceil((double) currentPage / countPage)); //현블럭: 1 2

	int startPage = (currentBlock - 1) * countPage + 1; //시작페이지 무조건 1,11...
	int endPage = currentBlock * countPage; //마지막페이지 무조건 10,20...
	if (endPage > totalPage) { //마지막페이지 보정
		endPage = totalPage;
	}
	%>

	<div class="paging">
		<%
		if ((currentBlock - 1) * countPage != 0) {
		%>
		<a
			href="list_theme?theme=<%=theme%>&page=<%=(currentBlock - 1) * countPage%>">
			<font size="3px">이전</font>
		</a>
		<%
		}
		for (int i = startPage; i <= endPage; i++) {
		%>
		<a href="list_theme?theme=<%=theme%>&page=<%=i%>"><font size="3px"><%=i%></font>
			&nbsp;&nbsp;</a>
		<%
		}
		if (endPage != totalPage) {
		%>
		<a
			href="list_theme?theme=<%=theme%>&page=<%=currentBlock * countPage + 1%>">
			<font size="3px">다음</font>
		</a>
	</div>
	<%
	}
	%>


	<!-- 스크롤: 위치 수정 필요 -->
	<div style="position: fixed; bottom: 3%; right: 10%;">
		<a href="#"><img src="../img/top.png" width="20px" height="20px"></a>
	</div>
	
</body>

</html>
