package community;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import User.UserDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import travelspot.ReportDTO;

@Controller
public class CommunityController {

	@Autowired
	private BoardService boardService;

	@Autowired
	private LikeService likeService;

	// 커뮤니티 페이지 매핑
	@RequestMapping("/community")
	public String community(HttpServletRequest request, Model model) {
		String order = request.getParameter("order");

		List<BoardDTO> boardList;
		if ("newest".equals(order)) {
			// 최신순으로 게시글 가져오기
			boardList = boardService.getNewestBoards();
		} else {
			// 기본은 좋아요 수에 따라 정렬하여 게시글 가져오기
			boardList = boardService.getAllBoards();
			Collections.sort(boardList, Comparator.comparing(BoardDTO::getLikecount).reversed());
		}

		model.addAttribute("boardList", boardList);

		//List<BoardDTO> top10List = boardService.getTop10Boards();
		//model.addAttribute("top10List", top10List);

		return "community";
	}

	// 새글쓰기 화면 writing.jsp 매핑
	@RequestMapping("/writing")
	public String writingForm(HttpServletRequest request, Model model) {
		UserDTO user = (UserDTO) request.getSession().getAttribute("user");
		if (user == null) {
			return "redirect:/login";
		} else if (user != null) {
			model.addAttribute("nickname", user.getNickname());
		}
		return "writing";
	}

	// 글쓰기 누르면 DB에 저장
	@PostMapping("/boardwrite")
	public ModelAndView boardWritePro(HttpServletRequest request) {
		BoardDTO board = new BoardDTO();
		board.setBoard_title(request.getParameter("board_title"));
		board.setPlace(request.getParameter("place"));
		board.setWriter(request.getParameter("writer"));
		board.setTitle(request.getParameter("title"));
		board.setContents(request.getParameter("contents"));

		boardService.createBoard(board);

		ModelAndView mv = new ModelAndView();
		mv.addObject("board", board);
		mv.setViewName("board/detail");
		return mv;
	}

	// detail.jsp로 이동
	@GetMapping("/detail")
	public ModelAndView showBoardDetail(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int boardId = Integer.parseInt(request.getParameter("boardId"));

		// 게시글 조회수 증가
		boardService.increaseViewCount(boardId);

		BoardDTO board = boardService.getBoardById(boardId);
		mv.addObject("board", board);

		UserDTO user = (UserDTO) request.getSession().getAttribute("user");
		if (user != null) {
			mv.addObject("nickname", user.getNickname());
		}

		mv.setViewName("board/detail");
		return mv;
	}

	// update.jsp로 이동
	@GetMapping("/update")
	public ModelAndView showBoardUpdateForm(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int boardId = Integer.parseInt(request.getParameter("boardId"));
		BoardDTO board = boardService.getBoardById(boardId);
		mv.addObject("board", board);
		mv.setViewName("board/update");
		return mv;
	}

	// 수정 완료 눌렀을 때
	@PostMapping("/update")
	public String updateBoard(HttpServletRequest request) {
		int boardId = Integer.parseInt(request.getParameter("id"));
		String boardTitle = request.getParameter("board_title");
		String place = request.getParameter("place");
		String title = request.getParameter("title");
		String contents = request.getParameter("contents");

		BoardDTO board = boardService.getBoardById(boardId);
		board.setBoard_title(boardTitle);
		board.setPlace(place);
		board.setTitle(title);
		board.setContents(contents);
		boardService.updateBoard(board);

		// 수정된 글을 보여줄 detail 페이지로 리다이렉트
		return "redirect:/detail?boardId=" + boardId;
	}

	// 삭제버튼 눌렀을 때 게시글 삭제
	@GetMapping("/delete")
	public String deleteBoard(HttpServletRequest request, Model model) {
		int boardId = Integer.parseInt(request.getParameter("boardId"));
		BoardDTO board = boardService.getBoardById(boardId);
		boardService.deleteBoard(board);

		model.addAttribute("boardId", boardId);
		return "board/delete"; // delete.jsp로 이동
	}

	@RequestMapping("/delete")
	public String showDeletePage(HttpServletRequest request) {
		return "board/delete";
	}

