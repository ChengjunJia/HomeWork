package jcjUI;

import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.EmptyBorder;

import JManage.JLog;
import JManage.R;
import jcjNet.Account;
import jcjSave.FriendManage;
import jcjSave.FriendRecord;

public class OnlineUI extends Thread{

	private JFrame frame;

	private JPanel contentPane;
	
	private CardLayout c1;
	private JPanel jphy1, jphy2, jphy3;
	private JButton jphy_jb1, jphy_jb2, jphy_jb3;
	private JScrollPane jphy_jsp;

	// 第二张卡片
	private JPanel jpmsr1, jpmsr2, jpmsr3;
	private JButton jpmsr_jb1, jpmsr_jb2, jpmsr_jb3;
	private JScrollPane jpmsr_jsp;

	// 第三张卡片
	private JPanel jphmd1, jphmd2, jphmd3;
	private JButton jphmd_jb1, jphmd_jb2, jphmd_jb3;
	private JScrollPane jphmd_jsp;

	private JButton[] jbls1;
	// 标记好友是否在线
	Boolean[] jbls1Flag;
	private JMenuBar menuBar;
	private JMenu menu;
	private JMenu menu_1;
	private JMenu menu_2;
	private JMenuItem quit;
	private JMenuItem change;
	private JMenuItem adjust;
	private JMenuItem call;
	private JMenuItem question;
	private JMenuItem freshlist;
	private JMenuItem deletefriend;
	
	private Account account;
	private String username;
	private ArrayList<FriendRecord> friendlist;
	FriendManage friendListManage;
	
	
	public OnlineUI( Account account , String username ){
		this.account = account;
		this.username = username;
		initialize();
		frame.setVisible(true);
	}
	
	public void run(){
		while(true){
			
		}
	}
	
