$(document).ready(function() {

	//js url parameter 가져오기
	let urlParams = new URL(location.href).searchParams;
	let contentId = urlParams.get('contentId');
	
	imageAjax(); //기본페이지: 사진모아보기로 설정

	$('#comments').click(function() {
		$.ajax({
			url: "/travelspot/post/comments?contentId="+contentId,
			type: 'get',
			success: function(map) {
				$('#comments').css("color", "#2463d3");
				$('div[class="result"]').html(
				`<div class="textarea-outerbox">
				<p class="font_content">여행지 한줄평💭</p><br>
				<textarea id="content" class="textarea-innerbox font_comment" cols="110" rows="4" placeholder="여행지에 대한 한줄평을 남겨주세요"> </textarea>`+
				(map.userdto != "null"? '<input type="button" class="savebutton" value="저장">': '')
				+`</div></div>`);
				$('div[class="result"]').append('<div class="comments"></div>');
				
				getCommentList(); //저장된 댓글 불러오기
				
				$('div[class="result"]').append(`<div style="position:fixed; bottom:3%; right:-10%;">
				<a href="#"><img src="../img/top.png" width="5%" height="5%"></a>`);
				
				$('.savebutton').click(function() {
                	var content = $('#content').val();
                	//댓글 내용이 빈칸일 경우 체크 필요
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
				$('#images').css("color", "#2463d3");
				$('div[class="result"]').html('<img class="images" src='+placedto.image1+'>');	
				$('div[class="result"]').append(`<div style="position:fixed; bottom:3%; right:-10%;">
				<a href="#"><img src="../img/top.png" width="5%" height="5%"></a>`);
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
			for(var i in map.commentsList){
				$('div[class="comments"]').append(
					`<div class="comments-outerbox"><div class="comments-innerbox"><p>`+map.commentsList[i].contents +'</p>'+
					'<p>닉네임 '+map.commentsList[i].writer+'</p><p>작성일자 '+map.commentsList[i].writingtime+
					(map.userdto == map.commentsList[i].writer ? '</p><input class="deletebutton" type="button" value="삭제" id="'+map.commentsList[i].id+'"><input class="modifybutton" type="button" value="수정"  id="'+map.commentsList[i].id+'">' : '')
					+`</div></div>`);
			}//for 
			
			deleteComment();
			modifyComment();
		}//success
	}); //ajax end
}//getCommentList end

function deleteComment(){ //댓글 삭제 기능
	$('.deletebutton').click(function(){
		$.ajax({
			url: "/travelspot/post/comments/delete?id="+$(this).attr('id'),
			type: 'get',
			success: function(){
			  getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
			}
		});//ajax end
	
	});//deletebtn end
}//deleteComment end

function modifyComment(){ //댓글 수정 기능
	$('.modifybutton').click(function(){
		$.ajax({
			url: "/travelspot/post/comments/modify?id="+$(this).attr('id'),
			type: 'get',
			success: function(commentsdto){
			  //수정할 댓글 부분 textarea 생성 > 버튼 2개(취소, 저장)
			  	$('div[class="comments"]').html('');
				$('div[class="comments"]').append(
					`<div class="comments-outerbox"><div class="comments-innerbox"><input type="textarea" id="content_modify" class="textarea-innerbox font_comment" cols="110" rows="4" placeholder="`+commentsdto.contents +`">		
					<p>닉네임 `+commentsdto.writer+`</p><p>작성일자 `+commentsdto.writingtime+
					`</p><input class="modify_savebtn" type="button" value="저장" id="`+commentsdto.id+`"><input class="modify_cancelbtn" type="button" value="취소" id="`+commentsdto.id
					+`"></div></div>`);
				
				//저장버튼 클릭시 이벤트
				$('.modify_savebtn').click(function(){
					var content = $('#content_modify').val();
					console.log(content);
					$.ajax({
						url: "/travelspot/post/comments/modify_save?id="+$(this).attr('id'),
						data: {'contentId': contentId, 'contents': content},
						type: "get",
						success: function(){
					 	  getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
						}
						
					})//ajax	
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


});//ready end
