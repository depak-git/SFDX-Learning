public with sharing class GlobalUtil {
	public GlobalUtil() {
		
	}

	public static final String CASE_RECTYPELBL_CERTIFICATION = 'Certification';
	public static final String CASE_RECTYPELBL_DEFAULT = 'Default';

	//maps to hold the record type info	
	private static Map<String, Schema.SObjectType> globalDescribe;
	private static Map<String,Map<Id,Schema.RecordTypeInfo>> recordTypesById = new Map<String,Map<Id,Schema.RecordTypeInfo>>();
	private static Map<String,Map<String,Schema.RecordTypeInfo>> recordTypesByName = new Map<String,Map<String,Schema.RecordTypeInfo>>();
	private static Map<String, String> profileMap = new Map<String,String>();

	private static Map<ID, String> queueByID = new Map<ID,String>();
	private static Map<String, ID> queueByDeveloperName = new Map<String, ID>();


    public static String createGUID() {
        String kHexChars = '0123456789abcdef';
        String returnValue = '';
        Integer nextByte = 0;
        for (Integer i=0; i<16; i++) {
            if (i==4 || i==6 || i==8 || i==10) 
                returnValue += '-';
            nextByte = (Math.round(Math.random() * 255)-128) & 255;
            if (i==6) {
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
            if (i==8) {
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }
            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }
        returnValue += ':' + UserInfo.getUserID();
        return returnValue;
    }
    private static String getCharAtIndex(String str, Integer index) {
        if (str == null) return null;
        if (str.length() <= 0) return str;    
        if (index == str.length()) return null;    
        return str.substring(index, index+1);
    }
	
    /////////////////////////////////////////////////////////////////////////
    //Method: fillMapsForRecordTypeObject
    /////////////////////////////////////////////////////////////////////////
	private static void fillMapsForRecordTypeObject(string objectName) {
		// get the object map the first time
		if (globalDescribe==null) {
			globalDescribe = Schema.getGlobalDescribe();
		}
		// get the object description
		if (globalDescribe.containsKey(objectName)) {
			Schema.DescribeSObjectResult describe = globalDescribe.get(objectName).getDescribe();
			recordTypesByName.put(objectName, describe.getRecordTypeInfosByName());
			recordTypesById.put(objectName, describe.getRecordTypeInfosById());
		}
	}

	public static Id getRecordTypeIdByLabelName(String objectName, String labelName) {
		// make sure we have this object's record types mapped
		if (!recordTypesByName.containsKey(objectName)){
			fillMapsForRecordTypeObject(objectName);		
		}

		// now grab and return the requested id
		Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
		if (rtMap != null && rtMap.containsKey(labelName)) {
			return rtMap.get(labelName).getRecordTypeId();
		} else {
			return null;
		}
	}
	public static String getRecordTypeLabelNameByID(String objectName, Id recordTypeId) {
	// make sure we have this object's record types mapped
		if (!recordTypesById.containsKey(objectName)){
			fillMapsForRecordTypeObject(objectName);		
		}

		// now grab and return the requested id
		Map<Id,Schema.RecordTypeInfo> rtMap = recordTypesById.get(objectName);
		if (rtMap != null && rtMap.containsKey(recordTypeId)) {
			return rtMap.get(recordTypeId).getName();
		} else {
			return null;
		}
	}


    /////////////////////////////////////////////////////////////////////////
    //Method: fillMapsForQueue
    /////////////////////////////////////////////////////////////////////////
	private static void fillMapsForQueue() {

		Map<ID, Group> grpByID = new Map<ID, Group>([SELECT id, DeveloperName, Name, Type FROM Group where Type = 'Queue']);
		for(Group grp : grpByID.values()){
			queueByID.put(grp.id, grp.DeveloperName);
			queueByDeveloperName.put(grp.DeveloperName, grp.id);
		}
system.debug('queueByID:'+queueByID);
system.debug('queueByDeveloperName:'+queueByDeveloperName);
	}


	public static Id getQueueId(String queueDeveloperName) {
		if (queueByDeveloperName.size() == 0){
			fillMapsForQueue();		
		}

		if(queueByDeveloperName.containsKey(queueDeveloperName)){
			return queueByDeveloperName.get(queueDeveloperName);
		} else {
			return null;
		}
	}
	public static String getQueueDeveloperName(Id queueId) {
		if (queueByID.size() == 0){
			fillMapsForQueue();		
		}

		if(queueByID.containsKey(queueId)){
			return queueByID.get(queueId);
		} else {
			return null;
		}
	}

	public static List<String> getPicklistValues(String objNameStr, String fieldName){ 

		List<String> picklistValues =new List<String>();
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objNameStr);//From the Object Api name retrieving the SObject
		Sobject sObjName = targetType.newSObject();
		Schema.sObjectType sobjType = sObjName.getSObjectType(); //grab the sobject that was passed
		Schema.DescribeSObjectResult sobjDescribe = sobjType.getDescribe(); //describe the sobject
		Map<String, Schema.SObjectField> fieldMap = sobjDescribe.fields.getMap(); //get a map of fields for the passed sobject
		List<Schema.PicklistEntry> picklistEntries = fieldMap.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
		System.debug('picklistEntries:'+picklistEntries);
		for (Schema.PicklistEntry pl : picklistEntries) { //for all values in the picklist list
			if(pl.isActive()){ //only return active values
				picklistValues.add(pl.getValue());//add the value  to our final list		
			}
		}
		return picklistValues;
	}

	public static Map<String, String> getCountryLabelByValueMap(){ 
		//This requires country pick lists to be ON
		Map<String, String> countryLabelByValue = new Map<String, String>();
		Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
		List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
		System.debug('picklistEntries:'+picklistEntries);
		for( Schema.PicklistEntry pl : picklistEntries){
			if(pl.isActive()){
				countryLabelByValue.put(pl.getValue(), pl.getLabel());
			}
		}
		return countryLabelByValue;
	}
	public static String getCountryLabelByValue(String value){ 
		//This requires country pick lists to be ON
		Map<String, String> countryLabelByValue = getCountryLabelByValueMap();
		return countryLabelByValue.get(value);
	}
	public static Map<String, String> getStateLabelByValueMap(){ 
		//This requires state pick lists to be ON
		Map<String,String> stateLabelByValue = new Map<String,String>();
		Schema.DescribeFieldResult fieldResult = User.statecode.getDescribe();
		List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
		System.debug('picklistEntries:'+picklistEntries);
		for( Schema.PicklistEntry pl : picklistEntries){
			if(pl.isActive()){
				stateLabelByValue.put(pl.getValue(), pl.getLabel());				
			}
		}		
		return stateLabelByValue;
	}
	public static String getStateLabelByValue(String value){ 
		//This requires country pick lists to be ON
		Map<String, String> stateLabelByValue = getStateLabelByValueMap();
		return stateLabelByValue.get(value);
	}		

	public static Boolean isWeekendDay(Date dateParam){
		Boolean result = false;
		system.debug('dateParam = '+dateParam); 
		//Recover the day of the week
		Date startOfWeek   = dateParam.toStartOfWeek();
		system.debug('startOfWeek = '+startOfWeek);
		Integer dayOfWeek  = dateParam.day() - startOfWeek.day();
		system.debug('dayOfWeek = '+dayOfWeek);   
		result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
		system.debug('result = '+result); 
		return result;
	}
   
   	public static Date addBusinessDays(Date startDate, Integer businessDaysToAdd){
		//Add or decrease in BusinessDaysToAdd days 
		Date finalDate = startDate;
		system.debug('finaldate = '+finalDate);
		Integer direction = businessDaysToAdd < 0 ? -1 : 1;
		system.debug('direction = '+direction);
		while(businessDaysToAdd != 0)
		{
			finalDate = finalDate.AddDays(direction);
			system.debug('BusinessDaysToAdd = '+BusinessDaysToAdd);            
			system.debug('finaldate = '+finalDate);
			if (!isWeekendDay(finalDate)) {
				businessDaysToAdd -= direction;
			}
		}
		return finalDate;
   }
}