package User;

import java.util.List;

import community.BoardDTO;
import travelspot.CommentsDTO;
import travelspot.PlaceDTO;
import travelspot.ReportDTO;

public interface UserService {

	public void signup(UserDTO dto);

	public UserDTO login(String userid, String userpw);

	UserDTO getUserById(int id);

	void updateUser(UserDTO dto);

	void withdrawUser(String userid); // 회원 탈퇴

	UserDTO findUserId(String email, String phone);

	UserDTO findUserPw(String userid, String email);

	void resetPassword(String userid, String email, String temporaryPassword);

	String generateTemporaryPassword();

	List<BoardDTO> getBoardListByWriter(String writer);

	List<CommentsDTO> getCommentListByWriter(String writer);

	List<LikesDTO> getLikesByUserId(int user_id);
	
	List<UserDTO> getAllUsers(int currentPage, int usersPerPage);
	
	int getTotalUserCount();

	public UserDTO getUserdetail(String userid);
	
	void deleteUser(String userid) throws Exception;
	
    List<ReportDTO> getAllReportBoardList();
    List<ReportDTO> getAllReportCommentList();

    //게시판 작성자 프로필
    String getProfilePhotoByWriter(String writer);
    
}
