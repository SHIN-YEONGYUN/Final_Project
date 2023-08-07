package community;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import User.LikesDTO;

@Service
public class LikeServiceImpl implements LikeService {

    @Autowired
    private LikeDAOImpl likeDAO;

    @Override
    public LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param) {
        return likeDAO.getLikeByUserAndBoard(param);
    }

    @Override
    public void createLike(int userId, int boardId) {
        LikesDTO like = new LikesDTO(0, userId, 1, 0, boardId);
        likeDAO.createLikes(like);
    }

    @Override
    public void deleteLike(LikesDTO like) {
        likeDAO.cancelLikes(like);
    }

	@Override
	public int getLikesCount(int board_id) {
		return likeDAO.getLikesCount(board_id);
	}
}
