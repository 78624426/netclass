package transaction;

import exception.ServiceException;

public interface TransactionManager {
	public void beginTransaction() throws ServiceException;
	public void commit() throws ServiceException;
	public void rollback() throws ServiceException;
}
