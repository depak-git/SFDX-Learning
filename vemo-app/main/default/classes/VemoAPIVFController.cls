public with sharing class VemoAPIVFController {
     public class School {
        String schoolID {get;set;}
        String schoolName {get;set;}
    }
    private final SObject sobj;
    private final ID theID;
    public VemoAPIVFController(ApexPages.StandardController stdController){
            System.debug('VemoAPIVFController.VemoAPIVFController(ApexPages.StandardController)');
            this.sobj = stdController.getRecord();
            this.theID = stdController.getId();
    }
    public VemoAPIVFController(){
            System.debug('VemoAPIVFController.VemoAPIVFController()');
    }
    
    @RemoteAction
    public static String createAttachment(String name, String contentType, String parentID, String body) {
        if(body != null){
            Attachment attach=new Attachment();
            attach.Body=EncodingUtil.base64Decode(body);
            attach.Name=name;
            attach.ContentType='application/pdf';
            attach.ParentID=parentID;
            try {
              insert(attach);
              return attach.id;
            } catch(System.DMLException e) {
              ApexPages.addMessages(e);
              return null;
            }
        }
        return 'attachment success';
    }
    
    @RemoteAction
    public static List<School> loadUser(String val) {
        System.debug('Running CertificationController.loadUser');
        List<School> schools = new List<School>();
        try{
            List<User> userList = [SELECT id, AccountID, Account.RecordType.Id, ContactID from User where id = :UserInfo.getUserID()];
            System.debug('User List = ' + userList);
            System.debug('Account Record Type = ' + userList.get(0).Account.RecordType.Id);
            if (userList.size() == 1 && String.isNotEmpty(userList[0].AccountID)) {
                List<SchoolService.School> schoolsList = SchoolService.getSchoolsWithSchoolID(new Set<ID>{userList[0].AccountID});
                for (SchoolService.School schoolServiceSchool : schoolsList) {
                    School sch = new School();
                    sch.schoolID = schoolServiceSchool.schoolID;
                    sch.schoolName = schoolServiceSchool.schoolName;
                    schools.add(sch);
                }
            }

            if (!schools.isEmpty())
                return schools;

            // This must be a Vemo user

            List<SchoolService.School> schoolCustomers = SchoolService.getSchoolCustomers();
            for (SchoolService.School schoolCustomer : schoolCustomers) {
                School sch = new School();
                sch.schoolID = schoolCustomer.schoolID;
                sch.schoolName = schoolCustomer.schoolName;
                schools.add(sch);
            }

            return schools;
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.loadUser');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an issue loading users');
            ApexPages.addMessage(msg);
        }
        return schools;
    }
    
  
    @RemoteAction
    public static String createNote(String title, Boolean isPrivate, String parentID, String body) {
        if(body != null){
            Note note=new Note();
            note.Body=body;
            note.Title=title;
            note.IsPrivate=isPrivate;
            note.ParentID=parentID;
            try {
              insert(note);
              return '{ \"success\": \"true\", \"id\": \"' + note.id + '\"}';
            } catch(System.DMLException e) {
              ApexPages.addMessages(e);
              return null;
            }
        }
        return 'note success';
    }
    
    @RemoteAction
    public static String getAllNotes(String parentID) {
        if(parentID == null){
            return null;
        }
        
        List<sObject> sobjList = Database.query('SELECT Id,Title,Body FROM Note WHERE parentID = :parentID');
        
        return JSON.serialize(sobjList);
    }
    
    @RemoteAction
    public static String callVemoAPI(String method, String url, String requestEntity, String params) {
        System.debug('VemoAPIVFController.callVemoAPI()');
        System.debug('method:'+method);
        System.debug('url:'+url);
        System.debug('requestEntity:'+requestEntity);
        System.debug('params:'+params);
        
        VemoAPI.InternalRequest internalRequest = new VemoAPI.InternalRequest();
        internalRequest.params = new Map<String,String>();

        List<String> keyValues = params.split('&');
        for(String str : keyValues){
            internalRequest.params.put(str.substringBefore('='), str.substringAfter('='));
        }

        System.debug(internalRequest.params);
 
        internalRequest.httpMethod = method;
        internalRequest.requestURI = url;
        internalRequest.requestBody = Blob.valueOf(requestEntity);

        internalRequest.headers = new Map<String,String>();

        VemoAPI.APIInfo apiInfo = new VemoAPI.APIInfo(internalRequest);
        VemoAPI.internalAPI = apiInfo;

        LogService.fine('VemoAPI.internalRequest()', null);
        VemoApi.Response response = VemoAPI.response();

        LogService.writeLogs();

        return JSON.serialize(response);

    }
}