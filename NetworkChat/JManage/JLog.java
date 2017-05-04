package JManage;

import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class JLog {
	//记录日志
	private static Logger logRecord;
	private static FileHandler fileHandle;
	
	public static boolean SetLog( String logname, String logfile ){
		//打开logname对应的log,把日志写入name,存储在文件中
		//设置成功则返回true，否则返回false
		try{
			logRecord = Logger.getLogger(logname);
			Logger templog = logRecord;
			templog.setLevel(Level.ALL);
			
			//设置日志记录的文件情况
			fileHandle = new FileHandler(logfile,true);
			fileHandle.setLevel(Level.ALL);
			templog.addHandler(fileHandle);
			return true;
		} catch( IOException e){
				return false;
		}
	}
	
	public static void writelog( String string ){
		logRecord.log(Level.INFO, string+"\r\n");
	}
	
	public static void writeerror( String string ){
		logRecord.log(Level.WARNING, string+"\r\n");
	}
	
}