	public void initialize() {
		frame = new JFrame(username);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setBounds(100, 100, 450, 300);
		frame.setResizable(false);
		
		menuBar = new JMenuBar();
		frame.setJMenuBar(menuBar);
		
		menu = new JMenu("\u8D26\u53F7");
		menuBar.add(menu);
		
		question = new JMenuItem("\u67E5\u8BE2\u5728\u7EBF\u60C5\u51B5");
		question.addActionListener( new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				if( e.getSource() == question ){
					//查询好友在线信息
					String ID = JOptionPane.showInputDialog("Input the ID questioned:");
					String answer = account.QFriend(ID);
					if( answer == null ){
						JOptionPane.showMessageDialog(frame,"不在线");
					} else {
						JOptionPane.showMessageDialog(frame,"在线，IP=" + answer);
					}
					
				}
			}
		});
			
		menu.add(question);
		
		change = new JMenuItem("\u5207\u6362\u8D26\u53F7");
		change.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				if( e.getSource() == change ){
					account.logOut(username);
					frame.dispose();
					account.Close();
					@SuppressWarnings("unused")
					LogUI logui = new LogUI();
				}
				
			}
		});
		menu.add(change);
		
		quit = new JMenuItem("\u9000\u51FA");
		quit.addActionListener( new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				if( e.getSource() == quit ){
					account.logOut( username );
					frame.dispose();
					account.Close();
					System.exit(0);
				}
			}
		});
		menu.add(quit);
		
		menu_1 = new JMenu("\u597D\u53CB\u7BA1\u7406");
		menuBar.add(menu_1);
		
		adjust = new JMenuItem("\u8C03\u6574");
		adjust.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				@SuppressWarnings("unused")
				AdjustFriendList adjust = new AdjustFriendList(friendListManage);
				
			}
		});
		menu_1.add(adjust);
		
		call = new JMenuItem("\u624B\u52A8\u53D1\u8D77\u804A\u5929");
		call.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				String aimIP;
				if( e.getSource() == call ){
					Object[] options = {"用户名","IP地址","取消"};
					int response = JOptionPane.showOptionDialog(null, "选择通讯方式:", "选择", JOptionPane.YES_OPTION, JOptionPane.QUESTION_MESSAGE, null, options,options[0]);
					if( response == 0 ){
						String inputValue = JOptionPane.showInputDialog("输入目标用户名：");
						String answer = account.QFriend(inputValue);
						if(answer == null ){
							JOptionPane.showMessageDialog(null, "无法通过服务器找到其IP！");
							return ;
						} else{
							aimIP = answer;
							ThreadReply.ChatP2PByName(aimIP, inputValue);		
						}
					} else if ( response == 1){
						String inputValue = JOptionPane.showInputDialog("输入目标IP地址：","127.0.0.1");
						if( !R.IsIP(inputValue) ){
							JOptionPane.showMessageDialog(null, "输入的地址不是IP！");
							return;
						} else {
							aimIP = inputValue;
							ThreadReply.ChatP2PByIP(aimIP);
						}
					} else {
						return;
					}
					//根据给定的IP地址尝试发起聊天
							
				}
			}
		});
		menu_1.add(call);
		
		freshlist = new JMenuItem("更新列表");
		freshlist.addActionListener(new ActionListener() {
			//更新好友列表
			@Override
			public void actionPerformed(ActionEvent e) {
				FreshFriendList();				
			}
		});
		menu_1.add(freshlist);
		
		deletefriend = new JMenuItem("\u5220\u9664\u597D\u53CB");
		deletefriend.addMouseListener(new MouseAdapter() {
			@Override	
			public void mouseClicked(MouseEvent e) {
				
				//JLog.writelog("Use the option 3");
			}
		});
	//	menu_1.add(deletefriend);
		
		menu_2 = new JMenu("\u8BBE\u7F6E");
		menuBar.add(menu_2);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(new BorderLayout(0, 0));
		frame.setContentPane(contentPane);
		{//第一张卡片
			jphy_jb1 = new JButton("我的好友");
			jphy_jb2 = new JButton("陌生人");
			jphy_jb2.addMouseListener(new MouseAdapter() {
				@Override
				public void mouseClicked(MouseEvent arg0) {
					c1.show(contentPane, "2");
				}
			});
			
			jphy_jb3 = new JButton("黑名单");
			jphy_jb3.addMouseListener(new MouseAdapter() {
				@Override
				public void mouseClicked(MouseEvent e) {
					c1.show(contentPane, "3");
				}
			});
			
			jphy1 = new JPanel(new BorderLayout());
			jphy2 = new JPanel(new GridLayout(0, 1, 4, 4));
		}
		// 处理第二张卡片
		{
				jpmsr_jb1 = new JButton("我的好友");
				jpmsr_jb1.addMouseListener(new MouseAdapter() {
					@Override
					public void mouseClicked(MouseEvent e) {
						c1.show(contentPane, "1");
					}
				});
				
				jpmsr_jb2 = new JButton("陌生人");
				jpmsr_jb3 = new JButton("黑名单");
				jpmsr_jb3.addMouseListener(new MouseAdapter() {
					@Override
					public void mouseClicked(MouseEvent e) {
						c1.show(contentPane, "3");
					}
				});
				
				jpmsr1 = new JPanel(new BorderLayout());
				
				jpmsr2 = new JPanel(new GridLayout(0, 1, 4, 4));
		}
		// 处理第三张卡片
		{
				jphmd_jb1 = new JButton("我的好友");
				jphmd_jb1.addMouseListener(new MouseAdapter() {
					@Override
					public void mouseClicked(MouseEvent e) {
						c1.show(contentPane, "2");
					}
				});
				
				jphmd_jb2 = new JButton("陌生人");
				jphmd_jb2.addMouseListener(new MouseAdapter() {
					@Override
					public void mouseClicked(MouseEvent e) {
						c1.show(contentPane, "2");
					}
				});
				
				jphmd_jb3 = new JButton("黑名单");
				jphmd_jb3.addMouseListener(new MouseAdapter() {
					@Override
					public void mouseClicked(MouseEvent e) {
						c1.show(contentPane, "3");
					}
				});
				jphmd1 = new JPanel(new BorderLayout());
				
				jphmd2 = new JPanel(new GridLayout(0, 1, 4, 4));
		}
		
		// 初始化好友列表
		FreshFriendList();
		
		jphy_jsp = new JScrollPane(jphy2);
		jphy3 = new JPanel(new GridLayout(2, 1));

		// 按钮加入jphy3
		jphy3.add(jphy_jb2);
		jphy3.add(jphy_jb3);

		// 加入jphy1,对jphy1初始化
		jphy1.add(jphy_jb1, "North");
		jphy1.add(jphy_jsp, "Center");
		jphy1.add(jphy3, "South");

		
		jpmsr_jsp = new JScrollPane(jpmsr2);
		jpmsr3 = new JPanel(new GridLayout(2, 1));

		// 按钮加入jpmsr3
		jpmsr3.add(jpmsr_jb1);
		jpmsr3.add(jpmsr_jb2);

		// 加入jpmsr1,对jpmsr1初始化
		jpmsr1.add(jpmsr3, "North");
		jpmsr1.add(jpmsr_jsp, "Center");
		jpmsr1.add(jpmsr_jb3, "South");

		// 初始化黑名单中的人
		jphmd_jsp = new JScrollPane(jphmd2);
		// 将jphmd2初始化20个黑名单
		jphmd3 = new JPanel(new GridLayout(3, 1));

		// 按钮加入jphmd3
		jphmd3.add(jphmd_jb1);
		jphmd3.add(jphmd_jb2);
		jphmd3.add(jphmd_jb3);

		// 加入jphmd1,对jphmd1初始化
		jphmd1.add(jphmd3, "North");
		jphmd1.add(jphmd_jsp, "Center");

		// 把JFrame设置为CardLayout布局
		c1 = new CardLayout();
		frame.getContentPane().setLayout(c1);
		// 加入JFrame
		frame.getContentPane().add(jphy1, "1");
		frame.getContentPane().add(jpmsr1, "2");
		frame.getContentPane().add(jphmd1, "3");

		// 设置窗体
		frame.setTitle( username );
		//setIconImage(new ImageIcon("images/qq.gif").getImage());
		frame.setSize(250, 500);
		frame.setLocationRelativeTo(null);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
	}
		
	
	public void FreshFriendList(){
		JLog.writelog(R.SaveInfo.RootPath);
		friendListManage = new FriendManage(R.SaveInfo.RootPath, username);
		friendlist = friendListManage.ReadFromFile();
		jbls1 = new JButton[friendlist.size()];
		int i = 0;
		jphy2.removeAll();
		jpmsr2.removeAll();
		jphmd2.removeAll();
		for( FriendRecord record:friendlist ){
			jbls1[i] = new JButton(record.name );
			String ipfresh;
			if( (ipfresh=account.QFriend(record.id)) !=null  ){
				//更新IP地址
				record.ip = ipfresh;
				jbls1[i].setEnabled(true);
			} else {
				jbls1[i].setEnabled(false);
			}
			
			if(record.type.equals(FriendRecord.FriendType.Good)){
				//好友列表增加
				jphy2.add(jbls1[i]);
			} else if( record.type.equals(FriendRecord.FriendType.Stranger) ){
				//陌生人列表增加
				jpmsr2.add(jbls1[i]);
			} else if( record.type.equals(FriendRecord.FriendType.Bad) ) {
				jphmd2.add(jbls1[i]);
			}
			jbls1[i].addMouseListener(new MouseAdapter() {
				
				@Override
				public void mouseClicked(MouseEvent arg0) {
					if(arg0.getClickCount() == 2){
						//双击时弹出对话框
						int i =0 ;
						while( jbls1[i] != arg0.getSource() && i<friendlist.size()  ){
							i++;
						}
						ThreadReply.ChatP2PByName( friendlist.get(i).ip,friendlist.get(i).name );
					}
					
				}
			});
			i++;
		}
		if( !friendListManage.SaveToFile(friendlist) ){
			JOptionPane.showMessageDialog(null, "保存好友列表失败！");
		}
	}
}
