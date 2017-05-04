package jcjNet;
//����ά����չ���Ѵӷ����������Ϣ�Ĵ�����кϲ�����
import java.net.*;

import javax.swing.JOptionPane;

import JManage.JLog;
import JManage.R;

import java.awt.HeadlessException;
import java.io.*;


public class Account {
	Socket sct = null;
	Reader inFromServer;//receive from server
	Writer outToServer;//send to server
	
	public Account( ) {
		try {
			sct = new Socket(R.AccountInfo.ServerIP, R.AccountInfo.ServerPort);
			inFromServer = new InputStreamReader( sct.getInputStream() );
			outToServer = new OutputStreamWriter(sct.getOutputStream() );
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			JOptionPane.showMessageDialog(null, "�޷����ӵ����ķ�������");
			JLog.writeerror("Account:UnKnownHostException!");
			JLog.writeerror( e.getMessage() );
		} catch (IOException e) {
			// TODO Auto-generated catch block
			JOptionPane.showMessageDialog(null, "�޷��������������ķ������Ľ�����");
			JLog.writeerror("Account:IOException!");
			JLog.writeerror( e.getMessage() );
		}
		
	}
	
	public boolean logIn(String name, String password) {
		//Login Success: return true
		try{
			outToServer.write( name + "_" + password);
			outToServer.flush();
		} catch( IOException e ){
			JOptionPane.showMessageDialog(null, "���͵�¼��Ϣʧ�ܣ���");
			JLog.writeerror("Account:logIn:UnKnownHostException!");
			JLog.writeerror( e.getMessage() );
			return false;
		}
		String mess = null;
		try{
			mess = WaitMess();
		}catch( Exception  e ){
			JLog.writeerror("�ӷ����������ж�ȡ��Ϣʧ��");
			return false;
		}
		if (mess.equals(R.AccountInfo.loginBackCorrect)) {
			return true;
		} else {
			JLog.writeerror( name + ",Login Fail," + mess);
			JOptionPane.showMessageDialog(null, "Log in Error:" + mess);
			return false;
		}
	}

	public boolean logOut( String name ) {
		try{
			outToServer.write( R.AccountInfo.logoutMess + name );
			outToServer.flush();
		} catch( IOException e ){
			JOptionPane.showMessageDialog(null, "�����˳���Ϣʧ�ܣ���");
			JLog.writeerror("Account:logIn:UnKnownHostException!");
			JLog.writeerror( e.getMessage() );
			return false;
		}
		String mess = null;
		try{
			mess = WaitMess();
		}catch( Exception  e ){
			JLog.writeerror("�ӷ����������ж�ȡ��Ϣʧ��");
			return false;
		}
		if (mess.equals(R.AccountInfo.logoutBackCorrect)) {
			return true;
		} else {
			JLog.writeerror( name + ",Logout Fail," + mess);
			JOptionPane.showMessageDialog(null, "Log out Error:" + mess);
			return false;
		}
	}

	
	private String WaitMess() throws HeadlessException, IOException{
		String mess = null;
		char[] c = new char[1024];
		int n = 0;
		long startMili = System.currentTimeMillis();//��ʱ��ʼ
		while ((n = inFromServer.read(c)) == -1) {
			if (System.currentTimeMillis() - startMili > R.AccountInfo.IntTimeEnd) {
				n = -1;
				JLog.writeerror("Account:Wait for Reply, Out of Time");
				JOptionPane.showMessageDialog( null, "�ȴ���������Ӧ��ʱ��");
				return null;
			}
		}
		if (n > 0) {
			mess = String.valueOf(c, 0, n);
			return mess;
		} else {
			return null;
		}
	}
	
	
	public String QFriend( String Friend ) {
		//����ѯ����Ϣ������������ߣ�����IP��ַ�����򷵻�null
		try {
			outToServer.write("q"+Friend);
			outToServer.flush();
		} catch( IOException e ){
			JOptionPane.showMessageDialog(null, "�����˳���Ϣʧ�ܣ���");
			JLog.writeerror("Account:logIn:UnKnownHostException!");
			JLog.writeerror( e.getMessage() );
			return null;
		}
		String mess = null;
		try{
			mess = WaitMess();
		}catch( Exception  e ){
			JLog.writeerror("�ӷ����������ж�ȡ��Ϣʧ��");
			return null;
		}
		mess = mess.trim();//ȥ�����ܴ��ڵĿո�
		if( R.IsIP(mess) ){
			return mess;
		} else{
			JLog.writeerror("QFriend:" +Friend+";"+ mess);
			return null;
		}
	}

	public void Close(){
		try{
			outToServer.close();
			inFromServer.close();
			sct.close();
		} catch ( IOException exception ) {
			
		}
	}
}
