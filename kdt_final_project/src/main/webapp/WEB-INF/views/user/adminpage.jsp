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
					<li><a href="#section1">회원리스트</a></li>
					<li><a href="#section2">글 신고리스트</a></li>
					<li><a href="#section3">댓글 신고리스트</a></li>
				</ul>
			</nav>
			<div class="side-menu-form" id="section1">

				<h1>회원리스트</h1>
				<table class="userList-table" border="1">
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
						<c:forEach var="user" items="${userList}">
							<tr>
								<td><a href="#" class="user-id-link">${user.userid}</a></td>
								<td>${user.username}</td>
								<td>${user.nickname}</td>
								<td>${user.phone}</td>
								<td>${user.email}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<!-- 페이징 버튼 -->
				<c:if test="${totalPages > 1}">
					<div class="paging-container">
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
			<!-- 회원 상세 정보 표시 영역 -->
			<div class="user-details" style="display: none;">
				<h2>회원 상세 정보</h2>
				<p>
					이름: <span id="detailUserName"></span>
				</p>
				<p>
					닉네임: <span id="detailnickname"></span>
				</p>
				<p>
					아이디: <span id="detailUserId"></span>
				</p>
				<p>
					비밀번호: <span id="detailuserpw"></span>
				</p>
				<p>
					전화번호: <span id="detailphone"></span>
				</p>
				<p>
					이메일: <span id="detailUserEmail"></span>
				</p>
				<p>
					우편번호: <span id="detailpostcode"></span>
				</p>
				<p>
					상세주소: <span id="detailaddress"></span>
				</p>
				<p>
					상세주소2: <span id="detailaddress2"></span>
				</p>
				<p>
					참고항목: <span id="detailaddress3"></span>
				</p>

				<button id="deleteUserButton">회원 탈퇴</button>
				<button id="backUserList">되돌아가기</button>
			</div>
			
						<div class="side-menu-form" id="section2">
				<h1>글 신고리스트</h1>
				<table class="reportBoardList-table" border="1">
					<thead>
						<tr>
							<th>신고번호</th>
							<th>게시글번호</th>
							<th>신고받은 아이디</th>
							<th>신고자 아이디</th>
							<th>카테고리</th>
							<th>내용</th>
						</tr>
					</thead>
					<tbody id="reportBoardTableBody">
						<c:forEach var="report" items="${reportBoardList}">
							<tr>
								<td>${report.id}</td>
								<td><a href="#" class="reported-Id-link">${report.reportedId}</a></td>
								<td>${report.boardId}</td>
								<td><a href="#" class="userId-Id-link">${report.userId}</a></td>
								<td>${report.reportCategory}</td>
								<td>${report.reportContents}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			
			<div class="side-menu-form" id="section3">
				<h1>댓글 신고리스트</h1>
				<table class="reportList-table" border="1">
					<thead>
						<tr>
							<th>신고번호</th>
							<th>댓글번호</th>
							<th>신고받은 아이디</th>
							<th>신고자 아이디</th>
							<th>카테고리</th>
							<th>내용</th>
						</tr>
					</thead>
					<tbody id="reportTableBody">
						<c:forEach var="report" items="${reportCommentList}">
							<tr>
								<td>${report.id}</td>
								<td><a href="#" class="reported-Id-link">${report.reportedId}</a></td>
								<td>${report.commentId}</td>
								<td><a href="#" class="userId-Id-link">${report.userId}</a></td>
								<td>${report.reportCategory}</td>
								<td>${report.reportContents}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
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
			document.getElementById('backUserList').addEventListener('click',
					function() {
						window.location.reload(true); // 현재 페이지 새로고침
					});
		</script>
</body>
</html>