	@GetMapping("/comments/save")
	@ResponseBody
	public void saveComment(int boardId, String contents, HttpServletRequest request) {
		UserDTO user = (UserDTO) request.getSession().getAttribute("user");
		if (ObjectUtils.isEmpty(user)) {
		} else {
			CommentsDTO commentsDTO = new CommentsDTO();
			commentsDTO.setContents(contents);
			commentsDTO.setContent_id(boardId);
			commentsDTO.setWriter(user.getNickname());
			boardService.insertComment(commentsDTO);
		}
	}

	@GetMapping("/comments/list")
	@ResponseBody
	public Map<String, Object> getComments(@RequestParam int boardId, HttpSession session) {
		Map<String, Object> map = new HashMap<>();

		List<CommentsDTO> commentsList = boardService.getComments(boardId);
		map.put("commentsList", commentsList);

		UserDTO userdto = (UserDTO) session.getAttribute("user");
		if (ObjectUtils.isEmpty(userdto)) {
			map.put("userdto", "null");
		} else {
			map.put("userdto", userdto.getNickname());
		}

		return map;
	}

	@RequestMapping(value = "/comments/delete", produces = { "application/json; charset=utf-8" })
	@ResponseBody
	public void deleteComments(int id) {
		boardService.deleteComments(id);
	}

	@RequestMapping(value = "/comments/modify", produces = { "application/json; charset=utf-8" })
	@ResponseBody
	public CommentsDTO modifyComments(int id) {
		return boardService.getOneComment(id);
	}

	@GetMapping(value = "/comments/modify_save", produces = { "application/json; charset=utf-8" })
	@ResponseBody
	public void modify_SaveComments(int id, String contents) {
		CommentsDTO dto = new CommentsDTO();
		dto.id = id;
		dto.contents = contents;

		boardService.updateComments(dto);
	}

	@GetMapping(value = "/comments/modify_cancel", produces = { "application/json; charset=utf-8" })
	@ResponseBody
	public void modify_CancelComments(int id) {

	}

	@GetMapping(value = "/comments/report")
	public ModelAndView reportComments(int id, int boardId, HttpSession session) {
		UserDTO userdto = (UserDTO) session.getAttribute("user");

		ModelAndView mv = new ModelAndView();
		mv.addObject("boardId", boardId);
		mv.addObject("commentid", id);// 신고당할 댓글 번호
		mv.addObject("reportedId", boardService.selectReportedId(id));// 신고당한 댓글 작성자 아이디
		mv.addObject("nickname", userdto.getNickname());// 신고자닉네임
		mv.addObject("userid", userdto.getUserid());// 신고자아이디

		mv.setViewName("/board/reportcomments");
		return mv;
	}

	@PostMapping(value = "/comments/reportcheck")
	@ResponseBody
	public String checkReport(int id, int boardId, HttpSession session) {
		UserDTO userdto = (UserDTO) session.getAttribute("user"); // 로그인사용자
		List<String> useridlist = boardService.selectUserId(id); // 신고한 사람들 아이디
		System.out.println("댓글번호: " + id);
		System.out.println("로그인 아이디: " + userdto.getUserid());

		String response = "false";

		for (int i = 0; i < useridlist.size(); i++) {
			System.out.println("신고자 아이디: " + useridlist.get(i));
			if ((useridlist.get(i)).equals(userdto.getUserid())) {// 중복
				response = "true";
				break;
			}
			System.out.println("response:" + response);
		}

		return response;
	}

	@PostMapping(value = "/comments/report")
	public String reportComments(travelspot.ReportDTO ReportDTO) {
		// 신고내용 저장 -> 댓글창으로 리턴?
		boardService.insertReport(ReportDTO);
		return "redirect:/detail?boardId=" + ReportDTO.getContentId();
	}

	// 좋아요 상태를 확인하는 API
	@GetMapping("/api/getLikeStatus")
	@ResponseBody
	public Map<String, Object> getLikeStatus(@RequestParam("boardId") int boardId, HttpServletRequest request) {
		//이 메서드 목표와 detail.jsp 내 checkLoginAndHandleLike 목표와 다름 -> 로그인여부 처리로 변경
		//확인용: System.out.println("게시판 번호: "+boardId);
		
		Map<String, Object> response = new HashMap<>();
		UserDTO user = (UserDTO) request.getSession().getAttribute("user");
		if (user == null) {
			//response.put("likeStatus", "unliked");
			response.put("isLoggedIn", false);
		} else {
			response.put("isLoggedIn", true);
			//LikesDTO like = likeService.getLikeByUserAndBoard(user.getId(), boardId);
			//if (like == null || like.getLike_check() == 0) {
			//	response.put("likeStatus", "unliked");
			//} else {
			//	response.put("likeStatus", "liked");
			//}
		}
		return response;
	}

