<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>문의 게시판</title>

<link rel="stylesheet" type="text/css" href="css/FAQ/main2.css">

</head>
<body>
	<header>
		<%@ include file="../home/header.jsp"%>
	</header>
	<div class="section-container">
		<div class="left-section">
			<!-- 왼쪽 섹션 -->
			<div class="categories_left">
				<h2>문의 분류</h2>
			</div>
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
			<ul id="ask" class="category-list">
				<li id="ask"><a href="/selectFAQs">이용 문의</a></li>
			</ul>
			<div style="display: none" id="adminDiv">
				<ul class="category-list">
					<li><a href="/selectFAQs">이용 문의(관리자)</a></li>
				</ul>
			</div>
		</div>
		<div class="right-section">
			<div class="right-section-title">
				<h2>이용 문의</h2>
			</div>
			<div class="tablearea">
				<table id="dataTable">

					<tr class="tr_1st">
						<th id="title" style="width: 90px;">제목</th>
						<th style="width:290px;">내용</th>
						<th style="width:100px">작성시간</th>
						<th style="width:40px;">작성자</th>
						<th>분류</th>
						<th>답변</th>
					</tr>

					<c:forEach items="${boardList}" var="dto">
						<tr>
							<td class="td_title"><a href="/detailForm?id=${dto.id }">${dto.title}</a></td>
							<td class="td_contents"><a href="/detailForm?id=${dto.id }">${dto.contents}</a></td>
							<td class="td_writingtime">${dto.writingtime}</td>
							<td class="td_writer">${dto.writer}</td>
							<td>${dto.board_title}</td>
							<td class="answer" id="answer" style="display:none;">${dto.answer}</td>
							<td class="answerStatus" id="answerStatus">X</td>
							<%-- 							<td><a href="/updateForm?id=${dto.id }">수정</a></td>
							<td onclick="deleteArticle(${dto.id})">삭제</td> --%>

							<%-- <td><c:out value="${dto.imageFileName}"/></td> --%>

						</tr>
					</c:forEach>
				</table>
			</div>


			<div class="faqbtn">

				<a href="/FAQ"><h2>문의 작성</h2></a>

			</div>


		</div>

	</div>

	<!-- top button -->
	<%@ include file="../home/topbutton.jsp"%>

	<!-- footer -->
	

</body>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	function toggleContents() {
		// 해당 행의 "내용" 부분을 가져옴
		var contentRow = event.target.parentElement.nextElementSibling;
		// "내용" 부분을 토글(Toggle)하여 보이거나 숨김
		if (contentRow.style.display === "none") {
			contentRow.style.display = "table-row";
		} else {
			contentRow.style.display = "none";
		}
	}
</script>
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
<script>
const contents = document.getElementById("answer").innerText;

if (contents !== "") {
  document.getElementById("answerStatus").innerText = "O";
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

<!-- writer가 admin이면 관리자 메뉴를 표시 -->
<script>
	document.addEventListener('DOMContentLoaded', function() {
		// ${dto.writer} 값이 'admin'인 경우
	            // id가 "ask"인 li 요소의 글자 변경
	            var askLi = document.getElementById("ask");
		if ("${dto.writer}" == 'admin') {
			// div를 표시합니다.
	            askLi.innerText = "이용문의(관리자)";
		}
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
        	console.log("일반 계정으로 로그인했습니다.")
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
    }
}

// 페이지 로딩이 완료되면 데이터를 불러옵니다.
$(document).ready(function() {
    fetchFAQListForAdmin();
});

</script>

<script>
function updateAnswerStatus() {
	// Get the table element by its ID
  const table = document.getElementById('dataTable');
  
  // Get all the rows of the table, excluding the header row (index 0)
  const rows = table.getElementsByTagName('tr');

  // Loop through each row starting from index 1 (to exclude header row)
  for (let i = 1; i < rows.length; i++) {
    const row = rows[i];
    const answerCell = row.cells[5]; // Index of the cell containing the answer value
	const answerValueCell = row.cells[6]
 
    // Get the value of the answer from the cell
    const answerValue = answerCell.innerText.trim();

    // Check if the answer is not an empty string
    if (answerValue !== "") {
      // Update the content of the cell with 'O'
      answerValueCell.innerText = "O";
    }
  }
}

// Call the function after the page has loaded
window.onload = function() {
  updateAnswerStatus();
};
</script>
</html>
