package community;

import java.util.HashMap;

import User.LikesDTO;

public interface LikeDAO {
	LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param);
    void createLikes(LikesDTO like);
    void cancelLikes(LikesDTO like);
    int getLikesCount(int board_id);
}

