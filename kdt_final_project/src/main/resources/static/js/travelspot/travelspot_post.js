$(document).ready(function() {

	//js url parameter 가져오기
	let urlParams = new URL(location.href).searchParams;
	let contentId = urlParams.get('contentId');

	$('#images').click(function() {
		imageAjax();
	});//image onclick end

	$('#info').click(function() {
		infoAjax();
	});
	//image onclick end

	//공유 기능
	$("#share").click(function() {
		clip();
	})

	//좋아요 클릭
	$("#like").click(function() {
		if (document.getElementById('like_id').value == "null") {
			alert("찜하기 기능은 로그인 후 사용가능합니다.")
		} else {
			$.ajax({
				url: "/travelspot/post/likes?contentId=" + contentId,
				type: 'get',
				success: function(response) {
					if ($.trim(response) == "success") {
						alert("해당 관광지에 좋아요를 누르셨습니다.");
					} else if ($.trim(response) == "alreadyliked") {
						//취소
						if (confirm("좋아요를 취소하시겠습니까?")) {
							$.ajax({
								url: "/travelspot/post/cancelLikes?contentId=" + contentId,
								type: 'get',
								success: function(response) {
									if ($.trim(response) == "success") {
										alert("정상적으로 취소되었습니다.");
									}
								}
							})
						}
					}

				},//success
				error: function() { }

			})//ajax
		}
	});
	function imageAjax() {
		$.ajax({
			url: "/travelspot/post/images?contentId=" + contentId,
			type: 'get',
			success: function(placedto) {
				$('div[class="result"]').html('<img class="images" src=' + placedto.image1 + '>');
				
			},
			error: function() { }
		});
	};

	function infoAjax() {
		$.ajax({
			url: "/travelspot/post/info?contentId=" + contentId,
			type: 'get',
			success: function(placeDTO) {
				//지도 
				$('div[class="result"]').html('<div id="map" style="width:100%; height:400px;"></div><br>');

				var mapx = placeDTO.mapx; //위도
				var mapy = placeDTO.mapy; //경도
				
				var title = placeDTO.title;
				//위도, 경도 이용해서 날씨 아이콘 띄우기
				var latitude = mapy;//위도
    			var longitude = mapx;//경도
   
    			var apiURI = "http://api.openweathermap.org/data/2.5/weather?lat="+latitude+"&lon="+longitude+"&appid="+"487c6b16cacfbb98c9f1f5b9790f3b71";
				$.ajax({
        		url: apiURI,
        		dataType: "json",
        		type: "GET",
        		async: "false",
        	success: function(resp) {
        	 console.log("날씨 이미지 : "+ resp.weather[0].icon );
        	var weatherIcon = {
        		    '01' : 'fas fa-sun',
        		    '02' : 'fas fa-cloud-sun',
        		    '03' : 'fas fa-cloud',
        		    '04' : 'fas fa-cloud-meatball',
        		    '09' : 'fas fa-cloud-sun-rain',
        		    '10' : 'fas fa-cloud-showers-heavy',
        		    '11' : 'fas fa-poo-storm',
        		    '13' : 'far fa-snowflake',
        		    '50' : 'fas fa-smog'
        		};
            
            var imgURL = "https://openweathermap.org/img/w/" + resp.weather[0].icon + ".png";
            $("html컴포넌트").attr("src", imgURL);
            var $Icon = (resp.weather[0].icon).substr(0,2);
            var $Icon = (imgURL);
            var $weather_description = resp.weather[0].main;
            var $Temp = Math.floor(resp.main.temp- 273.15) + 'º';
            var $humidity = '습도&nbsp;&nbsp;&nbsp;&nbsp;' + resp.main.humidity+ ' %';
            var $wind = '바람&nbsp;&nbsp;&nbsp;&nbsp;' +resp.wind.speed + ' m/s';
            var $city = '현위치&nbsp;&nbsp;'+resp.name;
            var $cloud = '구름&nbsp;&nbsp;&nbsp;&nbsp;' + resp.clouds.all +"%";
            var $temp_min = '최저 온도&nbsp;&nbsp;&nbsp;&nbsp;' + Math.floor(resp.main.temp_min- 273.15) + 'º';
            var $temp_max = '최고 온도&nbsp;&nbsp;&nbsp;&nbsp;' + Math.floor(resp.main.temp_max- 273.15) + 'º';
            
			
            $('.weather_icon').append('<i class="' + weatherIcon[$Icon] +' fa-5x" style="height : 150px; width : 150px;"></i>');
            $('.weather_description').prepend($weather_description);
            $('.current_temp').html($Temp);
            $('.humidity').prepend($humidity);
            $('.wind').prepend($wind);
            $('.city').html($city);
            $('.cloud').append($cloud);
            $('.temp_min').append($temp_min);
            $('.temp_max').append($temp_max);
            
            document.getElementById("imgsrc").src="https://openweathermap.org/img/w/" + resp.weather[0].icon + ".png";
            document.getElementById("imgsrcd").src="https://openweathermap.org/img/w/" + resp.weather[0].icon + ".png";
            	
            
        }
   
    });
				
				
				
				
				//$('div[class="weather"]').html(mapx);

				//마커 표시
				var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
					mapOption = {
						center: new kakao.maps.LatLng(mapy, mapx), // 지도의 중심좌표
						level: 3 // 지도의 확대 레벨
					};

				var map = new kakao.maps.Map(mapContainer, mapOption);

				// 마커가 표시될 위치입니다 
				var markerPosition = new kakao.maps.LatLng(mapy, mapx);

				// 마커를 생성합니다
				var marker = new kakao.maps.Marker({ position: markerPosition });

				// 마커가 지도 위에 표시되도록 설정합니다
				marker.setMap(map);

				var iwContent = `<div style="padding:5px; width:max-content; height:fit-content;">` + placeDTO.title +
					`<br><a href="https://map.kakao.com/link/map/` + title + `,` + mapy + `,` + mapx + `" style="color:blue" target="_blank">큰지도보기</a> 
				<a href="https://map.kakao.com/link/to/`+ title + `,` + mapy + `,` + mapx + `"style="color:blue" target="_blank">길찾기</a></div>`;
				iwPosition = new kakao.maps.LatLng(mapy, mapx); //인포윈도우 표시 위치입니다

				// 인포윈도우를 생성합니다
				var infowindow = new kakao.maps.InfoWindow({
					position: iwPosition,
					content: iwContent
				});

				// 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
				infowindow.open(map, marker);


				// 기본상세정보
				if (placeDTO.contents != null) {
					$('div[class="result"]').append('<p class="pstyle">관광지 설명<br><hr class="hrdetail"><br>' + placeDTO.contents + '<br><br>');
				}
				if (placeDTO.homepage != 'null') {
					$('div[class="result"]').append('<p class="pstyle">관광지 대표 홈페이지<br><hr class="hrdetail"><br>' + placeDTO.homepage + '<br><br>');
				}

				
			},
			error: function() { }
		});
	};

	//메뉴 클릭시 색상 변경
	var font_content = document.getElementsByClassName("font_content");

	function handleClick(event) {
		console.log(event.target);
		// console.log(this);
		// 콘솔창을 보면 둘다 동일한 값이 나온다

		console.log(event.target.classList);

		if (event.target.classList[1] === "clicked") {
			event.target.classList.remove("clicked");
		} else {
			for (var i = 0; i < font_content.length; i++) {
				font_content[i].classList.remove("clicked");
			}

			event.target.classList.add("clicked");
		}
	}

	function init() {
		for (var i = 0; i < font_content.length; i++) {
			font_content[i].addEventListener("click", handleClick);
		}
	}

	init();


	function clip() {

		var url = '';
		var textarea = document.createElement("textarea");
		document.body.appendChild(textarea);
		url = window.document.location.href;
		textarea.value = url;
		textarea.select();
		document.execCommand("copy");
		document.body.removeChild(textarea);
		alert("URL이 복사되었습니다.")
	}

});//ready end
