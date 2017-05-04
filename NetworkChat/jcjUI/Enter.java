package jcjUI;

import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

import JManage.JLog;
import JManage.R;
import jcjSave.IniManage;

public class Enter {
	public static void main( String args[] ){
		
		@SuppressWarnings("unused")
		IniManage ini = new IniManage();		
		JLog.SetLog(R.LogInfo.Logname, R.LogInfo.filehandlename);
		
		try {
			UIManager.setLookAndFeel( R.skin.skin0 );
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (UnsupportedLookAndFeelException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		@SuppressWarnings("unused")
		LogUI l = new LogUI();
	}
}
