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
				//��������Է������ĵ��õ�socket���ӣ������ȴ���inputstream
				ois = new ObjectInputStream(new BufferedInputStream( chatSocket.getInputStream() ));
				oos = new ObjectOutputStream( chatSocket.getOutputStream() );
			} else {
				//������Լ�������������ӣ������Ƚ���outputstream
				//������ϣ�
				//�����д��룬�ҵ���һ�����硪��ΪʲôҪ�ı�������˳��MDZZ��
				oos = new ObjectOutputStream( chatSocket.getOutputStream() );
				ois = new ObjectInputStream(new BufferedInputStream( chatSocket.getInputStream() ));
			}
		}catch( IOException e ){
			JLog.writeerror("P2PChat:���ܴ��������ж�д����");
			JOptionPane.showMessageDialog(null, "��������ʧ�ܣ�");
		}
	}
	
	public boolean Close() {
		try{
			//�ر����졪���������е�����socket
			if( chatSocket != null ){
				ois.close();
				oos.close();
				chatSocket.close();
				return true;
			} else{
				return true;
			}
		}catch( IOException e){
			//����ʧ���򷵻�false
			return false;
		}
	}
	
	public boolean IsOnline(){
		//���socket�����Ƿ�����
		return (chatSocket!=null)&&(!chatSocket.isClosed())&&(chatSocket.isConnected());
	}
	
	public boolean SendObject( Object a ){
		//������Ϣ��������ʧ����д����־������false
		try{
			if( IsOnline() ){
				oos.writeObject(a);
				return true;
			} else{
				JOptionPane.showMessageDialog(null, "�Է��Ѿ��Ͽ����������");
				return false;
			}
		} catch( IOException e ){
			JLog.writeerror("P2P�������ݷ���ʧ��");
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
				JOptionPane.showMessageDialog(null, "���ӶϿ���");
				return null;
		}	
	}
	
}
