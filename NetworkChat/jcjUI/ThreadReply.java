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
//��Ӧ�����̵߳Ļ������
	public static void ServerAccept( P2PServer server, Socket s ){
		//Server��������Ӧ�յ�����Ӧ
		P2PChat chat = new P2PChat(s, true);
		P2PChatUI chatUI = new P2PChatUI(chat, null);
		chatUI.start();
	}
	
	public static void LogIn( Account a, String name ){
		//��¼name�ɹ���ʹ�õ�����ΪAccount
		JLog.writelog("��¼�ɹ�");
		R.AccountInfo.username = name;
		P2PServer p2pserver = new P2PServer(R.P2PChat.port);
		p2pserver.start();
		OnlineUI onlineUI = new OnlineUI(a, name);
		onlineUI.start();
	}
	
	public static void AdminLogIn( ){
		//����Ա��¼ʱ
		P2PServer p2pserver = new P2PServer(R.P2PChat.port);
		p2pserver.start();
		OnlineUI onlineUI = new OnlineUI(null,R.AccountInfo.username );
		onlineUI.start();
	}
	
	public static void ChatP2PByIP( String IP ){
		//����ͨ��IP��ַ
		Socket s;
		try{
			s = new Socket(IP,R.P2PChat.port );
		} catch( Exception e ){
			JOptionPane.showMessageDialog(null, "�޷�����");
			return ;
		}
		P2PChat chat = new P2PChat(s, false);
		P2PChatUI chatUI = new P2PChatUI(chat, null);
		chatUI.start();
	}
	
	public static void ChatP2PByName( String IP, String name ){
		//����ͨ��IP��ַ��name�����
		Socket s;
		try{
			s = new Socket(IP,R.P2PChat.port );
		} catch( Exception e ){
			JOptionPane.showMessageDialog(null, "�޷�����");
			return ;
		}
		P2PChat chat = new P2PChat(s, false);
		P2PChatUI chatUI = new P2PChatUI(chat, name);
		chatUI.start();
	}

	public static void P2PUIReceive( P2PChatUI chatui, P2PMessage mess ){
		//�յ�����Ϣ
		chatui.manageReceive(mess);
	}
}
