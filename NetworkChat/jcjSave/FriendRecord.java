package jcjSave;

import java.io.Serializable;

public class FriendRecord implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 3716823887747462034L;
	
	public String id;
	public String ip;
	public String name;
	public String type;
	public String otherinfo;
	
	public FriendRecord() { }
	public FriendRecord( String id,String ip, String name, String otherinfo){
		this.id = id; this.ip = ip; this.name= name; this.otherinfo = otherinfo;
	}
	
	public String ToString(){
		String result;
		char split = '\t';
		result = id+split+ip+split+name+split+type+split+otherinfo+'\r'+'\n';
		return result;
	}
	
	public boolean readFrom(String line){
		//line÷–≤ª∫¨”–\r\n
		String[] lists = line.split("\t");
		if( lists.length < 4 ){
			return false;
		} else{
			id = lists[0];
			ip = lists[1];
			name = lists[2];
			type = lists[3];
			if( lists.length == 5){
				otherinfo = lists[4];
			}else{
				otherinfo = null;
			}
			return true;
		} 
	}
	
	public static class FriendType{
		public static String Good = "Good Friend";
		public static String Bad = "Black Friend";
		public static String Stranger = "Unknowned person";
	}
	
	
}
