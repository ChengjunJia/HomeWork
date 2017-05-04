package jcjNet;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

import javax.swing.JOptionPane;

import JManage.JLog;

public class P2PChat {
	
	private Socket chatSocket = null;
	private ObjectInputStream ois = null;
	private ObjectOutputStream oos = null;
	
	public P2PChat( Socket chatSocket, boolean FromServer ){
		this.chatSocket = chatSocket;
		try{
			if( FromServer ){
				//如果是来自服务器的调用的socket连接，则首先创建inputstream
				ois = new ObjectInputStream(new BufferedInputStream( chatSocket.getInputStream() ));
				oos = new ObjectOutputStream( chatSocket.getOutputStream() );
			} else {
				//如果是自己主动发起的连接，则首先建立outputstream
				//妈的智障！
				//这两行代码，我调了一个下午——为什么要改变这两个顺序，MDZZ！
				oos = new ObjectOutputStream( chatSocket.getOutputStream() );
				ois = new ObjectInputStream(new BufferedInputStream( chatSocket.getInputStream() ));
			}
		}catch( IOException e ){
			JLog.writeerror("P2PChat:不能创建流进行读写操作");
			JOptionPane.showMessageDialog(null, "创建聊天失败！");
		}
	}
	
	public boolean Close() {
		try{
			//关闭聊天——清理所有的流和socket
			if( chatSocket != null ){
				ois.close();
				oos.close();
				chatSocket.close();
				return true;
			} else{
				return true;
			}
		}catch( IOException e){
			//清理失败则返回false
			return false;
		}
	}
	
	public boolean IsOnline(){
		//检查socket连接是否正常
		return (chatSocket!=null)&&(!chatSocket.isClosed())&&(chatSocket.isConnected());
	}
	
	public boolean SendObject( Object a ){
		//发送消息——发送失败则写入日志并返回false
		try{
			if( IsOnline() ){
				oos.writeObject(a);
				return true;
			} else{
				JOptionPane.showMessageDialog(null, "对方已经断开与你的连接");
				return false;
			}
		} catch( IOException e ){
			JLog.writeerror("P2P聊天内容发送失败");
			JLog.writeerror(e.getMessage());
			return false;
		}
	}
	
	public P2PMessage ReceiveObject() throws ClassNotFoundException, IOException{
		P2PMessage mess;
		if( IsOnline() ){
				mess = ( P2PMessage) ois.readObject();
				return mess;
		} else {
				JOptionPane.showMessageDialog(null, "连接断开！");
				return null;
		}	
	}
	
}
