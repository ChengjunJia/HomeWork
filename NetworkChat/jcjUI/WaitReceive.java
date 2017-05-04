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
			//不断接受消息，根据收到的消息进行适当的回应
			P2PMessage mess;
			if( chat.IsOnline() ){
				try {
					mess = chat.ReceiveObject();
				} catch (ClassNotFoundException | IOException e) {
					//如果连续较短时间内发生读取错误，则退出线程
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
					//收到打招呼的消息——直接回应对应消息即可
					
					P2PMessage messSend = new P2PMessage(P2PMessage.MessageType.MESSAGE_HELOBACK,
							mess.getGetter(), mess.getSender(), "");
					if( !chat.SendObject(messSend) ){
						JOptionPane.showMessageDialog(null, "有人呼叫，但是发送回应消息失败，呼叫人："+mess.getSender());
						continue;
					}
				} else if( mess.getMesType().equals( P2PMessage.MessageType.MESS_CLOSE ) ){
					//收到的是终止对话的消息——停止线程即可
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
