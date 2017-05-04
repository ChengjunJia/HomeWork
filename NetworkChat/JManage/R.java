package JManage;
//存储所有需要使用的常量
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class R {

	public static final class AccountInfo{
		//与服务器的通讯的相关信息
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
		//日志的存储等信息
		public static String Logname = "JQQ";
		public static String filehandlename = "JQQ_log";
	}
	
	public static final class SaveInfo{
		//存储好友列表信息
		public static String RootPath = "././History";
		//存储聊天信息
		public static String FileDirectory = "File";//默认保存路径
	}
	
	public static final class P2PChat{
		public static int port = 13542;
	}
	
	public static final class skin{
		public static String skin0 = "javax.swing.plaf.nimbus.NimbusLookAndFeel";
	}
	
	public static boolean IsIP( String str ){
		//利用正则表达式，检查str是否是一个I地址
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