	// 좋아요 버튼 클릭 시 처리
		@GetMapping("/toggleLike")
		@ResponseBody
		public Map<String, Object> toggleLike(@RequestParam("boardId") int board_id, HttpServletRequest request) {
			System.out.println("확인용: "+board_id );
			UserDTO user = (UserDTO) request.getSession().getAttribute("user");
			int user_id = user.getId();
			System.out.println(user_id);
			
			Map<String, Object> response = new HashMap<>();
			//HashMap<String, Integer> param = new HashMap<>();
			//param.put("board_id", board_id);
			//param.put("user_id", user_id);


				//LikesDTO like = likeService.getLikeByUserAndBoard(param);
				LikeDTO like = likeService.getLikeByUserAndBoard(user_id, board_id);
		        System.out.println("like = " + like);
		        response.put("like", like);
				if (like == null) {
					// 해당 게시글에 좋아요를 누른 적이 없는 경우
					response.put("likeStatus", "liked");
					likeService.createLike(user_id, board_id);
					likeService.increaseLikeCount(board_id); //추가한 부분
				} else if(like.getLike_check() == 0) {
					// 취소했다가 다시 좋아요를 누른 경우
					response.put("likeStatus", "liked");
					likeService.reLike(like);
					likeService.increaseLikeCount(board_id);
				}else if(like.getLike_check() == 1) {
					// 이미 해당 게시글에 좋아요를 누른 경우
					response.put("likeStatus", "unliked");
					likeService.deleteLike(like);
					likeService.decreaseLikeCount(board_id);
				}
				//좋아요수 response에 put하지 않았으므로 detail.jsp에서 response.likeCount 사용불가
				//좋아요 수 쿼리 추가 후 response에 좋아요 수 넣기
				response.put("likeCount", likeService.getLikesCount(board_id));
				
			return response;
		}


	@RequestMapping("/board/report")
	public ModelAndView ShowReport(int id, HttpSession session) {
		UserDTO userdto = (UserDTO) session.getAttribute("user");

	

		ModelAndView mv = new ModelAndView();
		
		mv.addObject("boardId", id);// 신고당할 글 번호
		mv.addObject("reportedId", boardService.selectReportedId2(id));
		mv.addObject("nickname", userdto.getNickname());// 신고자닉네임
		mv.addObject("userId", userdto.getUserid());// 신고자아이디

		mv.setViewName("board/report");
		return mv;
	}
	
	@RequestMapping(value="/board/report",method = RequestMethod.POST)
	@ResponseBody
	public String reportboard(@ModelAttribute ReportDTO reportDTO) {
	    boardService.insertReport2(reportDTO);
	    return "Success";
	}
	
	@RequestMapping("/community/search")
	public ModelAndView searchBoard(
			@RequestParam(value="item", required=false, defaultValue="지역")String item, 
			@RequestParam(value="searchword", required=false, defaultValue="")String searchword, 
			@RequestParam(value="page", required=false, defaultValue="1")int page) {

		// 검색 조건으로 검색한 게시글 리스트, 게시글수
		HashMap<String, Object> map = new HashMap<>();

		if (item.equals("지역")) {
			map.put("colname", "place");
		}
		if (item.equals("제목")) {
			map.put("colname", "title");
		}
		if (item.equals("작성자")) {
			map.put("colname", "writer");
		}
		
		map.put("searchitem", item);
		map.put("colvalue", "%"+searchword+"%");
		map.put("limitindex",(page-1)*9 );
		map.put("limitcount",9);
		
		List<BoardDTO> boardList = boardService.searchBoard(map);
		int totalCnt = boardService.searchBoardCnt(map);

		ModelAndView mv = new ModelAndView();
		mv.addObject("boardList", boardList);
		mv.addObject("searchmap", map);
		mv.addObject("totalCnt", totalCnt);
		mv.setViewName("community_search");
		return mv;
	}

}