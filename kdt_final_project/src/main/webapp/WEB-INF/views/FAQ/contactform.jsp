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
				<form action="/FAQ/submit" method="post"
					enctype="multipart/form-data">
					<!--   
		  <div class = "form-group">
        <label for="email">이메일 주소</label>
       <input type="email" id="email" name="email" class="form-control" placeholder="이메일 주소를 입력하세요" required>
		  </div>
            		  

        <label  for="phone">휴대폰 번호</label>
		  <div class = "form-group-phone">
        <select class = "wrap_select_nation" id="country-code">
          국가번호 옵션 추가
            <option value="+1">+1 (USA)</option>
  <option value="+44">+44 (UK)</option>
  <option value="+82">+82 (South Korea)</option>
  
        </select>

        <div class= "wrap_phone"> 
        <input type="text" class = "form-control-phone" id="phone" name="phone" placeholder="전화번호를 입력하세요" required>
        </div>
      </div> -->

					<div class="form-group">
						<label for="board_title">문의 분류</label><br>
						<div>
							<select id="board_title" class="form-control-category"
								name="board_title">
								<option value="일반">일반</option>
								<option value="가입 변경/탈퇴">가입 변경/탈퇴</option>
								<option value="신고/이용제한">신고/이용제한</option>
								<option value="프로필 관련">프로필 관련</option>
								<option value="기타">기타</option>
							</select>
						</div>
					</div>

					<input type="hidden" id="writer" name="writer" value="${nickname }"
						readonly>

					<div class="form-group">
						<label for="title">제목</label>
						<textarea maxlength="100" class="form-control" id="title"
							name="title" placeholder="제목을 입력하세요(100자 이내)" required></textarea>
					</div>

					<div class="form-group">
						<label for="contents">문의 내용</label>
						<textarea maxlength="4000" class="form-control-textarea"
							id="contents-textarea" name="contents"
							placeholder="내용을 입력하세요(4000자 이내)" required></textarea>
					</div>

			<!-- 		<div>파일 첨부</div>
					<label for="attachment-input" class="custom-file-button"
						id="file-name-display">첨부할 파일을 선택하세요 <input type="file"
						class="form-control-attachment" id="attachment-input"
						name="imageFileName" accept='image/*'>
					</label> -->
					<!-- <span id="file-cancel-button" class="file-cancel-button" style="display: none;">파일 선택 취소</span>
 -->


					<br>
					<button class="submitbtn" type="submit">문의접수</button>
				</form>

			</div>
		</div>
		<script>
			/*     const countryCodeSelect = document.getElementById("country-code");
			 const phoneNumberInput = document.getElementById("phone");

			 countryCodeSelect.addEventListener("change", function () {
			 const selectedCountryCode = countryCodeSelect.value;
			 phoneNumberInput.value = selectedCountryCode;
			 }); */

			/*     파일첨부기능 */
			function displayFileName(input) {
				const fileNameDisplay = document
						.getElementById("attachment-Input");
				const file = input.files[0];
				const fileButton = document.getElementById("attachment-button");

				if (file) {
					fileNameDisplay.textContent = attachment - Input;
					fileButton.textContent = "파일 첨부 완료";
				} else {
					fileNameDisplay.textContent = "";
					fileButton.textContent = "파일 첨부";
				}

			}
		</script>
		<script>
			const textarea = document.getElementById("title");
			const maxLength = parseInt(textarea.getAttribute("maxlength"));

			textarea.addEventListener("input", function() {
				const text = this.value;
				if (text.length > maxLength) {
					alert("글자수는 100자 이내로 제한됩니다.")
				}
			});
		</script>
		<script>
			const textarea = document.getElementById("contents-textarea");
			const maxLength = parseInt(textarea.getAttribute("maxlength"));

			textarea.addEventListener("input", function() {
				const text = this.value;
				if (text.length > maxLength) {
					alert("글자수는 4000자 이내로 제한됩니다.");
				}
			});
		</script>



	</main>

	<!-- top button -->
	<%@ include file="../home/topbutton.jsp"%>

	<!-- footer -->
	



</body>

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
        // dto 객체를 이용하여 필요한 작업을 수행합니다.
        console.log(dto.id);
        console.log(dto.writer);
        console.log(dto.title);
        // dto.writer 값을 사용하여 숨겨진 div 보이기/숨기기 작업을 수행합니다.
        var adminDiv = document.getElementById("adminDiv");
        if (${nickname} = "admin") {
            adminDiv.style.display = "block";
        } else {
            adminDiv.style.display = "none";
        }
    }
}

// 페이지 로딩이 완료되면 데이터를 불러옵니다.
$(document).ready(function() {
    fetchFAQListForAdmin();
});

</script>
</html>
