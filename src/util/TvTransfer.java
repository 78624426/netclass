package util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.InputStream;
/**ffmpeg能解析的格式：（asx，asf，mpg，wmv，3gp，mp4，mov，avi，flv等）
对ffmpeg无法解析的文件格式(wmv9，rm，rmvb等), 
可以先用别的工具（mencoder）转换为avi(ffmpeg能解析的)格式.
 */
public class TvTransfer {
	private static String inputPath = "";
    private static String outputPath = "";
    private static String ffmpegPath = "";
    public static void main(String[] args) {
    	 getPath();
    	 if (isDir(inputPath)) { 
    		 System.out.println(inputPath + " is not file"); 
    		 return; 
    	 } 
    	 if (processMp4(inputPath)) { 
    		 System.out.println("ok"); 
    	 }
    	 
	}
    
    public static void getPath() { 
    	// 在获得源文件、目标文件、转换器的路径    	
    	try { 
    		inputPath = "d:\\work\\src\\1.wmv"; 
    		outputPath = "D:\\work\\dst\\"; 
    		ffmpegPath = "d:\\work\\ffmpeg\\bin\\"; 
    		 
    	} catch (Exception e) {
    		System.out.println("getPath出错"); 
    	}
    } 
    
    //判断是否为文件
    private static boolean isDir(String path) { 
    	File file = new File(path); 
    	return file.isDirectory();
    }
    private static boolean processMp4(String oldfilepath) { 
    	if (isDir(inputPath)) {
    		System.out.println(oldfilepath + " is not file"); 
    		return false; 
    	} 
    	
    	try { 
    		// 方案1 //        
    		Process videoProcess = Runtime.getRuntime().exec(ffmpegPath+"ffmpeg -i "+oldfilepath+" -ab 320 -ar 44100 -qscale 2 -r 30 -s 600x500 "+outputPath+"a.mp4"); 
    		new PrintStream(videoProcess.getErrorStream()).start();
    		new PrintStream(videoProcess.getInputStream()).start(); 
    		videoProcess.waitFor(); 
    		return true; 
    	} catch (Exception e) {
    			e.printStackTrace();
    			return false; 
    	}
    	
    }
}
class PrintStream extends Thread { 
	InputStream is = null;
	public PrintStream(InputStream is) {
		this.is = is; 
	} 
	public void run() {
		try {
			BufferedInputStream bi = new BufferedInputStream(is);
			int d;
			while((d= bi.read())!=-1){
				System.out.print((char)d);
			}
			//bi.close();
//			
		} catch (Exception e) {
				e.printStackTrace();
		}
	}
}
