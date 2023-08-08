package community;

import java.util.HashMap;

import User.LikesDTO;

public interface LikeDAO {
	//LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param);
	LikeDTO getLikeByUserAndBoard(int user_id, int board_id);
	void createLikes(LikeDTO like);
    void cancelLikes(LikeDTO like);
    void reLikes(LikeDTO like);
    int getLikesCount(int board_id);
    void increaseLikeCount(int board_id);
    void decreaseLikeCount(int board_id);
}

