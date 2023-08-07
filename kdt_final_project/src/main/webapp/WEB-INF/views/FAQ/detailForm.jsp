<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/FAQ/main.css">
<link rel="stylesheet" type="text/css" href="css/FAQ/main2.css">
<!--   <link rel="stylesheet" type = "text/css" href="css/FAQ/reset.css"> -->
</head>
<body>
	<!-- header -->
	<%@ include file="../home/header.jsp"%>

	<main>
		<div class="section-container">

			<div class="left-section">
				<!-- 왼쪽 섹션 -->
				<h2>문의 분류</h2>
				<br>
				<div style="display: flex;">
					<h2 id="showbtn" class="showbtn">FAQ</h2>
					<img id="showbtn_img" class="dropdown-2"
						src="css/FAQ/dropdown-2.png">
				</div>
				<ul id="categories" class="category-list" style="display: none;">
					<li><a href="/FAQ01">일반</a></li>
					<li><a href="/FAQ02">가입 변경/탈퇴</a></li>
					<li><a href="/FAQ03">신고/이용제한</a></li>
					<li><a href="/FAQ04">프로필 관련</a></li>
				</ul>

				<ul class="category-list">
					<li><a href="/selectFAQs">이용 문의</a></li>
				</ul>

				<div id="adminDiv" style="display: none">
					<h2>
						<a href="selectFAQs">이용 문의(관리자) </a>
					</h2>
				</div>
			</div>
			<div class="right-section">
				<!-- 오른쪽 섹션 -->
				<h2>문의글</h2>
				<br>

				<div class="form-group">
					<form action="/updateFAQ" method="post"></form>
					<input type="hidden" name="id" value="${faq.id}" /> <label
						for="board_title">문의 분류</label><br>
					<textarea id="board_title" class="form-control-category"
						name="board_title" readonly>${faq.board_title}</textarea>
				</div>

				<div class="form-group">
					<label for="title">제목</label>
					<textarea class="form-control" id="title" name="title"
						placeholder="제목을 입력하세요" readonly>${faq.title}</textarea>
				</div>
				<div class="form-group">
					<label for="contents">문의 내용</label>
					<textarea class="form-control-textarea" id="contents"
						name="contents" readonly>${faq.contents}</textarea>
				</div>

				<div id="adminDiv2" class="form-group">
					<label for="answer">답변</label>
					<textarea class="form-control-textarea" id="answer" name="answer"
						readonly placeholder="아직 답변을 등록하지 않았습니다.">${faq.answer}</textarea>
				</div>

				<div 
					style="display: flex; float: right;  margin-right:-40px;">
					<div class="form-group-btns">
						<h2>
							<a href="/updateForm?id=${faq.id }" style="font-size: 16px">수정</a>
						</h2>
					</div>
					<div class="form-group-btns">
						<h2 onclick="deleteArticle(${faq.id})">삭제</h2>
					</div>
					<div id="adminDiv3" style="display: none;" class="form-group-btns">
						<h2>
							<a href="/answerForm?id=${faq.id }" style="font-size: 16px">
								답변</a>
						</h2>
					</div>
				</div>

			</div>
		</div>



	</main>

	<!-- top button -->
	<%@ include file="../home/topbutton.jsp"%>

	<!-- footer -->
	



</body>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<script>
	// JavaScript 함수를 통해 게시물 삭제 요청 전송
	function deleteArticle(id) {
		if (confirm("정말로 삭제하시겠습니까?")) {
			// AJAX를 사용하여 서버로 삭제 요청 전송
			$.ajax({
				url : '/deleteArticle',
				method : 'POST',
				data : {
					id : id
				},
				success : function(response) {
					// 성공적으로 삭제됐을 때 처리할 내용
					alert('게시물이 삭제되었습니다.');
					window.location.reload();
					window.location.href = "/selectFAQs";
					// 필요한 경우 삭제 후 추가적인 작업을 수행할 수 있습니다.
				},
				error : function(error) {
					// 삭제 요청 실패 또는 오류 발생 시 처리할 내용
					alert('게시물 삭제에 실패했습니다. 다시 시도해주세요.');
					// 필요한 경우 에러 처리를 위한 추가적인 작업을 수행할 수 있습니다.
				}
			});
		}
	}
</script>


<!--클릭하면 숨겨진 div를 보여주기 -->
<script>
	// 버튼 요소를 선택합니다.
	var showbtn = document.getElementById("showbtn");

	// 숨겨진 div 요소를 선택합니다.
	var categories = document.getElementById("categories");
	var showbtn_img = document.getElementById("showbtn_img");

	// 버튼을 클릭하면 숨겨진 div를 보여줍니다.
	showbtn.addEventListener("click", function() {
		if (categories.style.display === "none") {
			categories.style.display = "block";
			showbtn_img.style.transform = "scaleY(-1)";
		} else {
			categories.style.display = "none";
			showbtn_img.style.transform = "scaleY(1)";
		}
	});

	// div를 클릭하면 다시 숨깁니다.
	categories.addEventListener("click", function() {
		categories.style.display = "none";
		showbtn_img.style.transform = "scaleY(1)";
	});
</script>

<!-- 관리자로 로그인하면 숨겨진 메뉴 나타나기 -->
<script>
// 서버에서 데이터를 가져오는 함수
function fetchFAQListForAdmin() {
    // AJAX를 사용하여 서버에서 데이터를 가져옵니다.
    $.ajax({
        url: '/selectAllFAQsForAdmin',
        method: 'GET',
        success: function(response) {
            // 서버에서 받아온 데이터를 변수에 저장합니다.
            var faqListForAdmin = response;
            // 이후 원하는 작업을 수행합니다.
            processFAQListForAdmin(faqListForAdmin);
        },
        error: function(error) {
            console.error('데이터를 불러오는 데 실패했습니다.');
        }
    });
}

// 반복 처리를 위한 함수를 정의합니다.
function processFAQListForAdmin(faqListForAdmin) {
    for (var i = 0; i < faqListForAdmin.length; i++) {
/*     	var nickname = ${nickname}; */
        var dto = faqListForAdmin[i];

        // dto.writer 값을 사용하여 숨겨진 div 보이기/숨기기 작업을 수행합니다.
        var adminDiv = document.getElementById("adminDiv");
        if (${nickname} = "admin") {
            adminDiv.style.display = "block";
        } else {
            adminDiv.style.display = "none";
        }
        
        var adminDiv3 = document.getElementById("adminDiv3");
        if (${nickname} = "admin") {
            adminDiv3.style.display = "block";
        } else {
            adminDiv3.style.display = "none";
        }
    }
}

// 페이지 로딩이 완료되면 데이터를 불러옵니다.
$(document).ready(function() {
    fetchFAQListForAdmin();
});

</script>
</html>
