package jcjSave;
import java.awt.Color;
import java.io.BufferedReader;
//�洢�����¼
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JTextArea;

import JManage.JLog;
import jcjNet.P2PMessage;

public class ChatHistoryManage {

	private JFrame frame;
	private File file = null;
	private String chat;
	private String fileloc =null;
	
	public ChatHistoryManage( String chatname ){
		try{
			chat = chatname;
			//�ҵ��ļ�λ��
			fileloc = JManage.R.SaveInfo.RootPath+"/"+JManage.R.AccountInfo.username ;
			file = new File(fileloc);
			if( !file.exists() ){
				file.mkdirs();
			}
			fileloc = fileloc + "/"+chatname+".history";
			file = new File(fileloc);
			if( !file.exists() ){
				file.createNewFile();
			}
			
		}catch(Exception e){
			JLog.writeerror("��ʼ�����¼������"+"��¼Ŀ�꣺"+ fileloc);
		}
	}
	
	public boolean AddToFile( P2PMessage mess, boolean send ){
		String record = null;
		if( send ){
			record = "[!Record!]S:\r\n";
		} else {
			record = "[!Record!]R:\r\n";
		}
		record += mess.getCurrentTime()+"\r\n";
		if( mess.getMesType().equals( P2PMessage.MessageType.MESSAGE_CHAT ) ){
			record += mess.getContent();
		} else if( mess.getMesType().equals( P2PMessage.MessageType.MESSAGE_FILE ) ){
			record += "[!A File!]";
		}
		record += "\r\n";
		try{
			FileWriter writer = new FileWriter(file, true);
			writer.write(record);
			writer.close();
			return true;
		}catch( IOException e ){
			JLog.writeerror("Create write the File which records the FriendList!");
			JOptionPane.showMessageDialog(null, "�޷��Ѻ����б��浽�ļ�");
			return false;
		}
	}
	
	public void ShowHistory(){
		frame = new JFrame(chat+"History");
		frame.setSize(400, 400);
		JTextArea textArea = new JTextArea();
		textArea.setSelectedTextColor(Color.RED);
		textArea.setLineWrap(true);
		textArea.setWrapStyleWord(true);
		textArea.setEnabled(false);
		frame.add(textArea);
		try{
			String tempStr = null;
			BufferedReader reader = new BufferedReader(new FileReader(file));
			while( (tempStr = reader.readLine()) !=null ){
				textArea.append(tempStr+"\r\n");
			}
			reader.close();
		}catch( IOException e ){
			JLog.writeerror("��ʾ�����¼ʧ��");
		}
		JLog.writeerror("������ʾ��ʷ�ĺ���");
		frame.setVisible(true);
	}
	
}
