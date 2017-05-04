package jcjNet;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

import javax.swing.JOptionPane;

import JManage.JLog;
import jcjUI.ThreadReply;

public class P2PServer extends Thread {
	private ServerSocket server;
	public P2PServer( int port ){
		//��������port�ķ�����
		try{
			server = new ServerSocket(port);
		} catch( IOException e ){
			JOptionPane.showMessageDialog(null, "����P2P������ʧ�ܣ��޷�����P2PͨѶ���볢��������������");
			JLog.writeerror( "Create P2Pserver False!");
		}
	}
	
	public void run(){
		Socket socket = null;
		while( true ){
			try {
				socket = server.accept();
				ThreadReply.ServerAccept(this, socket);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				JLog.writeerror("����socketͨѶ����");
				JLog.writeerror(e.getMessage());
			}
		}
	}

}
