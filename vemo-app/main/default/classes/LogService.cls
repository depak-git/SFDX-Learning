public with sharing class LogService {
	private static List<Log__c> logs = new List<Log__c>();
	public static void fine(String str, String relatedTo){
		logs.add(new Log__c(Log__c = str.left(2000),
							SecondsLogged__c = DateTime.now().second(),
							RelatedTo__c = relatedTo,			
							DateTimeLogged__c = DateTime.now(),
							MillisecondsLogged__c = DateTime.now().millisecond()));
	}	
	public static void debug(String str, String relatedTo){
		logs.add(new Log__c(Log__c = str.left(2000),
							SecondsLogged__c = DateTime.now().second(),
							RelatedTo__c = relatedTo,			
							DateTimeLogged__c = DateTime.now(),
							MillisecondsLogged__c = DateTime.now().millisecond()));
	}
	public static void critical(String str, String relatedTo){
		logs.add(new Log__c(Log__c = str.left(2000),
							RelatedTo__c = relatedTo,
							DateTimeLogged__c = DateTime.now(),
							SecondsLogged__c = DateTime.now().second(),
							MillisecondsLogged__c = DateTime.now().millisecond(),
							Critical__c = true));
	}
	public static void writeLogs(){
		if(logs.size()>0){
			if(GlobalSettings.getSettings().debugLevel != 'NONE' && String.isNotEmpty(GlobalSettings.getSettings().debugLevel)){
				insert logs;				
			}
			logs.clear();
		}
	}
	public static void purgeLogs(){
		delete [select id from Log__c];
	}
}