@isTest
public with sharing class GlobalUtil_TEST {

	@isTest public static void validateGetRecordTypeInfo(){
		ID studentAcctRecTypeID =  GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student');
		String studentAcctRecTypeLabel = GlobalUtil.getRecordTypeLabelNameByID('Account', studentAcctRecTypeID);
		system.assertEquals(studentAcctRecTypeLabel, 'Student');
	}
	@isTest public static void validateGetPicklistValues(){
		List<String> types = GlobalUtil.getPicklistValues('Account', 'Type');
	}

	@isTest public static void validateGetCountryLabelByValueMap(){
		Map<String, String> countryLabelByValue = GlobalUtil.getCountryLabelByValueMap();
	}

	@isTest public static void validateGetCountryLabelByValue(){
		//Map<String, String> countryLabelByValue = GlobalUtil.getCountryLabelByValueMap();
		//Set<String> countryValues = countryLabelByValue.keySet();
		String label = GlobalUtil.getCountryLabelByValue('US');
	}
	@isTest public static void validateGetStateLabelByValueMap(){
		Map<String, String> stateLabelByValue = GlobalUtil.getStateLabelByValueMap();
	}

	@isTest public static void validateGetStateLabelByValue(){
		//Map<String, String> countryLabelByValue = GlobalUtil.getCountryLabelByValueMap();
		//Set<String> countryValues = countryLabelByValue.keySet();
		String label = GlobalUtil.getStateLabelByValue('CO');
	}	
}