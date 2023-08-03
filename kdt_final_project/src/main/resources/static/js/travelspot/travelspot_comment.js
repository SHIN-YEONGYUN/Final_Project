$(document).ready(function() {

	//js url parameter 가져오기
	let urlParams = new URL(location.href).searchParams;
	let contentId = urlParams.get('contentId');
	
	$('#comments').bind("click",function() {
		$.ajax({
			url: "/travelspot/post/comments?contentId="+contentId,
			type: 'get',
			success: function(map) {
				$('div[class="result"]').html(
				`<div class="textarea-outerbox">
				<p class="pstyle">여행지 한줄평</p><br>
				<textarea id="content" class="textarea-innerbox font_comment" style="width: 60vw" rows="4" placeholder="여행지에 대한 한줄평을 남겨주세요"> </textarea>
				<input type="button" class="savebutton" value="저장"></div></div>`);
				$('div[class="result"]').append('<div class="comments"></div>');
				
				getCommentList(); //저장된 댓글 불러오기
			
				
				$('.savebutton').click(function() {
                	var content = $('#content').val();
                	if(map.userdto == "null"){ //로그인 체크
						alert("로그인 후 사용가능합니다.")
					} else{ //로그인한 회원
                		if (content === '') { //댓글 내용이 빈칸일 경우 체크
          					  alert('댓글 내용을 입력해 주세요.');
          					  return;
      				 	} else{
              			  $.ajax({
               			     url: "/travelspot/post/comments/save",
                  			 type: 'get',
                  			 data: {'contentId': contentId, 'contents': content},
                  			 success: function() {
								   $('#content').val(''); //댓글 등록시 댓글 등록창 초기화
								   getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력
                 		     },
                    	 	error: function() { }
               			 }); //ajax end
               		   };//else end 로그인한 회원 + 댓글내용 빈칸x
               		};//else end
           		 });//savebutton end
           		 
           		 //신고버튼 클릭
           		 
			},
			error: function() { }
		});

	});//comments onclick end

	
function imageAjax(){
	$.ajax({
			url: "/travelspot/post/images?contentId="+contentId,
			type: 'get',
			success: function(placedto) {
				$('div[class="result"]').html('<img class="images" src='+placedto.image1+'>');	
				
			},
			error: function() { }
		});
};

function getCommentList(){ //저장한 댓글 가져오기: https://chlee21.tistory.com/156 참고
	$.ajax({
		url: "/travelspot/post/comments?contentId="+contentId,
		type: 'get',
		success: function(map){
			$('div[class="comments"]').html('');
			for(var i in map.commentsList){ //map.commentsList[i]= CommentsDTO > map.commentsList[i].userDTO = UserDTO > map.commentsList[i].userDTO.photo = UserDTO의 photo
				/* 프로필 사진 옆 이름, 날짜 버전*/
				$('div[class="comments"]').append(
					`<div class="comments-outerbox"><div class="comments-innerbox">
					<div class="comments-userinfo">
					<img src="${map.commentsList[i].userDTO.photo}" class="comments-profile">
					<p style="font-weight: bold; display: inline;">&nbsp;${map.commentsList[i].writer}&nbsp;</p><p style="display: inline;"> ${map.commentsList[i].writingtime}</p> `+
					(map.userdto == map.commentsList[i].writer ? 
					`<input class="deletebutton" type="button" value="삭제" id="${map.commentsList[i].id}"><input class="modifybutton" type="button" value="수정" id="${map.commentsList[i].id}">` : '')
					+((map.userdto == map.commentsList[i].writer)? `</div>`:`<input class="reportbutton" type="button" value="신고" id="${map.commentsList[i].id}"></div>`)
					+`<p id="contents">${map.commentsList[i].contents}</p>`);
				/* 프로필 아래 이름, 날짜 버전
				$('div[class="comments"]').append( 
					`<div class="comments-outerbox"><div class="comments-innerbox">
					<div class="comments-userinfo"><img src="${map.commentsList[i].userDTO.photo}" class="comments-profile"></div>
					<p style="font-weight: bold; display: inline;">&nbsp;${map.commentsList[i].writer}&nbsp;</p><p style="display: inline;"> ${map.commentsList[i].writingtime}</p> `+
					(map.userdto == map.commentsList[i].writer ? 
					`<input class="deletebutton" type="button" value="삭제" id="${map.commentsList[i].id}"><input class="modifybutton" type="button" value="수정" id="${map.commentsList[i].id}">` : '')
					+`<p id="contents">${map.commentsList[i].contents}</p>`);
				*/
			}//for 
			
			deleteComment();
			modifyComment();
			reportComment(map);
		}//success
	}); //ajax end
}//getCommentList end

function deleteComment(){ //댓글 삭제 기능
	$('.deletebutton').click(function(){
		if(confirm("댓글을 삭제하시겠습니까?")){
		$.ajax({
			url: "/travelspot/post/comments/delete?id="+$(this).attr('id'),
			type: 'get',
			success: function(){
			  getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
			}
		});//ajax end
	}
	});//deletebtn end
}//deleteComment end

function reportComment(map){ //댓글 신고 기능
	$('.reportbutton').click(function(){
		let id = $(this).attr('id');
		if(map.userdto=="null"){ //로그인 사용자
		 	alert("댓글 신고기능은 로그인 후 사용가능합니다.");
		} else {
			$.ajax({
				url: "/travelspot/comments_reportcheck?id="+id+"&contentId="+contentId,			
				type: 'post',
				success: function(response){
					if(response=="false"){
						location.href="/travelspot/comments_report?id="+id+"&contentId="+contentId;			
					} else {
						alert("이미 신고한 댓글입니다.");
					}
				}
			});
		}	
	});//reportbutton end
}//reportComment end

function modifyComment(){ //댓글 수정 기능
	$('.modifybutton').click(function(){
		$.ajax({
			url: "/travelspot/post/comments/modify?id="+$(this).attr('id'),
			type: 'get',
			success: function(commentsdto){
			  //수정할 댓글 부분 textarea 생성 > 버튼 2개(취소, 저장)
			  	$('div[class="comments"]').html('');
				$('div[class="comments"]').append(
					`<div class="comments-modify-outerbox"><div class="comments-innerbox">
					 <p style="font-weight: bold; display: inline;">${commentsdto.writer }&nbsp;</p><p style="display: inline;">${commentsdto.writingtime}</p>
					 <input class="modify_cancelbtn" type="button" value="취소" id="`+commentsdto.id+
					 `"</p><input class="modify_savebtn" type="button" value="저장" id="`+commentsdto.id+`"><br><br>
					 <textarea name="contents" class="textarea-innerbox font_comment" style="width: 60.5vw" rows="4">${commentsdto.contents}</textarea>
					 </div></div>`);
				
				//저장버튼 클릭시 이벤트
				$('.modify_savebtn').click(function(){
					var content = $("textarea[name=contents]").val();
					if (content === '') { //댓글 내용이 빈칸일 경우 체크
          				alert('댓글 내용을 입력해 주세요.');
          				return;
          			} else{
					//console.log(content);
					 $.ajax({
						url: "/travelspot/post/comments/modify_save?id="+$(this).attr('id'),
						data: {'contentId': contentId, 'contents': content},
						type: "get",
						success: function(){
					 	  getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
						}
						
					 })//ajax	
					}
				})//modify_savebtn
				
				//취소버튼 클릭시 이벤트
				$('.modify_cancelbtn').click(function(){
					$.ajax({
						url: "/travelspot/post/comments/modify_cancel?contentId="+contentId,
						type: "get",
						success: function(){
							getCommentList();//댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
						}
					})//ajax
				});//modify_cancelbtn
				
			}//success 
						
		});//ajax end
	
	});//modifybutton end
}//modifyComment end

	//마이페이지 댓글창 이동
	var referrer = document.referrer;
	console.log("이전 페이지 URL: "+referrer);
	if(referrer == "/travelspot/list" || referrer == "/travelspot/list_theme"){//기본페이지: 사진모아보기로 설정
		imageAjax(); 
	} else if(referrer == "/mypage") {	//이전페이지가 마이페이지이면 댓글버튼 클릭이벤트 강제 실행
		$("#comments").trigger("click");
	}

});//ready end
