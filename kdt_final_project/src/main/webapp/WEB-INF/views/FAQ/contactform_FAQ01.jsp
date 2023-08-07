<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>고객센터</title>

<link rel="stylesheet" type="text/css" href="css/FAQ/main2.css">

</head>
<body>

	<header>
		<%@ include file="../home/header.jsp"%>
	</header>

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

				<!-- 오른쪽 섹션 -->
			<div class="right-section">
				<h2>일반</h2>

				<div class="post-list">
					<div class="post-number">1</div>
					<div class="post-title">다른 기기로 로그인했을 때 로그아웃 기능을 제공하나요?</div>
					<div class="expand-button">
						<img class="dropdown" src="css/FAQ/dropdown.png"
							onclick="toggleContent(1)">
					</div>
					
				</div>
				<div id="content-1" class="expanded-content">

					<p>태블릿에서 '다른 기기와 함께 사용'하여 로그인 한 경우 로그아웃 기능을 제공합니다. “설정 > 개인/보안
						> 로그아웃” 에서 로그아웃할 수 있습니다.</p>
				</div>

				<div class="post-list">
					<div class="post-number">2</div>
					<div class="post-title">위치정보 이용에 동의하지 않으면 어떻게 되나요?</div>
					<div class="expand-button">
						<img class="dropdown" src="css/FAQ/dropdown.png"
							onclick="toggleContent(2)">
					</div>
				</div>
				<div id="content-2" class="expanded-content">

					<p>
						1. 위치정보 이용에 동의하시려면?<br> <br> 위트 가입 시 동의 하시거나, 위트의 위치기반
						서비스를 시작할 때 위치정보 수집 및 이용동의 약관이 보여집니다. 검색결과 중 '지도' 기능을 사용하시거나, 검색결과
						중 현재위치 중심의 결과를 보고자 하실 때 (예. 우리동네 날씨) 위치정보이용동의를 하실 수 있습니다.<br>
						<br> 2. 위치정보 이용 동의를 해제하시려면?<br> <br> 1) '더보기[...]'
						탭에서 우측상단 설정[톱니바퀴 모양의 아이콘 이미지]을 눌러 들어갑니다. 2) '개인/보안 >개인정보 관리' 내에서
						위치정보 이용 동의를 해제하시면 됩니다. 위치정보 이용 동의를 해제하시면 위트는 수집된 위치정보 관련 기록을
						파기합니다.
					</p>
				</div>

				<div class="post-list">
					<div class="post-number">3</div>
					<div class="post-title">최근 검색 기능에 표시된 내용을 삭제하고 더이상 사용하고 싶지
						않아요. 어떻게 하나요?</div>
					<div class="expand-button">
						<img class="dropdown" src="css/FAQ/dropdown.png"
							onclick="toggleContent(3)">
					</div>
				</div>
				<div id="content-3" class="expanded-content">
					<p>
						최근 검색 목록에 노출된 정보는 [X] 버튼을 눌러 삭제할 수 있습니다.<br> <br> 만약 더
						이상 검색한 키워드를 최근 검색 영역에 남기고 싶지 않다면, 최근검색어 목록 우측 상단의 "자동저장끄기" 버튼을 누르면
						최근검색어를 저장하지 않게 됩니다. <br> <br> 최근검색어를 저장하고 싶다면 "자동저장켜기"
						버튼을 누르면 다시 최근 검색 목록을 보실 수 있습니다.
					</p>
				</div>

				<div class="post-list">
					<div class="post-number">4</div>
					<div class="post-title">커뮤니티 탭과 여행지 추천 탭의 검색결과가 왜 다른가요?</div>
					<div class="expand-button">
						<img class="dropdown" src="css/FAQ/dropdown.png"
							onclick="toggleContent(4)">
					</div>
				</div>
				<div id="content-4" class="expanded-content">
					<p>
						위트에서 제공되는 검색 화면은 진입하는 탭마다 고객의 편의를 위해 검색 결과가 다를 수 있습니다. <br> <br>
						여행지 추천 탭의 경우 위트에서 제공하는 콘텐츠를 소비하기 편리하도록 검색 결과를 구성하였습니다. <br> <br>
						커뮤니티탭에서는 페이지 상단의 지역 탭에서 효과적으로 지역별 커뮤니티 검색 결과를 확인하실 수 있습니다.<br>
						<br>
					</p>
				</div>

				<div class="post-list">
					<div class="post-number">5</div>
					<div class="post-title">
						<태블릿>모바일과 다른 언어로 보여요. 
					</div>
					<div class="expand-button">
						<img class="dropdown" src="css/FAQ/dropdown.png"
							onclick="toggleContent(5)">
					</div>
				</div>
				<div id="content-5" class="expanded-content">
					<p>
						안드로이드 태블릿 위트의 언어 설정은, 사용자가 OS에서 설정한 언어 설정을 따라 노출됩니다.<br> <br>
						휴대폰과 안드로이드 태블릿의 언어가 다르게 설정되어 있는 경우 각각 다르게 표시되는 것이 정상입니다.
					</p>
				</div>

			</div>
		</div>
		<script>
			function toggleContent(postNumber) {
				var content = document.getElementById('content-' + postNumber);
				content.classList.toggle('show');
			}
		</script>

	</main>

	<!-- top button -->
	<%@ include file="../home/topbutton.jsp"%>

	<!-- footer -->
	



</body>
<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
        if (dto.writer = "admin") {
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
