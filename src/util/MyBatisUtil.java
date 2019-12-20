package util;

import exception.DataAccessException;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MyBatisUtil {
	private static SqlSessionFactory sf;
	private static ThreadLocal<SqlSession> threadLocal;
	
	static{
		try {
			threadLocal = new ThreadLocal<SqlSession>();
			sf = new SqlSessionFactoryBuilder()
				.build(MyBatisUtil.class
								  .getClassLoader()
								  .getResourceAsStream("mybatis-config.xml"));
		} catch (Exception e) {
			e.printStackTrace();
			throw new ExceptionInInitializerError("MyBaitsUtil初始化错误");
		}
	}
	
	public static SqlSession getSession(){
		SqlSession session = threadLocal.get();
		try {
			if(session == null){
				session = sf.openSession(false);
				threadLocal.set(session);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new DataAccessException("获取SqlSession失败",e);
		}
		return session;
	}
	
	public static void closeSession(){
		SqlSession session = threadLocal.get();
		if(session != null){
			session.close();
			threadLocal.remove();
		}
	}
}
