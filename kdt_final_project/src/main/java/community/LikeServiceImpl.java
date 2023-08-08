package community;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import User.LikesDTO;


@Service
public class LikeServiceImpl implements LikeService {

    @Autowired
    private LikeDAOImpl likeDAO;

    //@Override
    //public LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param) {
    //    return likeDAO.getLikeByUserAndBoard(param);
    //}
    
    @Override
    public LikeDTO getLikeByUserAndBoard(int user_id, int board_id) {
        return likeDAO.getLikeByUserAndBoard(user_id, board_id);
    }

    @Override
    public void createLike(int userId, int boardId) {
        LikeDTO like = new LikeDTO(0, userId, 1, 0, boardId);
        likeDAO.createLikes(like);
    }

    @Override
    public void deleteLike(LikeDTO like) {
        likeDAO.cancelLikes(like);
    }
    
    @Override
    public void reLike(LikeDTO like) {
        likeDAO.reLikes(like);
    }

	@Override
	public int getLikesCount(int board_id) {
		return likeDAO.getLikesCount(board_id);
	}
	
	@Override
	public void increaseLikeCount(int board_id) {
		likeDAO.increaseLikeCount(board_id);
	}
	
	@Override
	public void decreaseLikeCount(int board_id) {
		likeDAO.decreaseLikeCount(board_id);
	}

}
