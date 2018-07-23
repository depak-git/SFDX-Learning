/////////////////////////////////////////////////////////////////////////
// Class: VemoAPISchoolResource
// 
// Description: 
//   Direction Central for School API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPISchoolResource {
  public static Object handleAPI(VemoAPI.APIInfo api){
    if((api.version == 'v1') && (api.method == 'GET')){
      return handleGetV1(api);
    }
    if((api.version == 'v1') && (api.method == 'POST')){
      return handlePostV1(api);
    }
    if((api.version == 'v1') && (api.method == 'PUT')){
      return handlePutV1(api);
    }  
    if((api.version == 'v1') && (api.method == 'DELETE')){
      return handleDeleteV1(api);
    }      
    throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
    return null;
  }
  
  public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){      
    System.debug('VemoAPISchoolResource.handleGetV1()');
    String schoolIDParam = api.params.get('schoolID');
    String schoolNameParam = api.params.get('schoolName');
    String entryPointParam = api.params.get('entryPoint');
    List<SchoolService.School > schools = new List<SchoolService.School>();
    if(schoolIDParam != null){
      schools = SchoolService.getSchoolsWithSchoolID(VemoApi.parseParameterIntoIDSet(schoolIDParam));
    }
    else if(entryPointParam != null){
      schools = SchoolService.getSchoolsWithEntryPoint(VemoApi.parseParameterIntoStringSet(entryPointParam));
    }
    else if(schoolNameParam != null){
      schools = SchoolService.getSchoolsWithSchoolName(VemoApi.parseParameterIntoStringSet(schoolNameParam));
    }
    else{
      //todo return a list of all schools
      throw new VemoAPI.VemoAPIFaultException('Required parameter schoolID or schoolName');
    }
    List<SchoolResourceOutputV1> results = new List<SchoolResourceOutputV1> ();
    for(SchoolService.School schl : schools){
      results.add(new SchoolResourceOutputV1(schl));
    }
    return (new VemoAPI.ResultResponse(results, results.size()));
  }
  
  
  public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){    
    System.debug('VemoAPISchoolResource.handlePostV1()');
    List<SchoolService.School> newSchools = new List<SchoolService.School>();
    List<SchoolResourceInputV1> schoolJSON = (List<SchoolResourceInputV1>)JSON.deserialize(api.body, List<SchoolResourceInputV1>.class);
    System.debug('deserialize: ' + schoolJSON);

    for(SchoolResourceInputV1 schlRes : schoolJSON){
      schlRes.validatePOSTFields();
      SchoolService.School schl = new SchoolService.School();
      schl = schoolResourceV1ToSchool(schlRes);
      newSchools.add(schl);
    }
    Set<ID> schoolIDs = SchoolService.createSchool(newSchools);
    return (new VemoAPI.ResultResponse(schoolIDs, schoolIDs.size()));
  }

  
  public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
    System.debug('VemoAPISchoolResource.handlePutV1()');
    List<SchoolService.School> newSchools = new List<SchoolService.School>();
    List<SchoolResourceInputV1> schoolJSON = (List<SchoolResourceInputV1>)JSON.deserialize(api.body, List<SchoolResourceInputV1>.class);
    System.debug('deserialize: ' + schoolJSON);

    for(SchoolResourceInputV1 schlRes : schoolJSON){
      schlRes.validatePUTFields();
      SchoolService.School schl = new SchoolService.School();
      schl = schoolResourceV1ToSchool(schlRes);
      newSchools.add(schl);
    }
    Set<ID> schoolIDs = SchoolService.updateSchool(newSchools);
    return (new VemoAPI.ResultResponse(schoolIDs, schoolIDs.size()));
  }
  
  public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
    System.debug('VemoAPIStudentResource.handleDeleteV1 API Params = ' + api.params);    
    String schoolIDParam = api.params.get('schoolID');
    Integer numToDelete = SchoolService.deleteSchool(VemoApi.parseParameterIntoIDSet(schoolIDParam));
    return (new VemoAPI.ResultResponse(true, numToDelete));
  }

  public static SchoolService.School schoolResourceV1ToSchool(SchoolResourceInputV1 schlRes){
    SchoolService.School schl = new SchoolService.School();
    if(String.isNotBlank(schlRes.schoolID)) schl.schoolID = schlRes.schoolID;
//    schl.guid = schlRes.guid;
    schl.schoolName = schlRes.schoolName;
    return schl;
  }

  public class SchoolResourceInputV1{
    public String schoolID {get;set;}
//    public String guid {get;set;}
    public String schoolName {get;set;}

    public SchoolResourceInputV1(Boolean testValues){
      if(testValues){
        schoolName = 'Test School';
      }
    }

    public void validatePOSTFields(){
      if(schoolID != null) throw new VemoAPI.VemoAPIFaultException('schoolID cannot be created in POST');
//      if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be created in POST');
    }
    public void validatePUTFields(){
      if(schoolID == null) throw new VemoAPI.VemoAPIFaultException('schoolID is a required input parameter on PUT');
//      if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be updated in PUT');
    }
    
  }
  public class SchoolResourceOutputV1{
    public String schoolID {get;set;}
//    public String guid {get;set;}
    public String schoolName {get;set;}
    public String accountNumber {get;set;}
    public String entryPoint {get;set;}
    public String websiteStatus {get;set;}
    public String webStyle {get;set;}
    public String displayName {get;set;}
    public String schoolLogoURL {get;set;}
    public String titleBlock {get;set;}
    public String descriptionBlock {get;set;}
    public String detailBlock {get;set;}
    public String campusServiceName {get;set;}
    public String campusServiceEmail {get;set;}
    public String campusServiceMobile {get;set;}
    public String campusServiceAvailability {get;set;}
    public String StudentCampusServiceAvailability {get;set;} 
    public String StudentCampusServiceEmail {get;set;}
    public String StudentCampusServiceMobile {get;set;}
    public String StudentCampusServiceName {get;set;}

    public SchoolResourceOutputV1(SchoolService.School schl){
      this.schoolID = schl.schoolID;
//      this.guid = schl.guid;
      this.schoolName = schl.schoolName;  
      this.accountNumber = schl.accountNumber;
      this.entryPoint = schl.entryPoint;
      this.websiteStatus = schl.websiteStatus;
      this.webStyle = schl.webStyle;
      this.displayName = schl.displayName;  
      this.schoolLogoURL = schl.schoolLogoURL;
      this.titleBlock = schl.titleBlock;
      this.descriptionBlock = schl.descriptionBlock;
      this.detailBlock = schl.detailBlock;
      this.campusServiceName = schl.campusServiceName;
      this.campusServiceEmail = schl.campusServiceEmail;
      this.campusServiceMobile = schl.campusServiceMobile;
      this.campusServiceAvailability = schl.campusServiceAvailability;
      
      this.StudentcampusServiceAvailability = schl.StudentcampusServiceAvailability;
      this.StudentcampusServiceEmail = schl.StudentcampusServiceEmail;
      this.StudentcampusServiceMobile = schl.StudentcampusServiceMobile;
      this.StudentcampusServiceName = schl.StudentcampusServiceName;
    }
  }  

}