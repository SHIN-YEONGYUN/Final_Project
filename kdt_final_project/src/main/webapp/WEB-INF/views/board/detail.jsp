<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<link rel="icon" href="img/favicon.png">
<link rel="stylesheet" type="text/css" href="css/reset.css" />
<link rel="stylesheet" type="text/css" href="css/detail.css" />

<script src="/js/jquery-3.6.4.min.js"></script>
<script src="/js/community/comment.js"></script>


</head>
<body>
<%@ include file="../../views/home/header.jsp"%>
<section>
    <span class="main_color">${board.board_title}</span>
    <span>${board.place}</span>
    <h2>${board.title}</h2>
    <div id="infocontainer">
    	<div class="info">    
    		<div id="profile">
				<img id="profileImage" src="/img/profile/profileimg.png" alt="프로필 사진">
			</div>
    		<span>${board.writer}</span>
    		<span>조회수: ${board.views}</span>
    		<span>좋아요: ${board.likecount}</span>
    		<span>${board.writingtime}</span>
    	</div>
    <div class="buttons">
    	<c:choose>
        	<c:when test="${board.writer eq nickname}">
            	<a href="/update?boardId=${board.id }">수정</a>
            	<a href="/delete?boardId=${board.id }">삭제</a>
            </c:when>
            <c:otherwise>
                <a href="/board/report?id=${board.id}" class="reportbutton" onclick="checkDuplicateReport(${board.id})">신고</a>
            </c:otherwise>
    	</c:choose>
    </div>
    </div>
    <div id="contents">${board.contents} :${like }:${like.like_check }</div>
    <a id="likebtn" class="likebtn" onclick="checkLoginAndHandleLike(${board.id})">like button</a>
    <!-- <c:choose>
    	<c:when test="${like == null || like.like_check == 0}">
    		<a class="likebtn" onclick="checkLoginAndHandleLike(${board.id})">like button</a>
    	</c:when>
    	<c:otherwise>
    		<a class="likebtn likebtn_on" onclick="checkLoginAndHandleLike(${board.id})">like button</a>
    	</c:otherwise>
	</c:choose> -->
    
    <span id="likeCount">${board.likecount}</span><br/>
    <script>
    	/*const likebtn = document.querySelector(".likebtn");
    	likebtn.addEventListener('click',function(){
    		this.classList.toggle("likeon");
    	}); */
    	
    	const boardId = ${board.id};
    	//console.log(boardId);
    	
    	// 좋아요 상태를 확인하고 로그인 상태를 체크하는 함수
        function checkLoginAndHandleLike(boardId) {
            $.ajax({
                url: "/api/getLikeStatus",
                method: "GET",
                data: {"boardId": boardId},
                success: function(response) {
                    if (response.isLoggedIn) {
                        // 로그인 상태인 경우 좋아요 처리 수행
                        
                        toggleLike(boardId);
                        location.reload();
                    } else {
                        // 로그인 상태가 아닌 경우 로그인 페이지로 이동
                        window.location.href = "/login";
                    }
                },
                error: function() {
                    alert("서버와 통신 중 오류가 발생했습니다.");
                }
            });
        }

    	var likestatus = 0;
    	var likeimgurl = "../img/like.png";
        // 좋아요 처리 함수
        function toggleLike(boardId) {
            $.ajax({
                url: "/toggleLike",
                method: "GET",
                data: {"boardId": boardId},
                success: function(response) {
                	if(response.like != null && response.like.like_check != 0){
                		//$("#likebtn").css("background-image", "../img/like_on.png");
                		$("#likebtn").removeClass("likebtn");
                		$("#likebtn").addClass("likeon");
                	}
                    // 성공적으로 처리되었을 때의 로직
                    // 예: 버튼 색 변경, 좋아요 수 갱신 등
    				/* likebtn.addEventListener('click',function(){
    				this.classList.toggle("likeon");
    				}); 
                    const likebtn = document.querySelector(".likebtn");
                    alert(response.likeStatus);
                    if (response.likeStatus == "liked") {
                        alert("좋아요 취소");
                    	document.querySelector(".likebtn").classList.remove("likeon");
                    } else {
                    	alert("좋아요");
                        document.querySelector(".likebtn").classList.add("likeon");
                    }*/
                    $("#likeCount").text(/* "좋아요 수: " +  */response.likeCount);
                    likestatus = response.like.like_check;
                    
                },
                error: function(request, status, err) {
                    alert("서버와 통신 중 오류가 발생했습니다." + err +":" + request.responseText +":"+request.status);
                }
            });            
        }
        
        /* if(likestatus == 0 ){
            likeimgurl = "../img/like.png";
        }else{
        	likeimgurl = "../img/like_on.png";
        }
        const likebtn = document.querySelector(".likebtn");
        likebtn.style.backgroundImage = `${likeimgurl}`; */

    </script>
    
    <!-- 댓글창 추가: 하트 위치 변경 -->
	<!-- <p class="main_color">댓글창</p><br> -->
	<div id="comment-box">
	<textarea id="content" style="resize: none;" rows="4">댓글을 남겨주세요 </textarea><!-- 여백 조정없이 padding 필요 -->
	<input type="text" class="login" value="${nickname }" hidden="hidden">
	<input type="button" class="savebutton" value="저장"><!-- 오른쪽 정렬 -->
	</div>
	<div class="comments"></div>
</section>

<div style="position:fixed; bottom:1%; right:1%;">
<a href="#"><img src="../img/top.png" width="20px" height="20px"></a>
<script>
function fetchProfilePhoto(writer) {
  $.ajax({
    url: '/getUserProfilePhoto', // 프로필 사진을 가져올 컨트롤러 경로
    type: 'GET',
    data: { writer: writer },
    success: function(data) {
      // 성공적으로 데이터를 가져왔을 때 처리하는 부분
      updateProfilePhoto(data);
    },
    error: function() {
      // 데이터를 가져오지 못했을 때 처리하는 부분
      console.error('프로필 사진을 가져오지 못했습니다.');
    }
  });
}

function updateProfilePhoto(photoUrl) {
  // 가져온 URL을 이용하여 이미지 엘리먼트를 업데이트
  const profileImage = document.getElementById('profileImage');
  profileImage.src = photoUrl;
}

// 페이지 로드 시 프로필 사진 가져오기
$(document).ready(function() {
  const writer = '${board.writer}'; // JSP 내의 작성자 변수 사용
  fetchProfilePhoto(writer);
});
</script>
</body>
</html>
