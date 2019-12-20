package factory;
import java.util.*;
import java.io.*;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;


import exception.DataAccessException;
import org.apache.ibatis.session.SqlSession;
import util.MyBatisUtil;

public class ObjectFactory {
		private static Map<String,Object> objects = new HashMap<String,Object>();
		static{
			BufferedReader br = null;
			try{
				br = new BufferedReader(new InputStreamReader(ObjectFactory.class.getClassLoader()
							.getResourceAsStream("objects-mybatis.txt")));
				String s = null;
				while ((s = br.readLine()) != null) {
					String[] entry = s.split("=");
					if(entry.length != 2){
						continue;
					}
					String key = entry[0].trim();
					String value = entry[1].trim();
					Class<?> c = Class.forName(value);
					if(c.isInterface()){
						objects.put(key, c);
						continue;
					}
					objects.put(key, c.newInstance());
				}
			}catch(Exception e){
				e.printStackTrace();
				throw new ExceptionInInitializerError("ObjectFactory初始化错误"+e);
			}finally{
				if(br!=null){
					try{
						br.close();
					}catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		
		public static Object getObject(String key) {
			Object obj = objects.get(key);
			//返回dao的代理对象
			if (obj instanceof Class) {
				SqlSession session = MyBatisUtil.getSession();
				final Object dao = session.getMapper((Class<?>) obj);
				Object daoProxy = Proxy.newProxyInstance(dao.getClass()
						.getClassLoader(), new Class[] { (Class<?>) obj },
						new InvocationHandler() {
							@Override
							public Object invoke(Object proxy, Method method,
									Object[] args) throws Throwable {
								Object result = null;
								try {
									result = method.invoke(dao, args);
								} catch (Exception e) {
									e.printStackTrace();
									throw new DataAccessException("数据访问失败", e);
								}
								return result;
							}
						});
				return daoProxy;
			}
			return obj;
		}


}
