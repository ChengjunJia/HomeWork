package jcjUI;

import java.net.Socket;

import javax.swing.JOptionPane;

import JManage.JLog;
import JManage.R;
import jcjNet.Account;
import jcjNet.P2PChat;
import jcjNet.P2PMessage;
import jcjNet.P2PServer;

public final class ThreadReply {
//响应各种线程的互相调用
	public static void ServerAccept( P2PServer server, Socket s ){
		//Server调用来响应收到的响应
		P2PChat chat = new P2PChat(s, true);
		P2PChatUI chatUI = new P2PChatUI(chat, null);
		chatUI.start();
	}
	
	public static void LogIn( Account a, String name ){
		//登录name成功，使用的连接为Account
		JLog.writelog("登录成功");
		R.AccountInfo.username = name;
		P2PServer p2pserver = new P2PServer(R.P2PChat.port);
		p2pserver.start();
		OnlineUI onlineUI = new OnlineUI(a, name);
		onlineUI.start();
	}
	
	public static void AdminLogIn( ){
		//管理员登录时
		P2PServer p2pserver = new P2PServer(R.P2PChat.port);
		p2pserver.start();
		OnlineUI onlineUI = new OnlineUI(null,R.AccountInfo.username );
		onlineUI.start();
	}
	
	public static void ChatP2PByIP( String IP ){
		//呼叫通过IP地址
		Socket s;
		try{
			s = new Socket(IP,R.P2PChat.port );
		} catch( Exception e ){
			JOptionPane.showMessageDialog(null, "无法连接");
			return ;
		}
		P2PChat chat = new P2PChat(s, false);
		P2PChatUI chatUI = new P2PChatUI(chat, null);
		chatUI.start();
	}
	
	public static void ChatP2PByName( String IP, String name ){
		//呼叫通过IP地址和name的情况
		Socket s;
		try{
			s = new Socket(IP,R.P2PChat.port );
		} catch( Exception e ){
			JOptionPane.showMessageDialog(null, "无法连接");
			return ;
		}
		P2PChat chat = new P2PChat(s, false);
		P2PChatUI chatUI = new P2PChatUI(chat, name);
		chatUI.start();
	}

	public static void P2PUIReceive( P2PChatUI chatui, P2PMessage mess ){
		//收到了消息
		chatui.manageReceive(mess);
	}
}
