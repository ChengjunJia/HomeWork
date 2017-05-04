package jcjNet;

import java.io.File;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

public class P2PMessage implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 4418740126175333869L;
	
	private String mesType;//发送的包的类型
	private String sender;//打包发送者的用户名
	private String getter;//写入目标的用户名
	private String sendtime;//发送时间
	private String content;//写入的文字
	private File file;//发送的文件（如果存在）
	
	public String getSendTime() { return sendtime;}
	public void setSendTime( String s ) { sendtime = s; }
	
	public String getSender() { return sender; }
	public void setSender( String s ) { sender = s; }
	
	public String getGetter() {	return getter; }
	public void setGetter(String getter) {	this.getter = getter; }

	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }

	public String getMesType() { return mesType; }
	public void setMesType(String mesType) { this.mesType = mesType; }
	
	public File getFile() { return file; }
	public void setFile( File f ) { this.file = f; }
	
	public static class MessageType{
		public static String MESSAGE_CHAT = "1"; // 普通聊天内容
		public static String MESSAGE_FILE = "2";// 传输的是文件
		public static String MESSAGE_HELO = "3";//打招呼
		public static String MESSAGE_HELOBACK = "4";//回应打招呼；回应的报文中标记的时间和收到的报文一致
		public static String MESS_CLOSE = "5";
	}
	
	public String getCurrentTime(){
		//按照给定的格式返回时间
		String Str = null;
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new java.util.Date();
		Str = f.format(date);
		return Str;
	}
	
	public P2PMessage( String type,String sender, String getter, String content ){
		//即时打包聊天内容
		this.mesType = type; this.sender=sender; this.getter = getter; this.content = content;
		this.sendtime = getCurrentTime(); this.file = null;
	}
	
	public P2PMessage( String type,String sender, String getter, File file ){
		//即时打包发送文件的内容
		this.mesType = type; this.sender=sender; this.getter = getter; this.file = file;
		this.sendtime = getCurrentTime(); this.content = null;
	}
	
	public P2PMessage() { }
	
	public P2PMessage( String type,String sender, String getter, String content,String sendtime,File file ){
		this.mesType = type; this.sender=sender; this.getter = getter; this.content = content;
		this.sendtime = sendtime; this.file = file;
	}
	
}
