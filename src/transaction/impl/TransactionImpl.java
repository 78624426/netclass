package transaction.impl;

import exception.ServiceException;
import org.apache.ibatis.session.SqlSession;
import transaction.TransactionManager;
import util.MyBatisUtil;


public class TransactionImpl implements TransactionManager {
	@Override
	public void commit() throws ServiceException {
		SqlSession session = MyBatisUtil.getSession();
		session.commit();
		session.commit(true);
		
	}

	@Override
	public void rollback() throws ServiceException {
		MyBatisUtil.getSession().rollback();
		
	}

	@Override
	public void beginTransaction() throws ServiceException {
		SqlSession session = MyBatisUtil.getSession();
		session.commit(false);
	}
	
}
