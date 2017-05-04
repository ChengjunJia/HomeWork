package JManage;

import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class JLog {
	//��¼��־
	private static Logger logRecord;
	private static FileHandler fileHandle;
	
	public static boolean SetLog( String logname, String logfile ){
		//��logname��Ӧ��log,����־д��name,�洢���ļ���
		//���óɹ��򷵻�true�����򷵻�false
		try{
			logRecord = Logger.getLogger(logname);
			Logger templog = logRecord;
			templog.setLevel(Level.ALL);
			
			//������־��¼���ļ����
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
