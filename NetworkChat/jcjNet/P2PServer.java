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
		//建立监听port的服务器
		try{
			server = new ServerSocket(port);
		} catch( IOException e ){
			JOptionPane.showMessageDialog(null, "创建P2P服务器失败！无法进行P2P通讯！请尝试重新启动程序");
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
				JLog.writeerror("接受socket通讯出错！");
				JLog.writeerror(e.getMessage());
			}
		}
	}

}
