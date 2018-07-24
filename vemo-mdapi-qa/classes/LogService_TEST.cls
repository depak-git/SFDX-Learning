@isTest
public class LogService_TEST {

    public static testMethod void testService() {
    	LogService.purgeLogs();
    	LogService.debug('hello','test');
    	LogService.debug('world','test');
    	LogService.writeLogs();
    }
}