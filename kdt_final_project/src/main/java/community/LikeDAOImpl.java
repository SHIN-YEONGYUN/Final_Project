package community;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

//import User.LikesDTO;

@Repository
public class LikeDAOImpl implements LikeDAO {

    @Autowired
    private SqlSession sqlSession;

    //@Override
    //public LikesDTO getLikeByUserAndBoard(HashMap<String, Integer> param) {
    //    return sqlSession.selectOne("getLikeByUserAndBoard", new LikesDTO(param.get("user_id"), 0, 0, 0, param.get("board_id")));
    //}
    
    @Override
    public LikeDTO getLikeByUserAndBoard(int user_id, int board_id) {
        HashMap<String, Integer> param = new HashMap<>();
        param.put("user_id", user_id);
        param.put("board_id", board_id);
        return sqlSession.selectOne("getLikeByUserAndBoard", param);
    }

    @Override
    public void createLikes(LikeDTO like) {
        sqlSession.insert("createLikes", like);
    }

    @Override
    public void cancelLikes(LikeDTO like) {
        sqlSession.update("cancelLikes2", like);
    }
    
    @Override
    public void reLikes(LikeDTO like) {
        sqlSession.update("reLikes", like);
    }

	@Override
	public int getLikesCount(int board_id) {
		return sqlSession.selectOne("getLikesCount", board_id);
	}
	
	@Override
	public void increaseLikeCount(int board_id) {
		sqlSession.update("increaseLikeCount", board_id);
	}
	
	@Override
	public void decreaseLikeCount(int board_id) {
		sqlSession.update("decreaseLikeCount", board_id);
	}
}

