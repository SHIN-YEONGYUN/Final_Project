package community;

import java.util.HashMap;
import java.util.Map;

import User.LikesDTO;

public interface LikeService {
    //LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param);
	LikeDTO getLikeByUserAndBoard(int user_id, int board_id);
	void createLike(int userId, int boardId);
    void deleteLike(LikeDTO like);
    void reLike(LikeDTO like);
    int getLikesCount(int board_id);
    void increaseLikeCount(int board_id);
    void decreaseLikeCount(int board_id);


}

