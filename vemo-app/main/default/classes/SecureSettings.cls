public with sharing class SecureSettings {
	public static Map<String, String> settings = new Map<String, String>();
	private static Blob initVector = Blob.valueOf('randomtextstring');
    private static BLob key = EncodingUtil.convertFromHex('c6ea9a21d14287be9f34ccd1f86854e6f29a74b1ad3df365c6d23bda7b86f08a');

	public static String getValue(String name){
		if(settings.containsKey(name)) return settings.get(name);
		return null;
	}
	static{
		Map<ID, SecureSetting__c> secureSettingMap = new Map<ID, SecureSetting__c>([SELECT id, Name, Value__c from SecureSetting__c]);
		Set<ID> encryptedSettingIDs = new Set<ID>();
		for(SecureSetting__c setting : secureSettingMap.values()){
			if(String.isNotEmpty(setting.Value__c)){
				settings.put(setting.Name, setting.Value__c);				
			} else {
				encryptedSettingIDs.add(setting.id);
			}
		}
		Map<ID, String> encryptedSettings = decrypt(encryptedSettingIDs);
		for(ID theID : encryptedSettings.keySet()){
			settings.put(secureSettingMap.get(theID).Name, encryptedSettings.get(theID));
		}
	}
    /*Move to service layer*/
    public static Blob encrypt(String decryptedString){
		Blob decryptedBlob = Blob.valueOf(decryptedString);
		Blob encryptedBlob = Crypto.encrypt('AES256', key, initVector, decryptedBlob);
		return encryptedBlob;	
    }

    public static String decrypt(Blob encryptedBlob){
		Blob decryptedBlob = Crypto.decrypt('AES256', key, initVector, encryptedBlob);
		String decryptedString = decryptedBlob.toString();
		return decryptedString;	
    }

    public static Map<ID, String> decrypt(Set<ID> settingIDs){
        Map<ID, Attachment> attachmentMap = AttachmentQueries.getAttachmentMapWithParentID(settingIDs);
        Map<ID, List<Attachment>> attachmentsByParentID = new Map<ID, List<Attachment>>();
        Map<ID, String> returnMap = new Map<ID, String>();
        for(Attachment attach : attachmentMap.values()){
            if(!attachmentsByParentID.containsKey(attach.ParentID)){
                attachmentsByParentID.put(attach.ParentID, new List<Attachment>());
            }
            attachmentsByParentID.get(attach.ParentID).add(attach);
        }
        for(ID theID : settingIDs){
            if(attachmentsByParentID.get(theID).size()!=1) throw new SecureSettingException('There is an error decrypting the value');
            returnMap.put(theID, decrypt(attachmentsByParentID.get(theID)[0].Body));
        }
        return returnMap;
    }
    public class SecureSettingException extends Exception {}

}