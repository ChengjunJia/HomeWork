package JManage;
//�洢������Ҫʹ�õĳ���
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class R {

	public static final class AccountInfo{
		//���������ͨѶ�������Ϣ
		public static String ServerIP = "166.111.140.14";
		public static int ServerPort = 8000;
		public static int IntTimeEnd = 10000;
		
		public static String logoutMess = "logout";
		public static String loginBackCorrect = "lol";
		public static String logoutBackCorrect = "loo";
		
		public static String username = "admin";
		public static String psd = "admin";
	}
	
	public static final class LogInfo{
		//��־�Ĵ洢����Ϣ
		public static String Logname = "JQQ";
		public static String filehandlename = "JQQ_log";
	}
	
	public static final class SaveInfo{
		//�洢�����б���Ϣ
		public static String RootPath = "././History";
		//�洢������Ϣ
		public static String FileDirectory = "File";//Ĭ�ϱ���·��
	}
	
	public static final class P2PChat{
		public static int port = 13542;
	}
	
	public static final class skin{
		public static String skin0 = "javax.swing.plaf.nimbus.NimbusLookAndFeel";
	}
	
	public static boolean IsIP( String str ){
		//����������ʽ�����str�Ƿ���һ��I��ַ
		if( str == null || str.equals("") ){
			return false;
		}
		Pattern pattern = Pattern.compile("\\b((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\b");
		Matcher matcher = pattern.matcher(str);
		return matcher.matches();
	}
	
	public static String getCurrentTime(){
		String returnStr = null;
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new java.util.Date();
		returnStr = f.format(date);
		return returnStr+" ";
	}
}