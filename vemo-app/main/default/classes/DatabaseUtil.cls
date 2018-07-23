public class DatabaseUtil {
    
    public static Boolean filterByStudentID = false;
    public static Boolean filterBySchoolID = false;
    public static ID schoolID = null;
    public static ID studentPersonAccountID = null;
    public static Boolean runQueriesInUserMode = true;
    public Boolean withSharing {get;set;}
    
    public static Boolean filterByDate = false;
    public static Date fromDate = null;
    public static Date toDate = null;
    public static Boolean filterByConfirmFlag = false;
    public static Boolean confirmFlag = null;
    
    public DatabaseUtil(){

    }
    public DatabaseUtil(Boolean withSharing){
        this.withSharing = withSharing;
    }

    public List<SObject> query(String query){
        system.debug('DatabaseUtil.query()');
        List<SObject> retList = new List<SObject>();
        system.debug('runQueriesInUserMode:'+runQueriesInUserMode);
        if(runQueriesInUserMode){
            DatabaseUtil.UserContext uc = new DatabaseUtil.UserContext();
            retList = uc.databaseQuery(query);
        } else {
            DatabaseUtil.SystemContext sc = new DatabaseUtil.SystemContext();
            retList =  sc.databaseQuery(query);
        }
        return retList;
    }

    public without sharing class SystemContext{
        public SystemContext(){}
        
        @TestVisible List<SObject> databaseQuery(String query){
            system.debug('DatabaseUtil.SystemContext.databaseQuery()');
            system.debug('query:'+query);
            return Database.query(query);
        }
    }
    public with sharing class UserContext{
        public UserContext(){}
        @TestVisible List<SObject> databaseQuery(String query){
            system.debug('DatabaseUtil.UserContext.databaseQuery()');
            system.debug('query:'+query);
            return Database.query(query);
        }
    }

    public static String inSetStringBuilder(Set<String> strings){
        String retStr = '(\'';
        Boolean firstString = true;
        for(String str : strings){
            if(!firstString){
                retStr += '\',\'';              
            }
            retStr += str;
            firstString = false;
        }
        retStr += '\')';
        system.debug(retStr);
        return retStr;
    }

    public static String inSetStringBuilder(Set<ID> ids){
        String retStr = '(\'';
        Boolean firstString = true;
        for(Id str : ids){
            if(!firstString){
                retStr += '\',\'';              
            }
            retStr += str;
            firstString = false;
        }
        retStr += '\')';
        system.debug(retStr);
        return retStr;
    }

    public static String inStringBuilder(String str){
        String retStr = '\'';
        retStr += str;
        retStr += '\'';
        system.debug(retStr);
        return retStr;
    }
}