package community;

import java.util.HashMap;
import java.util.Map;

import User.LikesDTO;

public interface LikeService {
    LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param);
    void createLike(int userId, int boardId);
    void deleteLike(LikesDTO like);
    int getLikesCount(int board_id);

}

