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
<link rel="stylesheet" href="/css/user/mypage.css" />
<!-- <link rel="stylesheet" href="/css/reset.css"> -->
<script defer="defer" src="js/user/mypage.js"></script>
<head>
<meta charset="UTF-8">
<title>회원정보 조회 및 수정 페이지</title>
</head>

<body>
	<%@ include file="../home/header.jsp"%>

	<div class="container">
		<div class="side-menu">
			<!-- 왼쪽 사이드 메뉴 추가 -->
			<nav class="side-menu-nav">
				<ul>
					<li><a href="#section1">회원 정보 수정</a></li>
					<li><a href="#section2">글쓴 내역</a></li>
					<li><a href="#section3">댓글 쓴 내역</a></li>
					<li><a href="#section5">찜한 여행지</a></li>
					<li><a href="#section7">회원 탈퇴</a></li>
				</ul>
			</nav>
			<div class="side-menu-form" id="section1">

				<h1>회원 정보 조회 및 수정</h1>

				<form action="updateUser" method="post"
					enctype="multipart/form-data">
					<!-- 회원 번호는 숨겨진 필드 -->
					<input type="hidden" name="id" id="id" value="${user.id}">
					<!-- 이미지 출력 -->
					<c:choose>
						<c:when test="${not empty user.photo}">
							<img class="profile-image" id="previewImage"
								src="${user.photo}?timestamp=${timestamp}" alt="프로필 이미지">
						</c:when>
						<c:otherwise>
							<img class="profile-image" id="previewImage"
								src="/img/profile/profileimg.png" alt="프로필 이미지">
						</c:otherwise>
					</c:choose>

					<!-- 프로필 이미지 업로드를 위한 input 태그 -->
					<label for="profileImage">프로필 이미지</label> <input type="file"
						name="profileImage" id="profileImage"
						onchange="previewProfileImage(event)" value="${user.photo}">




					<!-- 회원 정보 필드 -->
					<label for="username">이름</label> <input type="text" name="username"
						id="username" value="${user.username}"> <label
						for="nickname">닉네임</label> <input type="text" name="nickname"
						id="nickname" value="${user.nickname}"> <label
						for="userid">아이디</label> <input type="text" name="userid"
						id="userid" readonly value="${user.userid}"> <label
						for="userpw">비밀번호</label> <input type="password" name="userpw"
						id="userpw" value="${user.userpw}"> <label for="phone">전화번호</label>
					<input type="text" name="phone" id="phone" value="${user.phone}">

					<label for="email">이메일</label> <input type="text" name="email"
						id="email" value="${user.email}"> <label for="mbti">MBTI</label>
					<input type="text" name="mbti" id="mbti" value="${user.mbti}">

					<label for="postcode">우편번호</label> <input type="text"
						name="postcode" id="postcode" readonly value="${user.postcode}">
					<input type="button" id="postcodesearch" name="postcodesearch"
						onclick="execDaumPostcode()" value="우편번호 찾기"> <label
						for="address">상세주소</label> <input type="text" name="address"
						id="address" readonly value="${user.address}"> <label
						for="detailAddress">상세주소2</label> <input type="text"
						name="detailAddress" id="detailAddress"
						value="${user.detailAddress}"> <label for="extraAddress">참고항목</label>
					<input type="text" name="extraAddress" id="extraAddress" readonly
						value="${user.extraAddress}"> <input type="submit"
						value="회원 정보 수정">
				</form>
			</div>
			<!-- 글쓴 내역 -->
			<div class="side-menu-form" id="section2" style="display: none;">
				<h1>글쓴 내역</h1>
				<table class="board-table" border="1">
					<thead>
						<tr>
							<th>제목</th>
							<th>게시판</th>
							<th>장소</th>
							<th>작성자</th>
							<th>조회수</th>
							<th>좋아요</th>
							<th>작성 시간</th>
						</tr>
					</thead>
					<tbody id="boardTableBody">
						<c:forEach var="board" items="${boardList}">
							<tr>
								<td>${board.title}</td>
								<td>${board.board_title},${board.categories}</td>
								<td>${board.place}</td>
								<td>${board.writer}</td>
								<td>${board.views}</td>
								<td>${board.likecount}</td>
								<td>${board.writingtime}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
</div>

			<!-- 댓글쓴 내역 -->
			<div class="side-menu-form" id="section3" style="display: none;">
				<h1>댓글 쓴 내역</h1>
				<table class="comments-table" border="1">
					<thead>
						<tr>
							<th>댓글 내용</th>
							<th>작성자</th>
							<th>작성 시간</th>
							<th>장소ID</th>
						</tr>
					</thead>
					<tbody id="commentsTableBody">
						<c:forEach var="comments" items="${commentsList}">
							<tr>
								<td><a href=''>${comments.contents}</a></td>
								<td>${comments.writer}</td>
								<td>${comments.writingtime}</td>
								<td>${comments.place_id}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<!-- 찜한 여행지 -->
			<div class="side-menu-form" id="section5" style="display: none;">
				<h1>찜한 여행지</h1>
				<table class="likes-table" border="1">
					<thead>
						<tr>
							<th>제목</th>
							<th>주소</th>
							<th>조회수</th>
							<th>총 찜</th>
						</tr>
					</thead>
					<tbody id="likesTableBody">
						<c:forEach var="likes" items="${likesList}">
							<tr>
								<td><a href=''>${likes.placeDTO.title}</a></td>
								<td>${likes.placeDTO.address}</td>
								<td>${likes.placeDTO.viewcnt}</td>
								<td>${likes.placeDTO.likecnt}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<!-- 회원 탈퇴 -->
			<div class="side-menu-form withdraw-section" id="section7"
				style="display: none;">
				<h1>회원 탈퇴</h1>
				<p class="red-text">
					회원 탈퇴 시에 작성했던 게시글 및 댓글과 같은 내역들이 모두 삭제됩니다.<br> <span>회원
						탈퇴</span>를 하시겠습니까?
				</p>

				<!--  회원 탈퇴 -->
				<form action="withdrawUser" method="post">
					<input type="submit" value="회원 탈퇴">
				</form>

			</div>
		</div>
	</div>

	<%@ include file="../home/footer.jsp"%>
	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		function execDaumPostcode() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

							// 각 주소의 노출 규칙에 따라 주소를 조합한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							var addr = ''; // 주소 변수
							var extraAddr = ''; // 참고항목 변수

							//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
							if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
								addr = data.roadAddress;
							} else { // 사용자가 지번 주소를 선택했을 경우(J)
								addr = data.jibunAddress;
							}

							// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
							if (data.userSelectedType === 'R') {
								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if (data.bname !== ''
										&& /[동|로|가]$/g.test(data.bname)) {
									extraAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if (data.buildingName !== ''
										&& data.apartment === 'Y') {
									extraAddr += (extraAddr !== '' ? ', '
											+ data.buildingName
											: data.buildingName);
								}
								// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
								if (extraAddr !== '') {
									extraAddr = ' (' + extraAddr + ')';
								}
								// 조합된 참고항목을 해당 필드에 넣는다.
								document.getElementById("extraAddress").value = extraAddr;

							} else {
								document.getElementById("extraAddress").value = '';
							}

							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							document.getElementById('postcode').value = data.zonecode;
							document.getElementById("address").value = addr;
							// 커서를 상세주소 필드로 이동한다.
							document.getElementById("detailAddress").focus();
						}
					}).open();
		}
	</script>
	
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
	</script>
	
</body>
</html>
