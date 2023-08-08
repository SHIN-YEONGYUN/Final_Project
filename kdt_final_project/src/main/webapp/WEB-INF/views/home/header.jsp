<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/home/header.css">
</head>
<body>
<header>
<script>
	function googleTranslateElementInit() {
		new google.translate.TranslateElement({
			pageLanguage: 'ko',
			includedLanguages: 'ko,en,ja,fr,es,it,zh-CN,zh-TW,pt,de',
			//layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
			autoDisplay: false
		}, 'google_translate_element');
	}
</script>
<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
<div id="body" >
<% 
String login=null;
if((String)session.getAttribute("login")!=null){
	login=(String)session.getAttribute("login");
}
String username=(String)session.getAttribute("username");
int bool=0;
if(username=="admin"){
	bool=1;
}

if (login==null){%>
<div class="name">
<a href="/login" id="headerLoginBtn">로그인</a>
<a href="/signin" id="headerSignupBtn">회원가입</a>
<!-- <a href="/index(Eng)">English</a> -->
</div>
<%}else if (login!=null && bool==0){%>
<div class="name">

<a href="/mypage"><%=username %>님</a>
<a href="/logout" id="headerLoginBtn">로그아웃</a>
<!-- <a href="/signin" id="headerSignupBtn">회원가입</a> -->
<!-- <a href="/index(Eng)">English</a> -->
</div>
<%};%>









<a href="/"><img src=../img/logo.png class="logo" ></a>
<a href="/travelspot/list"><div class="menu" >추천지</div></a>
<a href="/community"><div class="menu" >커뮤니티</div></a>
<%if(login==null) {%>
<a href="/login"><div class="menu" >마이페이지</div></a>
<%}; %>
<%if(login!=null){ %>
<%if(username.equals("관리자")){ %>
<a href="/adminpage"><div class="menu" >관리자페이지</div></a>
<%}; %>
<%if(!username.equals("관리자")){ %>
<a href="/mypage"><div class="menu" >마이페이지</div></a>
<%}; %>
<%}; %>

<a href="/FAQ"><div class="menu" >고객센터</div></a>
<!-- <a href="/FAQ"><div class="menu" >착한가게</div></a> -->
<div id="google_translate_element" class="hd_lang" style="float: right;position: relative;top: -4px;margin-left: 10px;"></div>
</div>
<br><br>
</div>
</header>
</body>

</html>
