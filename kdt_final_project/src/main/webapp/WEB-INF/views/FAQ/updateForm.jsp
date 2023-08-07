<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
				<h2>문의글 작성 양식</h2>
				<br>

				<div class="form-group">
					<form action="/updateFAQ" method="post"></form>
					<input type="hidden" name="id" value="${faq.id}" /> <label
						for="board_title">문의 분류</label> <br> <select id="board_title"
						class="form-control-category" name="board_title"
						value="${faq.board_title}">
						<option value="일반">일반</option>
						<option value="가입 변경/탈퇴">가입 변경/탈퇴</option>
						<option value="신고/이용제한">신고/이용제한</option>
						<option value="프로필 관련">프로필 관련</option>
						<option value="기타">기타</option>
					</select>
				</div>

				<div class="form-group">
					<label for="title">제목</label> <input maxlength="100"
						class="form-control" type="text" id="title" name="title"
						placeholder="제목을 입력하세요" value="${faq.title}" required>
				</div>
				<div class="form-group">
					<label for="title">문의 내용</label> 
					<input maxlength="4000"
						class="form-control-textarea" type="text" id="contents"
						name="contents" value="${faq.contents}" placeholder="내용을 입력하세요"
						required>
				</div>

			<!-- 	<div>파일 첨부</div>
				<label for="attachment-input" class="custom-file-button"
					id="file-name-display">첨부할 파일을 선택하세요 <input type="file"
					class="form-control-attachment" id="attachment-input"
					name="imageFileName" accept='image/*'>
				</label> -->

				<div id="adminDiv2" class="form-group" style="display: none;">
					<label for="answer">답변</label> <input class="form-control-textarea"
						type="text" id="answer" name="answer" placeholder="답변할 내용을 입력하세요"
						value="${faq.answer}">
				</div>

				<button type="submit" onclick="updateFAQ()">수정</button>
			</div>
		</div>




	</main>

	<!-- top button -->
	<%@ include file="../home/topbutton.jsp"%>

	<!-- footer -->
	



</body>

<script>
			function updateFAQ() {
			    // 폼 요소의 값들을 JavaScript 변수에 저장합니다.
			    var board_title = document.getElementById("board_title").value;
			    var title = document.getElementById("title").value;
			    var contents = document.getElementById("contents").value;
			    var answer = document.getElementById("answer").value;
			    var id = "${faq.id}"; // JSP 코드로부터 FAQ의 ID를 가져옵니다.

			    // 폼 데이터 객체를 생성합니다.
			    var formData = new FormData();
			    formData.append("id", id);
			    formData.append("board_title", board_title);
			    formData.append("title", title);
			    formData.append("contents", contents);
			    formData.append("answer", answer);
			    // JavaScript 변수의 값들을 서버로 전송하기 위해 fetch API를 사용합니다.
			    fetch("/updateFAQ", {
			        method: "POST",
			        body: formData, // 폼 데이터 객체를 fetch API의 body에 전달합니다.
			    })
			    .then(function(response) {
			        if (response.ok) {
			            // 서버 응답이 성공적으로 처리된 경우, 문의글 목록 페이지로 이동합니다.
			            alert("수정이 완료되었습니다.");
			            window.location.href = "/selectFAQs";
			        } else {
			            // 서버 응답이 실패한 경우에 대한 처리를 여기에 작성합니다.
			            alert("수정에 실패했습니다. 다시 시도해주세요.");
			        }
			    })
			    .catch(function(error) {
			        // 네트워크 오류 등 예외 처리를 여기에 작성합니다.
			        alert("수정에 실패했습니다. 다시 시도해주세요.");
			    });
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
      showbtn_img.style.transform= "scaleY(-1)";
    } else {
      categories.style.display = "none";
      showbtn_img.style.transform= "scaleY(1)";
    }
  });

  // div를 클릭하면 다시 숨깁니다.
  categories.addEventListener("click", function() {
    categories.style.display = "none";
    showbtn_img.style.transform= "scaleY(1)";
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
        // dto 객체를 이용하여 필요한 작업을 수행합니다.
        // dto.writer 값을 사용하여 숨겨진 div 보이기/숨기기 작업을 수행합니다.
        var adminDiv = document.getElementById("adminDiv");
        if (${nickname} = "admin") {
            adminDiv.style.display = "block";
        } else {
            adminDiv.style.display = "none";
        }
        
        var adminDiv2 = document.getElementById("adminDiv2");
        if (${nickname} = "admin") {
            adminDiv2.style.display = "block";
        } else {
            adminDiv2.style.display = "none";
        }
    }
}

// 페이지 로딩이 완료되면 데이터를 불러옵니다.
$(document).ready(function() {
    fetchFAQListForAdmin();
});

</script>


</html>
