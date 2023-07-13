document.addEventListener('DOMContentLoaded', function() {
  const sideMenuNav = document.querySelector('.side-menu-nav');
  const sideMenuForms = document.querySelectorAll('.side-menu-form');

  sideMenuNav.addEventListener('click', function(event) {
    event.preventDefault();
    if (event.target.tagName === 'A') {
      const targetSectionId = event.target.getAttribute('href');
      showSection(targetSectionId);
    }
  });

  // showSection 함수에서 '#section7' 섹션만 보여주도록 수정
  function showSection(targetSectionId) {
    sideMenuForms.forEach(function(form) {
      if ('#' + form.id === targetSectionId) {
        form.style.display = 'block';
      } else {
        form.style.display = 'none';
      }
    });
  }

  // 회원 탈퇴 확인 함수
  function confirmWithdraw() {
    // confirm 메서드를 사용하여 사용자에게 정말로 탈퇴할 것인지 확인
    return confirm("정말로 회원 탈퇴하시겠습니까?");
  }

  // 회원 탈퇴가 성공적으로 이루어진 경우 메인 페이지로 이동하는 함수
  function redirectToMainPage() {
    window.location.href = "/"; // 메인 페이지 URL로 리다이렉트
  }

  // 서버로부터 받은 응답에 따라 처리를 수행하는 함수
  function handleWithdrawResponse(data) {
    alert(data); // 서버로부터 받은 응답 메시지 출력
    if (data === "탈퇴되었습니다.") {
      redirectToMainPage(); // 회원 탈퇴 성공 시 메인 페이지로 이동
    }
  }

  // 회원 탈퇴 버튼 클릭 시 이벤트 핸들러
  const withdrawForm = document.querySelector('.withdraw-section form');
  withdrawForm.addEventListener('submit', function(event) {
    event.preventDefault();
    if (confirmWithdraw()) {
      // 회원 탈퇴 요청을 비동기적으로 서버로 보냄
      fetch('/withdrawUser', {
          method: 'POST',
      })
      .then(response => response.text())
      .then(data => handleWithdrawResponse(data))
      .catch(error => {
          console.error('Error:', error);
      });
    }
  });

  // 최근 방문한 페이지 관련 스크립트
  const recentVisitedPagesSection = document.getElementById('section4');
  const recentVisitedPagesList = recentVisitedPagesSection.querySelector('ul');

  // 서버로부터 최근 방문한 페이지 목록을 받아와서 동적으로 리스트 아이템을 생성
  function populateRecentVisitedPages() {
    fetch('/getRecentVisitedPages') // 최근 방문한 페이지 목록을 가져오는 요청
      .then(response => response.json())
      .then(data => {
        // 서버에서 받은 데이터로 리스트 아이템을 생성
        data.forEach(page => {
          const listItem = document.createElement('li');
          listItem.textContent = page.title;
          recentVisitedPagesList.appendChild(listItem);
        });
      })
      .catch(error => {
        console.error('Error:', error);
      });
  }

  // 최근 방문한 페이지 목록을 초기화
  function clearRecentVisitedPages() {
    recentVisitedPagesList.innerHTML = '';
  }

  // 최근 방문한 페이지 섹션을 보여주고 목록을 가져오기
  function showRecentVisitedPagesSection() {
    clearRecentVisitedPages(); // 기존 목록 초기화
    recentVisitedPagesSection.style.display = 'block'; // 섹션 보여주기
    populateRecentVisitedPages(); // 목록 가져오기
  }

  // 최근 방문한 페이지 섹션 링크 클릭 시 이벤트 핸들러
  const recentVisitedPagesLink = document.querySelector('.side-menu-nav a[href="#section4"]');
  recentVisitedPagesLink.addEventListener('click', function(event) {
    event.preventDefault();
    showRecentVisitedPagesSection();
  });
});