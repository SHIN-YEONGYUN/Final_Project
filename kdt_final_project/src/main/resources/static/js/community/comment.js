$(document).ready(function() {

	//js url parameter 가져오기
	let urlParams = new URL(location.href).searchParams;
	let boardId = urlParams.get('boardId');

	getCommentList();
	$('.savebutton').click(function() {
		var content = $('#content').val();
		var logindto = $('.login').val();

		if (logindto == '') { //로그인 체크
			alert("로그인 후 사용가능합니다.")
		} else { //로그인한 회원
			if (content === '') { //댓글 내용이 빈칸일 경우 체크
				alert('댓글 내용을 입력해 주세요.');
				return;
			} else {
				$.ajax({
					url: "/comments/save",
					type: 'get',
					data: { 'boardId': boardId, 'contents': content },
					success: function() {
						$('#content').val(''); //댓글 등록시 댓글 등록창 초기화
						getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력
					},
					error: function() { }
				}); //ajax end
			};//else end 로그인한 회원 + 댓글내용 빈칸x

		}//else end

		//	alert(logindto+"content: "+content);

	});// savebtn


	function getCommentList() { //저장한 댓글 가져오기: https://chlee21.tistory.com/156 참고
		$.ajax({
			url: "/comments/list?boardId=" + boardId,
			type: 'get',
			success: function(map) {
				$('div[class="comments"]').html('');
				for (var i in map.commentsList) { //map.commentsList[i]= CommentsDTO > map.commentsList[i].userDTO = UserDTO > map.commentsList[i].userDTO.photo = UserDTO의 photo
					/* 프로필 사진 옆 이름, 날짜 버전*/
					$('div[class="comments"]').append(
						`<div class="comments-outerbox"><div class="comments-innerbox">
					<div class="comments-userinfo">
					<p style="font-weight: bold; display: inline;">&nbsp;${map.commentsList[i].writer}&nbsp;</p><p style="display: inline;"> ${map.commentsList[i].writingtime}</p> ` +
						(map.userdto == map.commentsList[i].writer ?
							`<input class="deletebutton" type="button" value="삭제" id="${map.commentsList[i].id}">
							<input class="modifybutton" type="button" value="수정" id="${map.commentsList[i].id}">` : '')
						+ ((map.userdto == map.commentsList[i].writer) ? `</div>` : `<input class="reportbutton" type="button" value="신고" id="${map.commentsList[i].id}"></div>`)
						+ `<p id="comment_contents" >${map.commentsList[i].contents}</p>`);

				}//for 

				deleteComment();
				modifyComment();
				reportComment(map);
			}//success
		}); //ajax end
	}//getCommentList end


	function deleteComment() { //댓글 삭제 기능
		$('.deletebutton').click(function() {
			if (confirm("댓글을 삭제하시겠습니까?")) {
				$.ajax({
					url: "/comments/delete?id=" + $(this).attr('id'),
					type: 'get',
					success: function() {
						getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
					}
				});//ajax end
			}
		});//deletebtn end
	}//deleteComment end

	function modifyComment() { //댓글 수정 기능
		$('.modifybutton').click(function() {
			$.ajax({
				url: "/comments/modify?id=" + $(this).attr('id'),
				type: 'get',
				success: function(commentsdto) {
					//수정할 댓글 부분 textarea 생성 > 버튼 2개(취소, 저장)
					$('div[class="comments"]').html('');
					$('div[class="comments"]').append(
						`<div class="comments-modify-outerbox"><div class="comments-innerbox">
					 <p style="font-weight: bold; display: inline;">${commentsdto.writer}&nbsp;</p><p style="display: inline;">${commentsdto.writingtime}</p>
					 <input class="modify_cancelbtn" type="button" value="취소" id="`+ commentsdto.id +`"</p><input class="modify_savebtn" type="button" value="저장" id="` + commentsdto.id + `"><br><br>
					 <textarea name="contents" class="textarea-innerbox font_comment" style="width: 60.5vw" rows="4">${commentsdto.contents}</textarea>
					 </div></div>`);

					//저장버튼 클릭시 이벤트
					$('.modify_savebtn').click(function() {
						var content = $("textarea[name=contents]").val();
						if (content === '') { //댓글 내용이 빈칸일 경우 체크
							alert('댓글 내용을 입력해 주세요.');
							return;
						} else {
							//console.log(content);
							$.ajax({
								url: "/comments/modify_save?id=" + $(this).attr('id'),
								data: { 'id': $(this).attr('id'), 'contents': content },
								type: "get",
								success: function() {
									getCommentList(); //댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
								}

							})//ajax	
						}
					})//modify_savebtn

					//취소버튼 클릭시 이벤트
					
					$('.modify_cancelbtn').click(function() {
						$.ajax({
							url: "/comments/modify_cancel?id=" + $(this).attr('id'),
							type: "get",
							success: function() {
								getCommentList();//댓글 등록 후 새로운 댓글 포함된 댓글리스트 가져와서 출력	
							}
						})//ajax
					});//modify_cancelbtn

				}//success 

			});//ajax end

		});//modifybutton end
	} //modifyComment end


function reportComment(map){ //댓글 신고 기능
	$('.reportbutton').click(function(){
		let id = $(this).attr('id');
		if(map.userdto=="null"){ //로그인 사용자
		 	alert("댓글 신고기능은 로그인 후 사용가능합니다.");
		} else {
			$.ajax({
				url: "/comments/reportcheck?id="+id+"&boardId="+boardId,			
				type: 'post',
				success: function(response){
					if(response=="false"){
						location.href="/comments/report?id="+id+"&boardId="+boardId;			
					} else {
						alert("이미 신고한 댓글입니다.");
					}
				}
			});
		}	
	});//reportbutton end
}//reportComment end

});//ready end
