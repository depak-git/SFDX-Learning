public with sharing class ReportPeriodicClientsController{
    public List<SchoolWrapper> schools {get;set;}
    public Transaction__c startDate {get;set;}
    public Transaction__c endDate {get;set;}
    public String mode {get;set;}
    public Static String sortBy {get;set;}
    public Static String sortDirection {get;set;}
    transient public List<reportDataWrapper> reportData {get;set;}   
    transient public String csv {get;set;}
    
    private Set<String> schoolSet;
    transient private Map<String,List<Transaction__c>> studentTxMap;
    transient private Set<ID> agreementIDs;
    
    
    public ReportPeriodicClientsController(){
        schools = new List<SchoolWrapper>();
        startDate = new Transaction__c();
        endDate = new Transaction__c();
        sortBy = '';
        sortDirection = 'ASCENDING';
        System.debug('SortDirection:'+sortDirection);
        getSchools();
        
        if(ApexPages.currentPage().getParameters().get('mode') != null) mode = ApexPages.currentPage().getParameters().get('mode');
        else mode = 'Program';
        if(mode != 'Program' && mode != 'School') mode = 'Program';
    }
    
    public List<SchoolWrapper> getSchools(){
        List<Account> result = [Select id,name From Account Where recordType.developerName = 'SchoolCustomer' Order By name ASC];
        for(Account sch:result){
            schools.add(new SchoolWrapper(false,sch));    
        }
        return schools; 
    }
    
    
    
    ///////////////////////////////////////////
    ///
    ///////////////////////////////////////////
    public void runReport(){
        System.debug('startDate:' + startDate);
        System.debug('endDate:' + endDate);
        System.debug('schoolFilter:' + schools);
         
        buildSelectedSchoolsSet();
        getFirstTransaction();
        buildReportData();
    }
    
    /////////////////////////////////////////////////
    ///Build a set of Selected schools via the filter
    /////////////////////////////////////////////////
    private void buildSelectedSchoolsSet(){
        schoolSet = new Set<String>();
        for(SchoolWrapper sw:schools){
            if(sw.selected == true){
                schoolSet.add(sw.school.id);
            }
        }                    
    }
    
    /////////////////////////////////////////////////
    ///Populates the reportData Wrapper List
    /////////////////////////////////////////////////
    public void buildReportData(){
        List<StudentProgram__c> agreements = getAgreementsWithAgreementID(agreementIDs);
        
        //populate the report data wrapper
        reportData = new List<reportDataWrapper>();
        for(StudentProgram__c agreement:agreements){
            //String key = agreement.Student__c + ':' + agreement.program__r.school__c;
            String key = getKey(null,agreement);
            transaction__c tx = studentTxMap.get(key)[0]; 
             
            reportData.add(new reportDataWrapper(agreement,tx.amount__c,tx.transactionDate__c,tx.id,tx.name));
        }
    }
    
    
    
    ////////////////////////////////////////////
    ///Find the first transaction for a student-school 
    ///OR a program-student combination according to the mode
    ///////////////////////////////////////////
    private void getFirstTransaction(){
        studentTxMap = new Map<String,List<Transaction__c>>();
        agreementIDs = new Set<ID>();
        List<transaction__c> txList = getTransactions();
        
        for(transaction__c tx:txList){
            //String key = tx.Student__c +':'+ tx.Agreement__r.Program__r.School__c;
            String key = getKey(tx,null);
            if(!studentTxMap.containsKey(key)){
                studentTxMap.put(key,new List<transaction__c>());
            }
            studentTxMap.get(key).add(tx);
        }
        
        agreementIDs = new Set<ID>();
        for(String key:studentTxMap.keySet()){
            
            Transaction__c earliestTx; 
            for(transaction__c tx:studentTxMap.get(key)){
                if(earliestTx == null || earliestTx.transactiondate__c > tx.transactionDate__c) earliestTx=tx; 
            }
            studentTxMap.put(key,new List<transaction__c>());
            studentTxMap.get(key).add(earliestTx);
            
            Date fromDate = startDate.transactionDate__c;
            Date toDate = endDate.transactionDate__c; 
            if(fromDate <> null){
                if(earliestTx.transactiondate__c >= fromDate){
                    if(toDate <> null){
                        if(earliestTx.transactiondate__c <= toDate){
                            agreementIDs.add(earliestTx.Agreement__c);    
                        }
                    }
                    else{
                        agreementIDs.add(earliestTx.Agreement__c);    
                    }
                }
            }
            else{
                if(toDate<>null){
                    if(earliestTx.transactiondate__c <= toDate){
                        agreementIDs.add(earliestTx.Agreement__c);    
                    }
                }
                else{
                    agreementIDs.add(earliestTx.Agreement__c);    
                }
            }
        
        }    
    } 
    
    ///////////////////////////////////////////////////
    ///Get all transactions with the selected filters
    ///////////////////////////////////////////////////   
    private List<transaction__c> getTransactions(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames = 'name, ';
        fieldNames += 'Amount__c, ';
        fieldNames += 'Student__c, ';
        fieldNames += 'Agreement__c, ';
        fieldNames += 'TransactionDate__c, ';
        fieldNames += 'Agreement__r.Program__r.School__c ';
        
        String query = 'Select ';
        query += fieldNames;
        query += 'From transaction__c ';
        query += 'Where ';
        query += 'Status__c = \'Complete\'';
        if(schoolSet <> null && schoolSet.size()>0) query += 'AND Agreement__r.Program__r.School__c IN :schoolSet ';
        //Date fromDate = startDate.transactionDate__c;
        Date toDate = endDate.transactionDate__c;  
        //if(fromDate <> null) query += 'AND transactionDate__c >= :fromDate ';
        if(toDate <> null) query += 'AND transactionDate__c <= :toDate'; 
         
                
        System.debug('query:' + query);
        
        List<Transaction__c> txList = new List<Transaction__c>();
        txList = (List<Transaction__c>)database.query(query);
        System.debug(txList);
        return txList;
    }
    
    /////////////////////////////////////////////////
    ///Get StudentPrograms for the given IDs
    /////////////////////////////////////////////////
    private List<StudentProgram__c> getAgreementsWithAgreementID(Set<ID> IDs){
        List<studentprogram__c> spList = new List<studentprogram__c>();
        
        if(IDs <> null && IDs.size()>0){
            String fieldNames;
            fieldNames = 'id, ';
            fieldNames += 'Name, ';
            fieldNames += 'Student__c, ';
            fieldNames += 'Student__r.Name, ';
            fieldNames += 'Program__c, ';
            fieldNames += 'Program__r.ProgramName__c, ';
            fieldNames += 'Program__r.School__c, ';
            fieldNames += 'Program__r.School__r.name, ';
            fieldNames += 'FundingAmountPostCertification__c, ';
            fieldNames += 'GraceMonthsAllowed__c, ';
            fieldNames += 'IncomeSharePostCertification__c, ';
            fieldNames += 'MinimumIncomePerMonth__c, ';
            fieldNames += 'MonthlyAmountDue__c, ';
            fieldNames += 'PaymentCapPostCertification__c, ';
            fieldNames += 'PaymentTermPostCertification__c, ';
            fieldNames += 'DefermentMonthsAllowed__c ';
            
            String query = 'Select ';
            query += fieldNames;
            query += 'From StudentProgram__c ';
            query += 'Where ';
            query += 'ID IN :IDs ';
            
            //if(sortBy <> 'firstTxDate' && sortBy <> 'firstTxAmount')
            //query += 'Order By ' + sortBy + ' ' + sortDirection; 
                    
            System.debug('query:' + query);
            
            
            spList = (List<studentprogram__c>)database.query(query);
            System.debug(spList);
        }
        return spList;    
    }
    
    ///////////////////////////////////////
    ///Build the key according on the mode 
    ///////////////////////////////////////
    private String getKey(Transaction__c tx,StudentProgram__c agreement){
        String key;
        if(mode == 'School'){
            if(tx <> null){
                key = tx.Student__c +':'+ tx.Agreement__r.Program__r.School__c;
            }
            else if(agreement <> null){
                key = agreement.Student__c + ':' + agreement.program__r.school__c;    
            }
        }
        else if(mode == 'Program'){
            if(tx <> null){
                key = tx.Student__c +':'+ tx.Agreement__r.Program__c;
            }
            else if(agreement <> null){
                key = agreement.Student__c + ':' + agreement.program__c;    
            }
        }
            
        
        return key;
    }
        
    /////////////////////////////////
    ///Sort report data
    /////////////////////////////////
    public void sort(){
        runReport();
        String newSortBy = Apexpages.currentPage().getParameters().get('sortByParam');
        
        if(sortBy == newSortBy){
            sortDirection = toggleSortDirection();    
        }
        else{
           sortBy = newSortBy;
           sortDirection = 'ASCENDING'; 
        }
        
        reportData.sort();            
    }
    
    
    /////////////////////////////
    ///change the sorting direction
    /////////////////////////////
    private String toggleSortDirection(){
        if(sortDirection == 'ASCENDING') return 'DESCENDING';
        else return 'ASCENDING';
    }
    
    ////////////////////////////////////////
    ///Generate a csv string
    ////////////////////////////////////////
    public void buildCsvString(){
        csv = 'School,Program,Student,Student Program,Disbursement,1st Disbursement Date,1st Disbursement Amount,';
        csv += 'Funding Amount(Post Certification),Income Share(Post Certification),Payment Term (Post Certification),';
        csv += 'Deferement Months Allowed,Grace Months Allowed,Minimum Income Per Month,Payment Cap(Post Certification)';
        csv += '\n';
        runReport();
        if(reportData == null || reportData.size()==0) return;
        
        
        for(reportDataWrapper row:reportData){
            csv += row.agreement.Program__r.School__r.name + ',';
            csv += row.agreement.Program__r.ProgramName__c + ',';
            csv += row.agreement.student__r.name + ',';
            csv += row.agreement.name + ',';
            csv += row.disbursementName + ',';
            csv += row.firstTxDate.month() + '/' + row.firstTxDate.day() + '/' + row.firstTxDate.year() + ',';
            csv += row.firstTxAmount + ',';
            
            if(row.agreement.FundingAmountPostCertification__c <> null) csv += row.agreement.FundingAmountPostCertification__c + ',';    
            else csv += ',';
            
            if(row.agreement.IncomeSharePostCertification__c <> null) csv += row.agreement.IncomeSharePostCertification__c + ',';
            else csv += ',';
            
            if(row.agreement.PaymentTermPostCertification__c <> null) csv += row.agreement.PaymentTermPostCertification__c + ',';
            else csv += ',';
            
            if(row.agreement.DefermentMonthsAllowed__c <> null) csv += row.agreement.DefermentMonthsAllowed__c + ',';
            else csv += ',';
            
            if(row.agreement.GraceMonthsAllowed__c <> null) csv += row.agreement.GraceMonthsAllowed__c + ',';
            else csv += ',';
            
            if(row.agreement.MinimumIncomePerMonth__c <> null) csv += row.agreement.MinimumIncomePerMonth__c + ',';
            else csv += ',';
            
            if(row.agreement.PaymentCapPostCertification__c <> null) csv += row.agreement.PaymentCapPostCertification__c;
            else csv += ',';
            csv += '\n';
            
        }
    }
    
    
    ////////////////////////////////////////
    ///Call the export VF Page
    ////////////////////////////////////////
    public PageReference exportToCSV(){
        PageReference pg = new PageReference('/apex/ReportPeriodicClientsExport');
        pg.setRedirect(false);
        return pg;
    }
    
    ///////////////////////////////////
    ///Wrapper to hold all school Customers
    ///////////////////////////////////
    public class SchoolWrapper{
        public boolean selected {get;set;}
        public Account school {get;set;}
        
        public schoolWrapper(boolean selected, Account school){
            this.selected = selected;
            this.school = school;
        }  
        
    }
    
    ////////////////////////////////////////
    ///Wrapper to display report data
    ////////////////////////////////////////
    public class reportDataWrapper implements Comparable{
        
        
        public Integer compareTo(Object compareTo){
            reportDataWrapper compareToElement = (reportDataWrapper)compareTo;
            
            if(sortBy == 'firstTxDate'){
                return dateCompare(firstTxDate,compareToElement.firstTxDate,sortDirection);
            }
            if(sortBy == 'firstTxAmount'){
                return decimalCompare(firstTxAmount,compareToElement.firstTxAmount,sortDirection);
            }
            if(sortBy == 'School'){
                return stringCompare(agreement.Program__r.School__r.name,compareToElement.agreement.Program__r.School__r.name,sortDirection);
            }
            if(sortBy == 'Program'){
                return stringCompare(agreement.Program__r.ProgramName__c,compareToElement.agreement.Program__r.ProgramName__c,sortDirection);
            }
            if(sortBy == 'Student'){
                system.debug('STUDENT CHECK');
                return stringCompare(agreement.student__r.name,compareToElement.agreement.student__r.name,sortDirection);
            }
            if(sortBy == 'StudentProgram'){
                return stringCompare(agreement.name,compareToElement.agreement.name,sortDirection);
            }
            if(sortBy == 'Disbursement'){
                return stringCompare(disbursementName,compareToElement.disbursementName,sortDirection);
            }
            if(sortBy == 'FundingAmountPostCertification'){
                return decimalCompare(agreement.FundingAmountPostCertification__c,compareToElement.agreement.FundingAmountPostCertification__c,sortDirection);
            }
            if(sortBy == 'IncomeSharePostCertification'){
                return decimalCompare(agreement.IncomeSharePostCertification__c,compareToElement.agreement.IncomeSharePostCertification__c,sortDirection);
            }
            if(sortBy == 'PaymentTermPostCertification'){
                return decimalCompare(agreement.PaymentTermPostCertification__c,compareToElement.agreement.PaymentTermPostCertification__c,sortDirection);
            }
            if(sortBy == 'DefermentMonthsAllowed'){
                return decimalCompare(agreement.DefermentMonthsAllowed__c,compareToElement.agreement.DefermentMonthsAllowed__c,sortDirection);
            }
            if(sortBy == 'GraceMonthsAllowed'){
                return decimalCompare(agreement.GraceMonthsAllowed__c,compareToElement.agreement.GraceMonthsAllowed__c,sortDirection);
            }
            if(sortBy == 'MinimumIncomePerMonth'){
                return decimalCompare(agreement.MinimumIncomePerMonth__c,compareToElement.agreement.MinimumIncomePerMonth__c,sortDirection);
            }
            if(sortBy == 'PaymentCapPostCertification'){
                return decimalCompare(agreement.PaymentCapPostCertification__c,compareToElement.agreement.PaymentCapPostCertification__c,sortDirection);
            }
            
            return 0;
            
            
            
        }
        
        //String comparision
        public Integer stringCompare(String instance,String compareWith,String direction){
            if(compareWith == null) compareWith = ''; 
            instance = instance.toLowerCase();
            compareWith = compareWith.toLowerCase();
            if(direction == 'ASCENDING'){
                return (instance <> null) ? instance.compareTo(compareWith) : -1;
            }
            else{
                return (instance <> null) ? compareWith.compareTo(instance) : 1;
            }
        }
        
        //Decimal comparision
        public Integer decimalCompare(Decimal instance,Decimal compareWith,String direction){
            if(direction == 'ASCENDING'){
                if(compareWith == null) return 1;
                if(instance == null) return -1;
                if(instance == compareWith) return 0;
                if(instance > compareWith) return 1; 
                return -1;
            }
            else{
                if(compareWith == null) return -1;
                if(instance == null) return 1;
                if(instance == compareWith) return 0;
                if(instance < compareWith) return 1; 
                return -1;
            }
        }
        
        //Date comparision
        public Integer dateCompare(Date instance,Date compareWith,String direction){
            if(direction == 'ASCENDING'){
                if(compareWith == null) return 1;
                if(instance == null) return -1;
                if(instance == compareWith) return 0;
                if(instance > compareWith) return 1; 
                return -1;
            }
            else{
                if(compareWith == null) return -1;
                if(instance == null) return 1;
                if(instance == compareWith) return 0;
                if(instance < compareWith) return 1; 
                return -1;
            }
        }
        
        public Date firstTxDate {get;set;}
        public Decimal firstTxAmount {get;set;}
        public String disbursementName {get;set;}
        public String disbursementID {get;set;} 
        public StudentProgram__c agreement {get;set;}
        
        public reportDataWrapper(StudentProgram__c sp,Decimal firstTxAmount,Date firstTxDate,String disbID,String disbName){
            this.agreement = sp;
            this.firstTxAmount = firstTxAmount;
            this.firstTxDate = firstTxDate;
            this.disbursementName = disbName;
            this.disbursementID = disbID;
        }
    }
    
    
}