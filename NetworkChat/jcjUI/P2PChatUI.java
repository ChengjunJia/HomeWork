package jcjUI;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextPane;
import javax.swing.ScrollPaneConstants;
import javax.swing.text.BadLocationException;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;

import JManage.JLog;
import JManage.R;
import jcjNet.P2PChat;
import jcjNet.P2PMessage;
import jcjSave.ChatHistoryManage;

public class P2PChatUI extends Thread {
	private JDialog jDialog ;
	private JPanel contentPanel;
	private JTextArea TextAreaInput;
	private JPanel panel;
	
	private JTextPane ContentView;	
	private JScrollPane chatlist;
	private JRadioButton fileReceive;
	
	private String chatname;
	private P2PChat chatp2p;
	private ChatHistoryManage historyManage;
	private String FileSavePath;
	private boolean chatAble;//�Ƿ���Խ�������
	private WaitReceive wait;

	public P2PChatUI( P2PChat chat, ChatHistoryManage manage, String chatname, String filesave ){
		chatAble = true;
		chatp2p = chat; this.chatname = chatname; this.historyManage = manage; this.FileSavePath = filesave;  
		initialize();
		jDialog.setVisible(true);
	}
	
	public P2PChatUI( P2PChat chat, String chatname ){
		chatAble = true;
		chatp2p = chat; this.chatname = chatname; 
		this.FileSavePath = R.SaveInfo.RootPath +"/" + R.AccountInfo.username + "/"+R.SaveInfo.FileDirectory;
		if( chatname == null ){
			this.historyManage = new ChatHistoryManage( "Accept" ); 
		} else {
			this.FileSavePath = this.FileSavePath + "/"+ chatname ;
			this.historyManage = new ChatHistoryManage( chatname ); 
		}
		initialize();
		jDialog.setVisible(true);
	}
	
	public void run(){
		wait = new WaitReceive(chatp2p, this);
		wait.start();
	}
	
	
	public void DisableChat(){ chatAble = false; wait.interrupt();	}
	
	public void manageReceive( P2PMessage message ){
		freshView(message,false);
		//���յ�����ʱ��������ʾ������
			if( chatname == null ){
				chatname = message.getSender();
				historyManage = new ChatHistoryManage(chatname);
				this.FileSavePath = this.FileSavePath + "/"+ chatname ;
				jDialog.setTitle(chatname);
			}
			
			if( message.getMesType().equals(P2PMessage.MessageType.MESSAGE_FILE) )
			if( fileReceive.isSelected() ){
				File file = message.getFile();
				File tempsave = new File(FileSavePath,file.getName());
				if( !new File( FileSavePath ).isDirectory() ){
					//���Ǹ�Ŀ¼�����������򴴽�
					new File( FileSavePath ).mkdirs();
				}
				int times = 1;
				while( tempsave.exists() ){
					//����ļ�����������µ����
					tempsave = new File( FileSavePath ,file.getName()+"_"+times);
					times++;
				}
				try{
					//���ļ����浽Ĭ��Ŀ¼�С������ظ��ĵط��򸲸ǵ�
					tempsave.createNewFile();
					FileOutputStream fileoutput = new FileOutputStream(tempsave);
					FileInputStream fileinput = new FileInputStream(file);
					byte b[] = new byte[(int) file.length()];
					fileinput.read(b);
					fileoutput.write(b);
					fileoutput.close();
					fileinput.close();
				}catch(Exception e){
					JLog.writeerror("�洢�ļ���������");
					JLog.writeerror(e.getMessage());
				}
			} else {
				return;
			}
		}
	
	
	private void freshView( P2PMessage message, boolean send ){
		historyManage.AddToFile(message, send);		
		//������ʾ
		StyledDocument docs = ContentView.getStyledDocument();
		SimpleAttributeSet attrset = new SimpleAttributeSet();
		StyleConstants.setFontSize(attrset, 14);
		StyleConstants.setFontFamily(attrset, "����");
		String messShow;
		try{
			if( send ){//��Է��ͺͽ������ò�ͬ����ʾ��ʽ
				StyleConstants.setAlignment(attrset, StyleConstants.ALIGN_RIGHT);
			} else {
				StyleConstants.setAlignment(attrset, StyleConstants.ALIGN_LEFT);
			}
			messShow = message.getContent();
			if( message.getMesType().equals(P2PMessage.MessageType.MESSAGE_FILE) ){
				//�����ļ�������ʷ��Ϣ��ʾ
				messShow = "[Software:]  A File\r\n";
				if( !send && !fileReceive.isSelected() ){
					messShow += "But it is rejected By you";
					P2PMessage message2 = PackChat("[Software]:Reject Receiving��]");
					chatp2p.SendObject(message2);
				}
			} else if( message.getMesType().equals(P2PMessage.MessageType.MESSAGE_HELO) ){
				messShow = "[Software:]  HELO";
			} else if( message.getMesType().equals(P2PMessage.MessageType.MESSAGE_HELOBACK) ){
				messShow = "[Software:]  HELO TOO";
			}
			if( messShow.startsWith("!!!") || messShow.startsWith("������")){
				//��ʼ�����ո�
				StyleConstants.setForeground(attrset, Color.RED);
				StyleConstants.setFontSize(attrset, 20);
			} else if( messShow.startsWith("!!") || messShow.startsWith("����") ){
				//��ʼ�����ո�
				StyleConstants.setForeground(attrset, Color.RED);
			} else if( messShow.startsWith("!") || messShow.startsWith("��") ){
				//��ʼ�����ո�
				StyleConstants.setFontSize(attrset, 20);
			}
			messShow = "--------\r\n"+messShow + "\r\n"+"["+message.getSendTime()+"]\r\n--------\r\n";
			docs.insertString(docs.getLength(), messShow, attrset);
			//StyleConstants.setForeground(attrset, Color.BLACK);
			docs.setCharacterAttributes(docs.getLength()-messShow.length(), messShow.length(), attrset, true);
			docs.setParagraphAttributes(docs.getLength()-messShow.length(), messShow.length(), attrset, true);
			
		}catch( BadLocationException e ){
			JLog.writeerror("���������¼����ʾ���ִ���");
			JLog.writeerror(e.getMessage());
		}
		//chatlist.setViewportView(contentPanel);
	}
	
