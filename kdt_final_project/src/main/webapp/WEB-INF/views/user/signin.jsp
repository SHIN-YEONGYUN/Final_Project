<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<link rel="stylesheet" href="/css/user/login.css" />
<link rel="stylesheet" href="/css/reset.css">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
</head>
<body>
<%@ include file="../home/header.jsp"%>

    <div class="container">
        <h2 class="text-center">회원가입</h2>
        <form id="signupForm" method="post">
        
        <div class="form-group">
                <label for="username"></label>
                <input type="text" class="form-control" id="username" placeholder="이름을 입력하세요" name="username">
            </div>
            
            <div class="form-group">
                <label for="nickname"></label>
                <input type="text" class="form-control" id="nickname" placeholder="닉네임을 입력하세요" name="nickname">
            </div>
            
            <div class="form-group">
                <label for="userid"></label>
                <input type="text" class="form-control" id="userid" placeholder="아이디를 입력하세요" name="userid">
            </div>
            
            <div class="form-group">
                <label for="userpw"></label>
                <input type="password" class="form-control" id="userpw" placeholder="비밀번호를 입력하세요" name="userpw">
            </div>
            
            <div class="form-group">
                <label for="phone"></label>
                <input type="text" class="form-control" id="phone" placeholder="전화번호를 입력하세요" name="phone">
            </div>
            
            <div class="form-group">
                <label for="email"></label>
                <input type="email" class="form-control" id="email" placeholder="이메일을 입력하세요" name="email">
            </div>
            
            <div class="form-group">
				<label for="mbti"></label> <input type="text"
				class="form-control" id="mbti" name="mbti" placeholder="MBTI">
			</div>

            <div class="form-group">
<input type="text" id="postcode" name="postcode" placeholder="우편번호">
<input type="button" id="postcodesearch" name="postcodesearch" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
<input type="text" id="address" name="address" placeholder="주소"><br>
<input type="text" id="detailAddress" name="detailAddress" placeholder="상세주소">
<input type="text" id="extraAddress" name="extraAddress" placeholder="참고항목">
            </div>
						
            <button type="button" class="btn btn-default" id="signupbtn">회원가입</button>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }
</script>
    <script>
    $(document).on('click', '#signupbtn', function() {
  	  
  	  $.ajax({
  	    url: "/signin", 
  	    type: "POST",
  	    data: $("#signupForm").serialize(),
  	    success: function(response) {
  	      console.log("success response:",response);
  	      alert("회원가입이 완료되었습니다.");
  	      window.location.href = "/"; 
  	    },
  	    error: function(jqXHR, textStatus, errorThrown) {
  	      console.log("error response:",jqXHR,textStatus,errorThrown);
  	      alert("회원가입 중 오류가 발생했습니다. 다시 시도해주세요.");
  	    }
  	  });
  	});
    </script>
    


</body>
</html>
