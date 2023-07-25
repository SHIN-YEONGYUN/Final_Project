$(document).ready(function() {

	//js url parameter 가져오기
	let urlParams = new URL(location.href).searchParams;
	let contentId = urlParams.get('contentId');
	
	$('#comments').click(function() {
		$.ajax({
			url: "/travelspot/post/mycomments?contentId="+contentId,
			type: 'get',
			success: function(map) {
				$('div[class="result"]').html(
				`<div class="textarea-outerbox">
				<p class="pstyle">여행지 한줄평</p><br>
				<textarea id="content" class="textarea-innerbox font_comment" style="width: 60vw" rows="4" placeholder="여행지에 대한 한줄평을 남겨주세요"> </textarea>
				<input type="button" class="savebutton" value="저장"></div></div>`);
				$('div[class="result"]').append('<div class="comments"></div>');
				
				getCommentList(); //저장된 댓글 불러오기
				
				$('div[class="result"]').append(`<div style="position:fixed; bottom:3%; right:-10%;">
				<a href="#"><img src="../img/top.png" width="5%" height="5%"></a>`);
				
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
               			     url: "/travelspot/post/mycomments/save",
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
				$('div[class="result"]').append(`<div style="position:fixed; bottom:3%; right:-10%;">
				<a href="#"><img src="../img/top.png" width="5%" height="5%"></a>`);
			},
			error: function() { }
		});
};

function getCommentList(){ //저장한 댓글 가져오기: https://chlee21.tistory.com/156 참고
	$.ajax({
		url: "/travelspot/post/mycomments?contentId="+contentId,
		type: 'get',
		success: function(map){
			$('div[class="comments"]').html('');
			for(var i in map.commentsList){ //map.commentsList[i]= CommentsDTO > map.commentsList[i].userDTO = UserDTO > map.commentsList[i].userDTO.photo = UserDTO의 photo
				/* 프로필 사진 옆 이름, 날짜 버전
				$('div[class="comments"]').append(
					`<div class="comments-outerbox"><div class="comments-innerbox">
					<div class="comments-userinfo">
					<img src="${map.commentsList[i].userDTO.photo}" class="comments-profile">
					<p style="font-weight: bold; display: inline;">&nbsp;${map.commentsList[i].writer}&nbsp;</p><p style="display: inline;"> ${map.commentsList[i].writingtime}</p> `+
					(map.userdto == map.commentsList[i].writer ? 
					`<input class="deletebutton" type="button" value="삭제" id="${map.commentsList[i].id}"><input class="modifybutton" type="button" value="수정" id="${map.commentsList[i].id}"></div>` : '</div>')
					+`<p id="contents">${map.commentsList[i].contents}</p>`);*/
				$('div[class="comments"]').append( 
					`<div class="comments-outerbox"><div class="comments-innerbox">
					<div class="comments-userinfo"><img src="${map.commentsList[i].userDTO.photo}" class="comments-profile"></div>
					<p style="font-weight: bold; display: inline;">&nbsp;${map.commentsList[i].writer}&nbsp;</p><p style="display: inline;"> ${map.commentsList[i].writingtime}</p> `+
					(map.userdto == map.commentsList[i].writer ? 
					`<input class="deletebutton" type="button" value="삭제" id="${map.commentsList[i].id}"><input class="modifybutton" type="button" value="수정" id="${map.commentsList[i].id}">` : '')
					+`<p id="contents">${map.commentsList[i].contents}</p>`);
			}//for 
			
			deleteComment();
			modifyComment();
		}//success
	}); //ajax end
}//getCommentList end

function deleteComment(){ //댓글 삭제 기능
	$('.deletebutton').click(function(){
		if(confirm("댓글을 삭제하시겠습니까?")){
		$.ajax({
			url: "/travelspot/post/mycomments/delete?id="+$(this).attr('id'),
			type: 'get',
			success: function(){
			  getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
			}
		});//ajax end
	}
	});//deletebtn end
}//deleteComment end

function modifyComment(){ //댓글 수정 기능
	$('.modifybutton').click(function(){
		$.ajax({
			url: "/travelspot/post/mycomments/modify?id="+$(this).attr('id'),
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
						url: "/travelspot/post/mycomments/modify_save?id="+$(this).attr('id'),
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
						url: "/travelspot/post/mycomments/modify_cancel?contentId="+contentId,
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


});//ready end