	private void initialize () {
		jDialog =new JDialog();
		
		jDialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
		jDialog.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				P2PMessage closemess = PackChat(null);
				closemess.setMesType(P2PMessage.MessageType.MESS_CLOSE);
				if( chatAble ){
					//���������죬�����˳���ʱ�򣬷����˳���Ϣ
					chatp2p.SendObject(closemess);
				}
				chatp2p.Close();
				jDialog.dispose();
				super.windowClosing(e);
			}
		});
		jDialog.setBounds(100, 100, 600, 600);
		jDialog.setResizable(false);
		jDialog.setTitle( chatname );
		jDialog.getContentPane().setLayout(new BorderLayout());
		{
			//Menu setting
			JMenuBar menuBar = new JMenuBar();
			jDialog.getContentPane().add(menuBar, BorderLayout.NORTH);
			{
				JMenuItem Chat = new JMenuItem("��������");
				Chat.addActionListener(new ActionListener() {
					
					@Override
					public void actionPerformed(ActionEvent e) {
						if( chatAble ){
							P2PMessage mess = PackChat(null);
							mess.setMesType(P2PMessage.MessageType.MESSAGE_HELO);
							if( !chatp2p.SendObject(mess) ){
								JOptionPane.showMessageDialog(jDialog, "������Ϣ����ʧ��");
								return;
							}
							freshView(mess, true);
						}	
					}
				});
				menuBar.add(Chat);
			}
			{
				JMenu View = new JMenu("\u67E5\u770B");
				menuBar.add(View);
				{
					JMenuItem History = new JMenuItem("\u804A\u5929\u8BB0\u5F55");
					History.addActionListener( new ActionListener() {
						
						@Override
						public void actionPerformed(ActionEvent e) {
							historyManage.ShowHistory();	
						}
					});
					View.add(History);
				}
				{
					JMenuItem FileHistory = new JMenuItem("\u4F20\u8F93\u6587\u4EF6");
					FileHistory.addActionListener(new ActionListener() {
						
						@Override
						public void actionPerformed(ActionEvent e) {
							JFileChooser fileChooser = new JFileChooser();
							fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
							fileChooser.setDialogTitle("Save File");
							fileChooser.setCurrentDirectory( new File(FileSavePath) );
							fileChooser.setMultiSelectionEnabled(false);
							fileChooser.showSaveDialog( fileChooser );
							if( fileChooser.getSelectedFile() == null ){
								return ;
							}
						}
					});
					View.add(FileHistory);
				}
			}
		}
		{
			chatlist = new JScrollPane();
			chatlist.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
			jDialog.getContentPane().add(chatlist, BorderLayout.CENTER);
			{
				contentPanel = new JPanel();
				contentPanel.setLayout(new GridLayout(0,1,0,0));
				{
					ContentView = new JTextPane();
					ContentView.setEditable(false);
					ContentView.setOpaque(false);
					contentPanel.add(ContentView);
				}
				chatlist.setViewportView(contentPanel);
			}
		}
				
		{
			JPanel buttonPane = new JPanel();
			jDialog.getContentPane().add(buttonPane, BorderLayout.SOUTH);
			{
				TextAreaInput =  new JTextArea();
				TextAreaInput.setColumns(10);
				TextAreaInput.setLineWrap(true);
				TextAreaInput.setWrapStyleWord(true);
			}
			{
				panel = new JPanel();
				{
					JButton okButton = new JButton("Send");
					okButton.addMouseListener(new MouseAdapter() {
						@Override
						public void mouseClicked(MouseEvent arg0) {
							//Click the button:Send to clear the input
							//R.writelog("������Ϣ");
							if( !chatAble ){
								JOptionPane.showMessageDialog( jDialog, "�Է�������");
								return;
							} else if(  TextAreaInput.getText().equals("")  ){
								return;
							}
							String textToSend = TextAreaInput.getText().trim();
							P2PMessage mess = PackChat(textToSend);
							if( chatp2p.SendObject(mess) ){
								//�����¼�и��¸ü�¼��������ʾ���
								freshView(mess,true);
								TextAreaInput.setText("");
							} else {
								JOptionPane.showMessageDialog(jDialog, "����ʧ�ܣ�����Է��Ƿ������Լ�������������ӣ����߳������·���");
							}	
						}
					});
					panel.add(okButton);
					//okButton.setActionCommand("OK");
					jDialog.getRootPane().setDefaultButton(okButton);
				}
				{
					JButton btnSendfile = new JButton("SendFile");
					btnSendfile.addMouseListener(new MouseAdapter() {
						@Override
						public void mouseClicked(MouseEvent e) {
							if( !chatAble ){
								JOptionPane.showMessageDialog( jDialog, "�Է�������");
								return;
							}
							
							JFileChooser chooser = new JFileChooser();
							chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
							chooser.showDialog(new JLabel(), "ѡ��");
							File file = chooser.getSelectedFile();
							if( file.isDirectory() ){
								JOptionPane.showMessageDialog(null, "��ѡ���ļ�");
							}else if( file.isFile() ){
								P2PMessage mess = PackFile(file);
								if( chatp2p.SendObject(mess) ){
									//�����¼�и��¸ü�¼��������ʾ���
									freshView(mess,true);
									TextAreaInput.setText("");
								} else {
									JOptionPane.showMessageDialog(jDialog, "����ʧ�ܣ�����Է��Ƿ������Լ�������������ӣ����߳������·���");
								}
							}
							
						}
					});
					panel.add(btnSendfile);
				}
				{
					//���������
					JButton cancelButton = new JButton("Clear");
					cancelButton.addMouseListener(new MouseAdapter() {
						@Override
						public void mouseClicked(MouseEvent e) {
							//location to control ---Clear Button
							TextAreaInput.setText("");
						}
					});
					panel.add(cancelButton);
					//cancelButton.setActionCommand("Cancel");
				}
			}
			buttonPane.setLayout(new BorderLayout(0, 0));
			buttonPane.add(TextAreaInput, BorderLayout.CENTER);
			buttonPane.add(panel, BorderLayout.SOUTH);
		}
		{
			fileReceive = new JRadioButton("\u662F\u5426\u63A5\u53D7\u6587\u4EF6");
			fileReceive.setSelected(true);//Ĭ�Ͽ��Խ����ļ�
			fileReceive.addMouseListener(new MouseAdapter() {
				//�����ļ�ѡ��ť
				@Override
				public void mouseClicked(MouseEvent arg0) {
					if(fileReceive.isSelected()){
						JOptionPane.showMessageDialog(jDialog, "Ĭ�ϰ��ļ����յ���ʱ�ļ�����");
					} else {
						int rec = JOptionPane.showConfirmDialog(jDialog, "�Ƿ�ȷ�ϲ������ļ���", "�رս����ļ�", JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
						if( rec == JOptionPane.YES_OPTION ){
							
						} else{
							fileReceive.setSelected(true);
						}
					}
				}
			});
			panel.add(fileReceive);
		}
	}
	
	public boolean TestOnline(){
		
		
		
		return false;
	}
	
	private P2PMessage PackChat( String content ){
		P2PMessage mess = new P2PMessage(P2PMessage.MessageType.MESSAGE_CHAT, R.AccountInfo.username, chatname, content);
		return mess;
	}
	
	private P2PMessage PackFile( File file ){
		P2PMessage mess = new P2PMessage(P2PMessage.MessageType.MESSAGE_FILE, R.AccountInfo.username, chatname, file);
		return mess;
	}
	
}
