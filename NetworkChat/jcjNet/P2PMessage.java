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
	
	private String mesType;//���͵İ�������
	private String sender;//��������ߵ��û���
	private String getter;//д��Ŀ����û���
	private String sendtime;//����ʱ��
	private String content;//д�������
	private File file;//���͵��ļ���������ڣ�
	
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
		public static String MESSAGE_CHAT = "1"; // ��ͨ��������
		public static String MESSAGE_FILE = "2";// ��������ļ�
		public static String MESSAGE_HELO = "3";//���к�
		public static String MESSAGE_HELOBACK = "4";//��Ӧ���к�����Ӧ�ı����б�ǵ�ʱ����յ��ı���һ��
		public static String MESS_CLOSE = "5";
	}
	
	public String getCurrentTime(){
		//���ո����ĸ�ʽ����ʱ��
		String Str = null;
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new java.util.Date();
		Str = f.format(date);
		return Str;
	}
	
	public P2PMessage( String type,String sender, String getter, String content ){
		//��ʱ�����������
		this.mesType = type; this.sender=sender; this.getter = getter; this.content = content;
		this.sendtime = getCurrentTime(); this.file = null;
	}
	
	public P2PMessage( String type,String sender, String getter, File file ){
		//��ʱ��������ļ�������
		this.mesType = type; this.sender=sender; this.getter = getter; this.file = file;
		this.sendtime = getCurrentTime(); this.content = null;
	}
	
	public P2PMessage() { }
	
	public P2PMessage( String type,String sender, String getter, String content,String sendtime,File file ){
		this.mesType = type; this.sender=sender; this.getter = getter; this.content = content;
		this.sendtime = sendtime; this.file = file;
	}
	
}
