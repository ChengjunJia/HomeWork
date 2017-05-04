package jcjUI;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.ComponentOrientation;
import java.awt.Dimension;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;

import JManage.R;
import jcjNet.Account;

public class LogUI {
	private JFrame frame;
	private JTextField name;
	private JPasswordField pwdNet;
	
	public LogUI(){
		initialize();
		frame.setVisible(true);
	}
	
	
	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setTitle("\u767B\u5F55");
		frame.setSize(new Dimension(350, 210));
		frame.setResizable(false);
		
		frame.setBounds(100, 100, 355, 220);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		JPanel panel = new JPanel();
		frame.getContentPane().add(panel, BorderLayout.SOUTH);
		
		JButton btnNewButton = new JButton("\u767B\u5F55");
		btnNewButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				String username = new String( name.getText().trim() );
				String pString = new String( pwdNet.getPassword() );
				if( username.equals("admin") && pString.equals("admin") ){
					//当使用管理员登录时....
					ThreadReply.AdminLogIn();
				}else if(pString.equals(R.AccountInfo.psd)){
					Account account = new Account();
					ThreadReply.LogIn(account, username );
					frame.dispose();
				}else{
					Account account = new Account();
					if( !account.logIn(username,pString) ){
					//	JOptionPane.showMessageDialog(null, "请检查网络、用户名、密码等信息！","登录错误！",JOptionPane.WARNING_MESSAGE);
					} else {
						ThreadReply.LogIn(account, username );
						frame.dispose();
					}	
				}
								
			}
		});
		panel.add(btnNewButton);
		
		Component horizontalStrut = Box.createHorizontalStrut(20);
		panel.add(horizontalStrut);
		
		Component horizontalStrut_1 = Box.createHorizontalStrut(20);
		panel.add(horizontalStrut_1);
		
		JButton btnNewButton_1 = new JButton("\u9000\u51FA");
		btnNewButton_1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				int option = JOptionPane.showConfirmDialog(frame, "是否退出？","退出", JOptionPane.YES_NO_OPTION,JOptionPane.WARNING_MESSAGE);
				if( option == JOptionPane.YES_OPTION ){
					//确认退出程序
					System.exit(0);
				}
			}
		});
		panel.add(btnNewButton_1);
		
		JPanel panel_2 = new JPanel();
		frame.getContentPane().add(panel_2, BorderLayout.CENTER);
		
		JLabel lblNewLabel_1 = new JLabel("\u5B66\u53F7\uFF1A",JLabel.CENTER);
		lblNewLabel_1.setBounds(77, 50, 40, 20);
		lblNewLabel_1.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
		lblNewLabel_1.setLabelFor(name);
		
		name = new JTextField(20);
		name.setBounds(127, 50, 150, 20);
		name.setPreferredSize(new Dimension(30, 20));
		name.setColumns(20);
		
		JLabel lblNewLabel = new JLabel("\u5BC6\u7801\uFF1A",JLabel.CENTER);
		lblNewLabel.setBounds(77, 100, 40, 20);
		lblNewLabel.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
		lblNewLabel.setAlignmentX(Component.RIGHT_ALIGNMENT);
		panel_2.setLayout(null);
		panel_2.add(lblNewLabel_1);
		panel_2.add(name);
		panel_2.add(lblNewLabel);
		
		pwdNet = new JPasswordField();
		pwdNet.setText("net2016");
		pwdNet.setBounds(127, 100, 150, 20);
		
		name.setText("2014011552");
		panel_2.add(pwdNet);
	}
	
}
