package community;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import User.LikesDTO;

@Repository
public class LikeDAOImpl implements LikeDAO {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param) {
        return sqlSession.selectOne("getLikeByUserAndBoard", new LikesDTO(param.get("user_id"), 0, 0, 0, param.get("board_id")));
    }

    @Override
    public void createLikes(User.LikesDTO like) {
        sqlSession.insert("createLikes", like);
    }

    @Override
    public void cancelLikes(User.LikesDTO like) {
        sqlSession.update("cancelLikes", like);
    }

	@Override
	public int getLikesCount(int board_id) {
		return sqlSession.selectOne("getLikesCount", board_id);
	}
}

