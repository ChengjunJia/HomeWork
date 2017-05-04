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
	private boolean chatAble;//是否可以进行聊天
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
		//当收到报文时，修正显示的名字
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
					//考虑父目录——不存在则创建
					new File( FileSavePath ).mkdirs();
				}
				int times = 1;
				while( tempsave.exists() ){
					//如果文件存在则加入新的序号
					tempsave = new File( FileSavePath ,file.getName()+"_"+times);
					times++;
				}
				try{
					//把文件保存到默认目录中——有重复的地方则覆盖掉
					tempsave.createNewFile();
					FileOutputStream fileoutput = new FileOutputStream(tempsave);
					FileInputStream fileinput = new FileInputStream(file);
					byte b[] = new byte[(int) file.length()];
					fileinput.read(b);
					fileoutput.write(b);
					fileoutput.close();
					fileinput.close();
				}catch(Exception e){
					JLog.writeerror("存储文件发生错误！");
					JLog.writeerror(e.getMessage());
				}
			} else {
				return;
			}
		}
	
	
	private void freshView( P2PMessage message, boolean send ){
		historyManage.AddToFile(message, send);		
		//更新显示
		StyledDocument docs = ContentView.getStyledDocument();
		SimpleAttributeSet attrset = new SimpleAttributeSet();
		StyleConstants.setFontSize(attrset, 14);
		StyleConstants.setFontFamily(attrset, "楷体");
		String messShow;
		try{
			if( send ){//针对发送和接收设置不同的显示格式
				StyleConstants.setAlignment(attrset, StyleConstants.ALIGN_RIGHT);
			} else {
				StyleConstants.setAlignment(attrset, StyleConstants.ALIGN_LEFT);
			}
			messShow = message.getContent();
			if( message.getMesType().equals(P2PMessage.MessageType.MESSAGE_FILE) ){
				//设置文件发送历史消息提示
				messShow = "[Software:]  A File\r\n";
				if( !send && !fileReceive.isSelected() ){
					messShow += "But it is rejected By you";
					P2PMessage message2 = PackChat("[Software]:Reject Receiving！]");
					chatp2p.SendObject(message2);
				}
			} else if( message.getMesType().equals(P2PMessage.MessageType.MESSAGE_HELO) ){
				messShow = "[Software:]  HELO";
			} else if( message.getMesType().equals(P2PMessage.MessageType.MESSAGE_HELOBACK) ){
				messShow = "[Software:]  HELO TOO";
			}
			if( messShow.startsWith("!!!") || messShow.startsWith("！！！")){
				//开始两个空格
				StyleConstants.setForeground(attrset, Color.RED);
				StyleConstants.setFontSize(attrset, 20);
			} else if( messShow.startsWith("!!") || messShow.startsWith("！！") ){
				//开始两个空格
				StyleConstants.setForeground(attrset, Color.RED);
			} else if( messShow.startsWith("!") || messShow.startsWith("！") ){
				//开始两个空格
				StyleConstants.setFontSize(attrset, 20);
			}
			messShow = "--------\r\n"+messShow + "\r\n"+"["+message.getSendTime()+"]\r\n--------\r\n";
			docs.insertString(docs.getLength(), messShow, attrset);
			//StyleConstants.setForeground(attrset, Color.BLACK);
			docs.setCharacterAttributes(docs.getLength()-messShow.length(), messShow.length(), attrset, true);
			docs.setParagraphAttributes(docs.getLength()-messShow.length(), messShow.length(), attrset, true);
			
		}catch( BadLocationException e ){
			JLog.writeerror("设置聊天记录的显示出现错误");
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
					//还可以聊天，则在退出的时候，发送退出消息
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
				JMenuItem Chat = new JMenuItem("测试在线");
				Chat.addActionListener(new ActionListener() {
					
					@Override
					public void actionPerformed(ActionEvent e) {
						if( chatAble ){
							P2PMessage mess = PackChat(null);
							mess.setMesType(P2PMessage.MessageType.MESSAGE_HELO);
							if( !chatp2p.SendObject(mess) ){
								JOptionPane.showMessageDialog(jDialog, "测试消息发送失败");
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
							//R.writelog("发送消息");
							if( !chatAble ){
								JOptionPane.showMessageDialog( jDialog, "对方不在线");
								return;
							} else if(  TextAreaInput.getText().equals("")  ){
								return;
							}
							String textToSend = TextAreaInput.getText().trim();
							P2PMessage mess = PackChat(textToSend);
							if( chatp2p.SendObject(mess) ){
								//聊天记录中更新该记录并更新显示情况
								freshView(mess,true);
								TextAreaInput.setText("");
							} else {
								JOptionPane.showMessageDialog(jDialog, "发送失败！请检查对方是否在线以及自身的网络连接；或者尝试重新发送");
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
								JOptionPane.showMessageDialog( jDialog, "对方不在线");
								return;
							}
							
							JFileChooser chooser = new JFileChooser();
							chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
							chooser.showDialog(new JLabel(), "选择");
							File file = chooser.getSelectedFile();
							if( file.isDirectory() ){
								JOptionPane.showMessageDialog(null, "请选择文件");
							}else if( file.isFile() ){
								P2PMessage mess = PackFile(file);
								if( chatp2p.SendObject(mess) ){
									//聊天记录中更新该记录并更新显示情况
									freshView(mess,true);
									TextAreaInput.setText("");
								} else {
									JOptionPane.showMessageDialog(jDialog, "发送失败！请检查对方是否在线以及自身的网络连接；或者尝试重新发送");
								}
							}
							
						}
					});
					panel.add(btnSendfile);
				}
				{
					//清理输入框
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
			fileReceive.setSelected(true);//默认可以接收文件
			fileReceive.addMouseListener(new MouseAdapter() {
				//接受文件选择按钮
				@Override
				public void mouseClicked(MouseEvent arg0) {
					if(fileReceive.isSelected()){
						JOptionPane.showMessageDialog(jDialog, "默认把文件接收到临时文件夹中");
					} else {
						int rec = JOptionPane.showConfirmDialog(jDialog, "是否确认不接收文件？", "关闭接收文件", JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
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
