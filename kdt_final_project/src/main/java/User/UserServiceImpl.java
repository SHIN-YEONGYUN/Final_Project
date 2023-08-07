package User;

import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import community.BoardDTO;
import travelspot.CommentsDTO;
import travelspot.PlaceDTO;
import travelspot.ReportDTO;;

@Service

public class UserServiceImpl implements UserService {

	@Autowired
	UserDAO dao;
	
	@Autowired
	PlaceDAO placedao;

	@Override
	public void signup(UserDTO dto) {
		dao.signup(dto);
	}

	@Override
	public UserDTO login(String userid, String userpw) {
		UserDTO dto = dao.findByUserId(userid);
		if (dto != null && dto.getUserpw().equals(userpw)) {
			return dto;
		} else {
			return null;
		}
	}

	@Override
	public UserDTO getUserById(int id) {
		return dao.getUserById(id);
	}

	@Override
	@Transactional
	public void updateUser(UserDTO dto) {
//		System.out.println("Before Update - DTO: " + dto.toString());
		dao.updateUser(dto);
//		System.out.println("After Update - DTO: " + dto.toString());
	}

	@Override
	@Transactional
	public void withdrawUser(String userid) {
		dao.withdrawUser(userid);
	}

	@Override
	public UserDTO findUserId(String email, String phone) {
		return dao.selectfindid(email, phone);
	}

	@Override
	public UserDTO findUserPw(String userid, String email) {
		UserDTO dto = dao.selectfindpw(userid, email);
		return dto;
	}

	@Override
	@Transactional
	public void resetPassword(String userid, String email, String temporaryPassword) {
		UserDTO dto = dao.selectfindpw(userid, email);
		if (dto != null) {
			dto.setUserpw(temporaryPassword);
			dao.updatePassword(dto);
		}
	}

	@Override
	public String generateTemporaryPassword() {
		// 임시 비밀번호 생성 로직
		String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		StringBuilder sb = new StringBuilder();
		Random random = new Random();
		for (int i = 0; i < 6; i++) {
			int index = random.nextInt(characters.length());
			sb.append(characters.charAt(index));
		}
		return sb.toString();
	}

	@Override
	public List<BoardDTO> getBoardListByWriter(String writer) {
		return dao.getBoardListByWriter(writer);
	}

	@Override
	public List<CommentsDTO> getCommentListByWriter(String writer) {
		return dao.getCommentListByWriter(writer);
	}
    @Override
    public List<LikesDTO> getLikesByUserId(int user_id) {
        List<LikesDTO> likesList = dao.getLikesByUserId(user_id);

        // 각 LikesDTO에 해당하는 PlaceDTO를 가져와서 설정
        for (LikesDTO likes : likesList) {
            int place_id = likes.getPlace_id();
            PlaceDTO place = placedao.getPlaceById(place_id);
            likes.setPlaceDTO(place);
        }
        return likesList;
    }

	@Override
	public List<UserDTO> getAllUsers(int currentPage, int usersPerPage) {
		int startIdx = (currentPage - 1) * usersPerPage;
        return dao.getAllUsers(startIdx, usersPerPage);
	}

	@Override
	public int getTotalUserCount() {
		return dao.getTotalUserCount();
	}

	@Override
	public UserDTO getUserdetail(String userid) {
		return dao.getUserdetail(userid);
	}

	@Override
	public void deleteUser(String userid) throws Exception {
		dao.deleteUser(userid);		
	}

	@Override
	public List<ReportDTO> getAllReportBoardList() {
		return dao.getAllReportBoardList();
	}

	@Override
	public List<ReportDTO> getAllReportCommentList() {
		return dao.getAllReportCommentList();
	}


	//게시판 작성자 프로필
	@Override
    public String getProfilePhotoByWriter(String writer) {
        UserDTO user = dao.getUserByNickname(writer);
        String photoUrl = user.getPhoto();

        // 만약 프로필 사진이 null이라면 기본 이미지 URL을 반환
        if (photoUrl == null) {
            // 기본 이미지 URL을 반환하는 경로
            return "/img/profile/profileimg.png";
        }

        return photoUrl;
    }
	

}