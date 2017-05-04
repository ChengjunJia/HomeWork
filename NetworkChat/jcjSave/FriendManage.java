package jcjSave;

import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import javax.swing.JOptionPane;

import JManage.JLog;

public class FriendManage {
	private File file;
	
	public FriendManage( String path, String filename ) {
		JLog.writelog(path);
		JLog.writelog(filename);
		file = new File( path,filename );
		if( !file.exists() ){
			file.mkdirs();
		}
		file = new File( path+'/'+filename, "FriendList.txt" );
		if( !file.exists() ){
			try {
				file.createNewFile();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				JLog.writeerror("Create the new File to Record the FriendList Filed!");
				JOptionPane.showMessageDialog(null, "好友列表为空，且无法创建好友列表！");
			}
		}
	}
	
	public ArrayList<FriendRecord> ReadFromFile(){
		ArrayList<FriendRecord> recordlist = new ArrayList<FriendRecord>();
		try {
			FileInputStream fis = new FileInputStream(file);
			InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
			BufferedReader fileIn = new BufferedReader( isr );
			String line;
			FriendRecord record;
			while(true){
				if( (line = fileIn.readLine()) !=null ){
					record = new FriendRecord();
					if( record.readFrom(line) ){
						recordlist.add( record );
					}
				}else {
					break;
				}
			}
			fileIn.close();
			isr.close();
			fis.close();
			return recordlist;
		} catch ( IOException e) {
			// TODO Auto-generated catch block
			JLog.writeerror("Create read the File which records the FriendList!");
			JOptionPane.showMessageDialog(null, "好友列表为空，且无法创建好友列表！");
			return null;
		}
	}
	
	public boolean SaveToFile( List<FriendRecord> recordlist ){
		try{
			FileOutputStream fos = new FileOutputStream(file);
			OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
			BufferedWriter bw = new BufferedWriter(osw);
			for(FriendRecord record:recordlist ){
				bw.write(record.ToString());
			}
			bw.close();
			osw.close();
			fos.close();
			return true;
		}catch( IOException e ){
			JLog.writeerror("Create write the File which records the FriendList!");
			JOptionPane.showMessageDialog(null, "无法把好友列表保存到文件");
			return false;
		}
	}
	
}
