package jcjUI;
//没有进行IP检查
import java.awt.BorderLayout;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.util.ArrayList;
import java.util.Vector;

import javax.swing.DefaultCellEditor;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import JManage.R;
import jcjSave.FriendManage;
import jcjSave.FriendRecord;

public class AdjustFriendList {
	
	private JDialog dialog;
	private JTable table;
	private FriendManage manage;
	private ArrayList<FriendRecord> friendlist;
	private String[] columnNames = new String[]{ "ID","IP","Name","Type","Other" };
	private String[][] rowData;
	private DefaultTableModel model;
	private JScrollPane scrollPane;
	
	public AdjustFriendList( FriendManage manage ){
		this.manage = manage;
		Initialize();
		dialog.setVisible(true);
	}
	
	public void Initialize(){
		dialog = new JDialog();
		dialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
		dialog.addWindowListener( new WindowAdapter() {
			
			public void windowClosing(java.awt.event.WindowEvent e) {
				int i = JOptionPane.showConfirmDialog(null, "是否就这样退出？", "退出", JOptionPane.OK_CANCEL_OPTION);
				if( i == JOptionPane.OK_OPTION ){
					int choice = JOptionPane.showConfirmDialog(null, "是否保存修改？", "退出", JOptionPane.OK_CANCEL_OPTION);
					if( choice == JOptionPane.OK_OPTION ){
						SaveToFile();
					}
					super.windowClosing(e);
					dialog.dispose();
				} else {
					
				}
			};
		});
		
		dialog.setBounds(100, 100, 600, 500);
		dialog.setResizable(false);
		dialog.setTitle("FriendList");
		
		
		
		scrollPane = new JScrollPane();
		
		Freshlist();
		dialog.setLayout( new BorderLayout());
		dialog.add( scrollPane, BorderLayout.CENTER );
		JButton saveButton = new JButton("save");
		saveButton.addMouseListener( new MouseAdapter() {
			//保存数据
			@Override
			public void mouseClicked(MouseEvent arg0) {
				//table.getCellEditor().stopCellEditing();
				SaveToFile();
				Freshlist();
				table.validate();
			}
		});
		
		JButton addRow = new JButton("Add");
		addRow.addMouseListener( new MouseAdapter() {
			@Override
			public void mouseClicked( MouseEvent arg0 ){
				model.addRow(new Vector<String>());
				table.revalidate();
			}
			
		});
		
		JButton deleteRow = new JButton("Delete");
		deleteRow.addMouseListener( new MouseAdapter() {
			@Override
			public void mouseClicked( MouseEvent arg0 ){
				int rowcount = table.getSelectedRow();
				//int rowcount = model.getRowCount()-1;
				if( rowcount>0 ){
					model.removeRow(rowcount);
					model.setRowCount(model.getRowCount()-1);
				}
				table.revalidate();
			}
		});
		
		JPanel panel = new JPanel();
		panel.add(saveButton); panel.add(addRow); panel.add(deleteRow);
		dialog.add(panel, BorderLayout.NORTH);
	}
	
	private void SaveToFile(){
		ArrayList<FriendRecord> listTofile = new ArrayList<FriendRecord>();
		
		int len = model.getRowCount();
		for( int i = 0; i<len;i++ ) {
			FriendRecord record = new FriendRecord();
			record.id = (String) model.getValueAt(i, 0);
			record.name = (String) model.getValueAt(i, 2);
			record.type = (String) model.getValueAt(i, 3);
			record.otherinfo = (String) model.getValueAt(i, 4);
			if( R.IsIP( (String) model.getValueAt(i, 1) )  ){
				record.ip = (String) model.getValueAt(i, 1);
			}else{
				record.ip = "";
			}
			listTofile.add(record);
		}
		
		if( !manage.SaveToFile(listTofile) ){
			JOptionPane.showMessageDialog(dialog,"保存失败！" );
		}else{
			JOptionPane.showMessageDialog(dialog,"保存成功！" );
		}
	}
	
	private void Freshlist(){
		//更新model中的存储数据
		friendlist = manage.ReadFromFile();
		int length = friendlist.size();
		rowData = new String[length][5];
		int i = 0 ;
		for( FriendRecord record:friendlist ){
			rowData[i][0] = record.id;
			rowData[i][1] = record.ip;
			rowData[i][2] = record.name;
			rowData[i][3] = record.type;
			rowData[i][4] = record.otherinfo;
			i++;
		}
		model = new DefaultTableModel(rowData, columnNames);
		table = new JTable(model);
		
		JComboBox<String> c = new JComboBox<String>();
		c.addItem( FriendRecord.FriendType.Good );
		c.addItem( FriendRecord.FriendType.Bad );
		c.addItem( FriendRecord.FriendType.Stranger );
		table.getColumnModel().getColumn(3).setCellEditor( new DefaultCellEditor(c) );

		table.setFillsViewportHeight(true);
		table.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
		scrollPane.setViewportView(table);
		
	}
	
}
