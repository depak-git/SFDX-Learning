/////////////////////////////////////////////////////////////////////////
// Class: UserQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public class UserQueries {
	public static Map<ID, User> getUserMapByID(){
		return new Map<ID, User>([SELECT id,
										   Username
									 FROM User
									 LIMIT 50000]);
	}
}