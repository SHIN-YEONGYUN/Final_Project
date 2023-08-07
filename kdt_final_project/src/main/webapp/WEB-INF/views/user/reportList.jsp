<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.List"%>
<%@ page import="User.UserDAO"%>
<%@ page import="User.UserDAOImpl"%>
<%@ page import="User.UserDTO"%>
<%@ page import="community.BoardDTO"%>

<!DOCTYPE html>
<html>
<link rel="stylesheet" href="/css/user/adminpage.css" />
<!-- <link rel="stylesheet" href="/css/reset.css"> -->
<script defer="defer" src="js/user/adminpage.js"></script>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>

<body>
	<%@ include file="../home/header.jsp"%>

	<div class="container">
		<div class="side-menu">
			<!-- 왼쪽 사이드 메뉴 추가 -->
			<nav class="side-menu-nav">
				<ul>
					<li><a href="adminpage.jsp">전체 회원 리스트</a></li>
					<li><a href="#section1">글 신고리스트</a></li>
					<li><a href="commentReportList.jsp">댓글 신고리스트</a></li>
				</ul>
			</nav>
			<div class="side-menu-form" id="section3">
				<h1>댓글 신고리스트</h1>
				<table class="reportList-table" border="1">
					<thead>
						<tr>
							<th>아이디</th>
							<th>이름</th>
							<th>닉네임</th>
							<th>전화번호</th>
							<th>이메일</th>
						</tr>
					</thead>
					<tbody id="boardTableBody">
						<c:forEach var="report" items="${reportList}">
							<tr>
								<td>${report.commentId}</td>
								<td>${report.userNickname}</td>
								<td>${report.userId}</td>
								<td>${report.reportContents}</td>
								<td>${report.contentId}</td>
								<td>${report.regDate}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<!-- 페이징 버튼 -->
				<c:if test="${totalPages > 1}">
					<div class="paging-container2">
						<c:if test="${currentPage > 1}">
							<a href="?page=1">&lt;&lt;</a>
							<a href="?page=${currentPage - 1}">&lt;</a>
						</c:if>

						<c:forEach var="pageNum" begin="1" end="${totalPages}">
							<c:if test="${pageNum eq currentPage}">
								<strong class="paging-container-start">${pageNum}</strong>
							</c:if>
							<c:if test="${pageNum ne currentPage}">
								<a href="?page=${pageNum}" class="current">${pageNum}</a>
							</c:if>
						</c:forEach>

						<c:if test="${currentPage < totalPages}">
							<a href="?page=${currentPage + 1}">&gt;</a>
							<a href="?page=${totalPages}">&gt;&gt;</a>
						</c:if>
					</div>
				</c:if>

			</div>
		</div>
	</div>

	

	<script>
		function previewProfileImage(event) {
			const file = event.target.files[0];
			const previewImage = document.getElementById('previewImage');

			if (file) {
				const reader = new FileReader();
				reader.onload = function(e) {
					previewImage.src = e.target.result;
				};
				reader.readAsDataURL(file);
			}
		}
		
		// 되돌아가기 버튼 클릭 이벤트 처리
		document.getElementById('backUserList').addEventListener('click', function() {
			window.location.reload(true); // 현재 페이지 새로고침
		});
	</script>

</body>
</html>