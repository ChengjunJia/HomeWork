package jcjSave;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import javax.swing.JOptionPane;

import JManage.JLog;
import JManage.R;

//管理配置文件
public class IniManage {

	private Properties pro;
	private File file;
	
	
	public IniManage(){
		pro = new Properties();
		file = new File("Setup.ini");
		if( !file.exists() ){
			try {
				file.createNewFile();
			} catch (IOException e) {
				JLog.writeerror("加载配置文件失败!");
				JOptionPane.showMessageDialog(null, "配置文件加载失败，使用默认配置！");
				SetToDefault();
				return;
			}
			SetToDefault();
			try{
				FileOutputStream outTofile = new FileOutputStream(file);
				pro.store(outTofile, "默认配置文件建立完成");
				outTofile.close();
			}catch( IOException e ){
				return;
			}
		}else{
			try {
				FileInputStream inTofile = new FileInputStream(file);
				pro.load(inTofile);
				inTofile.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				return;
			}
			if( pro.getProperty(Default.Property.logname) != null ){
				R.LogInfo.Logname = pro.getProperty( Default.Property.logname );
			}
			if( pro.getProperty( Default.Property.logfile ) != null ){
				R.LogInfo.Logname = pro.getProperty(Default.Property.logfile);
			}
			if( pro.getProperty( Default.Property.root ) != null ){
				R.SaveInfo.RootPath = pro.getProperty(Default.Property.root);
			}
			if( pro.getProperty( Default.Property.filedirect ) != null ){
				R.SaveInfo.FileDirectory = pro.getProperty(Default.Property.filedirect);
			}
			if( pro.getProperty( Default.Property.p2pprot ) != null ){
				R.P2PChat.port = Integer.valueOf( pro.getProperty(Default.Property.p2pprot) ).intValue();
			}
			String temp =null;
			if( (temp = pro.getProperty(Default.Property.pwdWithoutFound)) !=null ){
				R.AccountInfo.psd = temp;
			}
			if( (temp = pro.getProperty(Default.Property.skin)) !=null ){
				R.skin.skin0 = temp;
			}
		}
	}
	
	private void SetToDefault(){
		pro.setProperty( Default.Property.serverip, Default.AccountInfo.ServerIP);
		pro.setProperty( Default.Property.serveport, String.valueOf( Default.AccountInfo.ServerPort) );
		
		pro.setProperty( Default.Property.logname, Default.LogInfo.Logname);
		pro.setProperty( Default.Property.logfile, Default.LogInfo.filehandlename);
		pro.setProperty( Default.Property.root, Default.SaveInfo.RootPath);
		pro.setProperty( Default.Property.filedirect, Default.SaveInfo.FileDirectory);
		pro.setProperty( Default.Property.p2pprot, String.valueOf( Default.P2PChat.port) );
		pro.setProperty( Default.Property.skin, Default.skin.skin0 );
		pro.setProperty( Default.Property.pwdWithoutFound, Default.AccountInfo.psd );
	}
	
	
}

class Default{
	
	public static final class Property{
		public static final String serverip = "ServerIP";
		public static final String serveport = "ServerPort";
		public static final String logname = "LogName";
		public static final String logfile = "FileHandleName";
		public static final String root = "RootPath";
		public static final String filedirect = "FileDirectory";
		public static final String p2pprot = "P2PPort";
		public static final String skin = "skin";
		public static final String pwdWithoutFound = "PWD";
	}
	
	public static final class AccountInfo{
		//与服务器的通讯的相关信息
		public static final String ServerIP = "166.111.140.14";
		public static final int ServerPort = 8000;
		
		public static final String logoutMess = "logout";
		public static final String loginBackCorrect = "lol";
		public static final String logoutBackCorrect = "loo";
		
		public static String psd = "admin";
		
	//	public static final String username;
	}
	
	public static final class LogInfo{
		//日志的存储等信息
		public static final String Logname = "JQQ";
		public static final String filehandlename = "JQQ_log";
	}
	
	public static final class SaveInfo{
		//存储好友列表信息
		public static final String RootPath = "././History";
		//存储聊天信息
		public static final String FileDirectory = "File";//默认保存路径
	}
	
	public static final class P2PChat{
		public static final int port = 13542;	
	}
	
	public static final class skin{
		public static String skin0 = "javax.swing.plaf.nimbus.NimbusLookAndFeel";
	}
}