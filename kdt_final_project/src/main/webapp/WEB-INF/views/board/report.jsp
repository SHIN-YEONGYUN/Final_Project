<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위트</title>
<script src="/js/jquery-3.6.4.min.js"></script>
<link href="/css/travelspot/import.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<%@ include file="../home/header.jsp" %>
<hr style="width: 66vw; margin: 0 auto;">
<div id="report-show">
<div class="font_title">글 신고창<hr><br>
<div class="readonly">작성된 글 번호</div><input type="text" id="boardId" class="readonlyinput" value="${boardId}" readonly><br>
<div class="readonly">글 작성자 닉네임</div><input type="text" id="reportedId" class="readonlyinput" value="${reportedId}" readonly><br>
<div class="readonly">신고자 닉네임</div><input type="text" id="nickname" class="readonlyinput" value="${nickname}" readonly="readonly"><br>
<input type="text" id="userId" value="${userId}" hidden="hidden">
<input type="text" id="boardIdHidden" value="${boardId}" hidden="hidden">
<div class="readonly">신고카테고리</div>
<select id="reportCategory">
 <option value="음란물">음란물</option>
 <option value="과도한 욕설" selected>과도한 욕설</option>
 <option value="광고">광고</option>
 <option value="스팸">스팸</option>
 <option value="사회분위기 저해">사회분위기 저해</option>
</select><br>
<div class="readonly">신고내용</div>
<textarea id="reportContents" class="reportConCon">
관리자가 해당 내용을 참고하여 글 블라인드 여부를 결정할 예정입니다.
어떠한 점이 불편했는지 작성해주시면 감사하겠습니다.
</textarea><br>
<button id="saveButton" type="button" class="savebutton">저장</button>
</div>
</div>

<script>
$(document).ready(function() {
	  // 저장 버튼 클릭 시
	  $("#saveButton").click(function() {
	    // 폼 데이터 생성
	    var formData = {
	      boardId: $("#boardId").val(),
	      reportedId: $("#reportedId").val(),
	      userNickname: $("#nickname").val(),
	      userId: $("#userId").val(),
	      boardIdHidden: $("#boardIdHidden").val(),
	      reportCategory: $("#reportCategory").val(),
	      reportContents: $("#reportContents").val()
	    };
	    
	    console.log(formData);
	    
	    // 서버로 폼 데이터를 전송하는 Ajax 요청
	    $.ajax({
	      url: "/board/report", // 폼의 action 속성에 정의된 URL로 요청
	      type: "POST", // 폼의 method 속성에 정의된 HTTP 메서드로 요청
	      data: formData, // 폼 데이터를 전송
	      success: function(data) {
	        // 서버로부터의 응답이 성공적으로 수신되었을 때 처리하는 로직
	        console.log("글 신고가 성공적으로 처리되었습니다.");
	        console.log(data); // 서버가 응답한 데이터를 출력
	        // 성공적으로 처리되었을 때 추가적인 작업을 수행할 수 있습니다.
	        window.location.href = "/community";
	      },
	      error: function(xhr, status, error) {
	        // 서버로부터의 응답에 오류가 발생했을 때 처리하는 로직
	        console.error("글 신고 처리 중 오류가 발생하였습니다.");
	        console.error(error); // 오류 메시지 출력
	        // 오류 발생 시 사용자에게 알림을 표시하는 등의 처리를 수행할 수 있습니다.
	      }
	    });
	  });
	});
</script>

</body>
</html>
