package jcjUI;

import java.io.IOException;

import javax.swing.JOptionPane;

import jcjNet.P2PChat;
import jcjNet.P2PMessage;

public class WaitReceive extends Thread {
	private P2PChat chat;
	private P2PChatUI chatUI;
	private long lasttime = 0;
	
	public WaitReceive( P2PChat chat, P2PChatUI ui ){
		this.chat = chat; this.chatUI = ui;
	}
	
	public void run(){
		while(true){
			//���Ͻ�����Ϣ�������յ�����Ϣ�����ʵ��Ļ�Ӧ
			P2PMessage mess;
			if( chat.IsOnline() ){
				try {
					mess = chat.ReceiveObject();
				} catch (ClassNotFoundException | IOException e) {
					//��������϶�ʱ���ڷ�����ȡ�������˳��߳�
					//e.printStackTrace();
					if( lasttime == 0 || ( lasttime-System.currentTimeMillis() > 10000) ){
						lasttime = System.currentTimeMillis();
						continue;
					} else{
						chatUI.DisableChat();
						return ;
					}
				}
			} else{
				chatUI.DisableChat();
				return;
			}
			//JLog.writelog("Receive the Helo");
			if( mess!=null ){
				if( mess.getMesType().equals( P2PMessage.MessageType.MESSAGE_HELO ) ){
					//�յ����к�����Ϣ����ֱ�ӻ�Ӧ��Ӧ��Ϣ����
					
					P2PMessage messSend = new P2PMessage(P2PMessage.MessageType.MESSAGE_HELOBACK,
							mess.getGetter(), mess.getSender(), "");
					if( !chat.SendObject(messSend) ){
						JOptionPane.showMessageDialog(null, "���˺��У����Ƿ��ͻ�Ӧ��Ϣʧ�ܣ������ˣ�"+mess.getSender());
						continue;
					}
				} else if( mess.getMesType().equals( P2PMessage.MessageType.MESS_CLOSE ) ){
					//�յ�������ֹ�Ի�����Ϣ����ֹͣ�̼߳���
					chatUI.DisableChat();
					return ;
				} else {
					ThreadReply.P2PUIReceive(chatUI, mess);
				}
				//chatui.manageReceive(mess);
			}
		}
	}
}
