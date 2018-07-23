public with sharing class ReportMnthlyInvstrPeriodicController{
    
    public String selectedProgram {get;set;}
    public String fileName {get;set;} 
    transient public List<reportDataWrapper> reportData {get;set;}   
    transient public String csv {get;set;}
    private Integer currentMonth;
    private Integer currentYear;
    private String mode {get;set;} //{1=> MonthlyInvestorReport, 2 => SalesForeCast}
    
    /////////////////////////////////////
    ///Constructor 
    /////////////////////////////////////
    public ReportMnthlyInvstrPeriodicController(){
        selectedProgram = '';
        reportData = new List<reportDataWrapper>();    
        currentMonth = Date.today().month();
        currentYear = Date.today().year();
    }
    
    //////////////////////////////////////
    ///Get All Programs 
    //////////////////////////////////////
    public List<SelectOption> getPrograms(){
        List<Program__c> programs = [Select id,programName__c,school__r.name,MinimumIncomePerMonth__c From Program__c Order By school__r.name];
        List<SelectOption> output = new List<SelectOption>();
        for(Program__c prg:programs){
            output.add(new SelectOption(prg.id,prg.school__r.name + ' : ' + prg.programName__c));    
        }
        return output;
    }
    
    ////////////////////////////////////////
    ///Run report to build report data 
    ///////////////////////////////////////
    public void runReport(){
        //set mode
        setMode();            
        buildReportData();
    }
    
    //////////////////////////////////////////////
    ///Build report data
    //////////////////////////////////////////////
    private void buildReportData(){
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        //Final output Map 
        Map<String,ReportDataWrapper> outputMap = new Map<String,ReportDataWrapper>();  
        
        //Map of all agreements
        Map<ID,StudentProgram__c> spMap = new Map<ID,StudentProgram__c>();             
        
        //Map of Agreements sorted by month
        Map<String,Set<ID>> sortedAgreementsMap = new Map<String,Set<ID>>();           
        
        //Map of Enrollment Status by month
        Map<String,EnrollmentStatus> enrollmentStatusMap = new Map<String,EnrollmentStatus>();
        
        //Map of Account Status by Month
        Map<String,AccountStatus> accountStatusMap = new Map<String,AccountStatus>();
        
        //Map of Delinquency Status by Month
        Map<String,DelinquencyStatus> delinquencyStatusMap = new Map<String,DelinquencyStatus>(); 
        
        //Map of Agreements by Student
        Map<ID,Set<ID>> studentAgreementMap = new Map<ID,Set<ID>>(); 
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //get all agreements for selected program
        spMap = getAgreements();
        
        //sort the agreements by month-year
        sortAgreements(spMap,sortedAgreementsMap,enrollmentStatusMap,accountStatusMap,studentAgreementMap);
        buildOutputMap(sortedAgreementsMap,enrollmentStatusMap,accountStatusMap,outputMap);
        
        //get the payment allocation data
        if(spMap.KeySet().size()>0){
            getPaymentData(spMap.KeySet(),outputMap);    
        }
        
        //get Monthly Status Data
        if(spMap.KeySet().size()>0){
            getMonthlyTracker(spMap.KeySet(),outputMap);    
        }
        
        //get Delinquency Data
        if(spMap.KeySet().size()>0){
            getDelinquencyData(spMap.KeySet(),sortedAgreementsMap,outputMap);    
        }
        
        //get Income Data
        if(studentAgreementMap.keySet().size()>0 && mode == '1'){
            getIncomeData(studentAgreementMap,sortedAgreementsMap,outputMap);
        }
        
        //get Deferment Data
        if(studentAgreementMap.keySet().size()>0 && mode == '2'){
            getDefermentData(studentAgreementMap,sortedAgreementsMap,outputMap);
        }
               
        //populate the final reportData list 
        reportData = new List<reportDataWrapper>();
        reportData = outputMap.values();
        reportData.sort();
    }
    
    //////////////////////////////////////////////
    ///Get All agreements for the selected Program
    //////////////////////////////////////////////
    private Map<ID,StudentProgram__c> getAgreements(){
        System.debug('@@@selectedProgram:'+selectedProgram);
        Map<ID,StudentProgram__c> spMap = new Map<ID,StudentProgram__c>([SELECT id,Student__c,Status__c,CertificationDate__c,ClosedDate__c,ClosedReason__c,CurrentStatusDate__c,Servicing__c,LastDateOfAttendance__c 
                                                                         FROM StudentProgram__c 
                                                                         WHERE Program__c = :selectedProgram AND CertificationDate__c <> null
                                                                         ORDER BY CertificationDate__c ASC]);
        
        return spMap;
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    ///Initialize the output map for all months that would be displayed in the report 
    ///with their row level data
    //////////////////////////////////////////////////////////////////////////////////
    private void buildOutputMap(Map<String,Set<ID>> sortedAgreementsMap,Map<String,EnrollmentStatus> enrollmentStatusMap,
                               Map<String,AccountStatus> accountStatusMap,Map<String,ReportDataWrapper> outputMap){
        for(String key:sortedAgreementsMap.keyset()){
            ReportDataWrapper wrapper = new ReportDataWrapper();
            //key is string of numbers
            //eg 12018 for JAN-2018, 122018 for DEC-2018 
            if(key.length() == 5) wrapper.month = getMonthName(Integer.valueOf(key.left(1).trim())) + '-' + key.right(4);
            if(key.length() == 6) wrapper.month = getMonthName(Integer.valueOf(key.left(2).trim())) + '-' + key.right(4);
            wrapper.numOfIsaAssets = sortedAgreementsMap.get(key).size();
            wrapper.enrollmentData = enrollmentStatusMap.get(key);
            wrapper.accStatus = accountStatusMap.containsKey(key)?accountStatusMap.get(key):new AccountStatus(); 
            wrapper.numOfIsaPayments = 0;
            wrapper.sumOfIsaPayments = 0; 
            wrapper.cumulativeIsaPaymentsMade = 0;
            wrapper.numInGrace = 0;
            wrapper.numInDeferment = 0;
            wrapper.numInPayment = 0;
            wrapper.delinquencyData = new DelinquencyStatus();
            wrapper.incData = new IncomeData();
            wrapper.defermentData = new DefermentType();
            outputMap.put(key,wrapper);
        }
    }
    
    ////////////////////////////////////////////////////////
    ///Description: Sort the agreements by month, an agreement starts appearing in the report from the month it has been certified
    ///till it has been closed Or moved into Pending Reconciliation Status
    ////////////////////////////////////////////////////////
    private void sortAgreements(Map<ID,StudentProgram__c> spMap, Map<String,Set<ID>> sortedAgreementsMap,Map<String,EnrollmentStatus> enrollmentStatusMap,Map<String,AccountStatus> accountStatusMap,Map<ID,Set<ID>> studentAgreementMap){
        for(StudentProgram__c agreement:spMap.values()){
            if(!studentAgreementMap.containsKey(agreement.student__c)){
                studentAgreementMap.put(agreement.student__c,new Set<ID>());
            }
            studentAgreementMap.get(agreement.student__c).add(agreement.id);
            
            //An agreement starts showing in the report from the month it is certified  
            Integer beginMonth = agreement.certificationDate__c.Date().month(); 
            Integer beginYear = agreement.certificationDate__c.Date().year();
            System.debug('@@@Month'+beginMonth);
            System.debug('@@@Year'+beginYear);
            
            //We will not be showing the current month in the report, 
            //if Report is run in April 2018 then data will be shown upto March 2018
            Integer endMonth;
            Integer endYear;
                        
            if(agreement.Status__c == 'Closed' && agreement.closedDate__c <> null){
                
                endMonth = agreement.closedDate__c.Date().month();
                endYear = agreement.closedDate__c.Date().year();
                //if the Closed Date of the agreement falls in current month,
                //move the ending month-year back by one month
                //CHANGE: should be considered active till the previous month of 
                //closed month
                //if(endMonth == currentMonth && endYear == currentYear){
                    if(endMonth == 1){
                        endMonth = 12;
                        endYear -= 1; 
                    }
                    endMonth -=1;        
                //}
                
                //this logic needs to be revisited
                //capture the Account status whether Default Or Paid Off
                String key = String.valueOf(agreement.closedDate__c.Date().month()) + String.valueOf(agreement.closedDate__c.Date().year());
                //if(agreement.closedDate__c.month() == 12) key = String.valueOf(1) + String.valueOf(agreement.closedDate__c.year()+1);
                //else    key = String.valueOf(agreement.closedDate__c.month()+1) + String.valueOf(agreement.closedDate__c.year());
                

                if(!accountStatusMap.containsKey(key)){
                    accountStatusMap.put(key,new AccountStatus());
                }
                if(agreement.closedReason__c == 'Default' || agreement.closedReason__c == 'Write off' || agreement.closedReason__c == 'Forgiven'){
                    accountStatusMap.get(key).numDefault += 1;         
                }
                if(agreement.closedReason__c == 'Contract Satisfied' || agreement.closedReason__c == 'Refinanced'){
                    accountStatusMap.get(key).numPaid += 1;         
                }
            
            } else if(agreement.status__c == 'Cancelled' && agreement.CurrentStatusDate__c <> null){
                    endMonth = agreement.CurrentStatusDate__c.Date().month();
                    endYear = agreement.CurrentStatusDate__c.Date().year();
                    //if the Current Status Date of the agreement falls in current month,
                    //move the ending month-year back by one month
                    if(endMonth == currentMonth && endYear == currentYear){
                        if(endMonth == 1){
                            endMonth = 12;
                            endYear -= 1; 
                        }
                        else endMonth -=1;        
                    }
            } else if(agreement.status__c == 'Pending Reconciliation' && agreement.CurrentStatusDate__c <> null){
                    endMonth = agreement.CurrentStatusDate__c.Date().month();
                    endYear = agreement.CurrentStatusDate__c.Date().year();
                    //if the Current Status Date of the agreement falls in current month,
                    //move the ending month-year back by one month
                    //if(endMonth == currentMonth && endYear == currentYear){
                        if(endMonth == 1){
                            endMonth = 12;
                            endYear -= 1; 
                        }
                        else endMonth -=1;        
                    //}
                    String key = String.valueOf(agreement.CurrentStatusDate__c.Date().month()) + String.valueOf(agreement.CurrentStatusDate__c.Date().year());
                    if(!accountStatusMap.containsKey(key)){
                        accountStatusMap.put(key,new AccountStatus());
                    }
                    accountStatusMap.get(key).numPaid += 1;         
            } else {
                if(currentMonth == 1){
                    endMonth = 12;
                    endYear = currentYear -1;
                }
                else{ 
                    endMonth = currentMonth-1;
                    endYear = currentYear;  
                }      
            }    
            
            
            /*
            Integer servicingStartMonth;
            Integer servingStartYear;
            
            if(agreement.servicingStartDate__c <> null){
                servicingStartMonth = agreement.servicingStartDate__c.month();
                servingStartYear = agreement.servicingStartDate__c.year();     
            }
            */
            
            Integer ldaMonth;
            Integer ldaYear;
            
            if(agreement.LastDateOfAttendance__c <> null){
                ldaMonth = agreement.LastDateOfAttendance__c.month();
                ldaYear = agreement.LastDateOfAttendance__c.year();
            }
            
            while( ((beginYear==endYear) && (beginMonth<=endMonth)) || (beginYear<endYear) ){
                //sort agreements by month
                String key = String.valueOf(beginMonth) + String.valueOf(beginYear);
                if(!sortedAgreementsMap.containsKey(key)){
                    sortedAgreementsMap.put(key,new Set<ID>());
                }
                sortedAgreementsMap.get(key).add(agreement.id);
                
                //sort enrollment data by month
                if(!enrollmentStatusMap.containsKey(key)){
                    enrollmentStatusMap.put(key,new EnrollmentStatus());    
                }
                
                if(agreement.LastDateOfAttendance__c <> null){
                    if( ((beginYear==ldaYear) && (beginMonth<=ldaMonth)) || (beginYear<ldaYear)){
                        enrollmentStatusMap.get(key).numInSchool += 1;    
                    }
                    else{
                        enrollmentStatusMap.get(key).numGraduated += 1;
                    }
                }
                else{
                    enrollmentStatusMap.get(key).numInSchool += 1; 
                }
                
                //increment beginMonth/beginYear 
                if(beginMonth == 12){
                    beginYear++;
                    beginMonth = 1;
                }
                else{
                    beginMonth++;   
                } 
            }
                                                                                                                                             
        }
                        
    }
    
    /////////////////////////////////////////////////////////////////
    ///Description: get the monthly tracker data
    /////////////////////////////////////////////////////////////////
    private void getMonthlyTracker(Set<ID> agreementIDs,Map<String,ReportDataWrapper> outputMap){
        AggregateResult[] groupedResults = [SELECT month__c,year__c,activity__c,count(id) 
                                            FROM StudentProgramMonthlyStatus__c
                                            WHERE agreement__c IN :agreementIDs
                                            GROUP BY month__c,year__c,activity__c
                                           ];
        
        for(AggregateResult ar:groupedResults){
            String month = (String)ar.get('month__c');
            String year = (String)ar.get('year__c');
            String activity = (String)ar.get('activity__c');
            Integer count = (Integer)ar.get('expr0');
            
            
            String key = String.valueOf(getMonthNumber(month.left(3))) + year;
            System.debug('@@@KEY MONTHLY STATUS:'+key);
            if(outputMap.containsKey(key)){
                if(activity == 'Payment') outputMap.get(key).numInPayment = count;
                if(activity == 'Grace') outputMap.get(key).numInGrace = count;
                if(activity == 'Deferment') outputMap.get(key).numInDeferment = count;
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////
    ///Description: Get the Payment Data
    ////////////////////////////////////////////////////////////////
    private void getPaymentData(Set<ID> agreementIDs,Map<String,ReportDataWrapper> outputMap){
         AggregateResult[] groupedResults = [SELECT CALENDAR_Month(ConvertTimeZone(CreatedDate)),CALENDAR_YEAR(ConvertTimeZone(CreatedDate)),count(id),sum(AmountAllocated__c) 
                                             FROM PaymentAllocation__c
                                             WHERE agreement__c IN :agreementIDs
                                             GROUP BY CALENDAR_Month(ConvertTimeZone(CreatedDate)),CALENDAR_year(ConvertTimeZone(CreatedDate))
                                             ORDER BY CALENDAR_Month(ConvertTimeZone(CreatedDate)),CALENDAR_year(ConvertTimeZone(CreatedDate))];    
    
        for(AggregateResult ar:groupedResults){
            Integer month = (Integer)ar.get('expr0');
            Integer year = (Integer)ar.get('expr1');
            Integer count = (Integer)ar.get('expr2');
            Decimal sum = (Decimal)ar.get('expr3'); 
            
            String key = String.valueOf(month) + String.valueOf(year);
            if(outputMap.containsKey(key)){
                outputMap.get(key).numOfIsaPayments = count;
                outputMap.get(key).sumOfIsaPayments = sum;
            }
            
            /*
            Integer prevMonth = (month==1?(12):(month-1));
            Integer prevYear = (month==1?(year-1):(year));
            String newKey = String.valueOf(prevMonth) + String.valueOf(prevYear);
            Decimal cumulativePay = outputMap.containsKey(newKey)?outputMap.get(newKey).cumulativeIsaPaymentsMade:0;
            cumulativePay += sum; 
            outputMap.get(key).cumulativeIsaPaymentsMade = cumulativePay;
            */
        }
    }
    
    
    /////////////////////////////////////////////////
    ///Description: get delinquency data
    /////////////////////////////////////////////////
    private void getDelinquencyData(Set<ID> agreementIDs,Map<String,Set<ID>> sortedAgreementsMap,Map<String,ReportDataWrapper> outputMap){
        List<StudentProgramAudit__c> spaList = new List<StudentProgramAudit__c>();
        spaList = [SELECT daysdelinquent__c,studentprogram__c,auditdatetime__c,servicing__c
                   FROM StudentProgramAudit__c
                   WHERE monthEnd__c = true AND studentProgram__c IN :agreementIDs];
        for(StudentProgramAudit__c audit:spaList){
            Date auditDate = audit.auditdatetime__c.Date();
            String key = String.valueOf(auditDate.month()) + String.valueOf(auditDate.year());     
            if(sortedAgreementsMap.containsKey(key)){
                if(sortedAgreementsMap.get(key).contains(audit.studentProgram__c)){
                    if(audit.daysDelinquent__c >= 90){
                        if(outputMap.get(key).delinquencyData.num90Plus == null) outputMap.get(key).delinquencyData.num90Plus = 1;    
                        else outputMap.get(key).delinquencyData.num90Plus += 1;
                    } 
                    else if(audit.daysDelinquent__c >=60 && audit.daysDelinquent__c < 90){
                        if(outputMap.get(key).delinquencyData.num60TO89 == null) outputMap.get(key).delinquencyData.num60TO89 = 1;
                        else outputMap.get(key).delinquencyData.num60TO89 += 1;
                    }  
                    else if(audit.daysDelinquent__c >=30 && audit.daysDelinquent__c < 60){
                        if(outputMap.get(key).delinquencyData.num30TO59 == null) outputMap.get(key).delinquencyData.num30TO59 = 1;
                        else outputMap.get(key).delinquencyData.num30TO59 += 1;
                    } 
                    else if((audit.daysDelinquent__c >=0 && audit.daysDelinquent__c < 30) && audit.servicing__c ){
                        if(outputMap.get(key).delinquencyData.numOnTime == null) outputMap.get(key).delinquencyData.numOnTime = 1;
                        else outputMap.get(key).delinquencyData.numOnTime += 1;
                    } 
                }
            }
        }

        //if all column headers for a month are null then show NA
        //otherwise even if one column header has a value the set the nulls to 0
        for(String key:outputMap.keyset()){
            Decimal col1 = outputMap.get(key).delinquencyData.numOnTime;
            Decimal col2 = outputMap.get(key).delinquencyData.num30TO59;
            Decimal col3 = outputMap.get(key).delinquencyData.num60TO89;
            Decimal col4 = outputMap.get(key).delinquencyData.num90Plus;
            if(col1<>null || col2<>null || col3<>null || col4<>null){
                if(col1==null) outputMap.get(key).delinquencyData.numOnTime = 0;
                if(col2==null) outputMap.get(key).delinquencyData.num30TO59 = 0;
                if(col3==null) outputMap.get(key).delinquencyData.num60TO89 = 0;
                if(col4==null) outputMap.get(key).delinquencyData.num90Plus = 0; 
                outputMap.get(key).delinquencyData.totalDelinquent = outputMap.get(key).delinquencyData.num30TO59 + outputMap.get(key).delinquencyData.num60TO89 + outputMap.get(key).delinquencyData.num90Plus;
            }
        }           
    }
    
    /////////////////////////////////////////////////////////
    ///Description: Get income data
    /////////////////////////////////////////////////////////
    private void getIncomeData(Map<ID,Set<ID>> studentAgreementMap,Map<String,Set<ID>> sortedAgreementsMap,Map<String,ReportDataWrapper> outputMap){
        List<IncomeVerification__c> ivList = new List<IncomeVerification__c>();
        Decimal MinimumIncomePerMonth = [Select id,MinimumIncomePerMonth__c From Program__c Where Id =:selectedProgram].MinimumIncomePerMonth__c;
        ivList = [Select id,student__c,beginDate__c,endDate__c,type__c,IncomePerMonth__c 
                  From IncomeVerification__c
                  Where Student__c IN :studentAgreementMap.keySet() AND status__c = 'Verified'
                  Order By beginDate__c ASC,Student__r.name ASC,type__c DESC];
        Map<ID,List<IncomeVerification__c>> studentIncomeMap = new Map<ID,List<IncomeVerification__c>>();
        Map<String,List<Decimal>> incomeByMonth = new Map<String,List<Decimal>>();
        Map<String,Integer> numberBelowThreshold = new Map<String,Integer>();
        
        //sort the IV's by student
        //sorted by begin date by the query 
        for(IncomeVerification__c iv:ivList){
            if(!studentIncomeMap.containsKey(iv.student__c)){
                studentIncomeMap.put(iv.student__c,new List<IncomeVerification__c>());
            }
            studentIncomeMap.get(iv.student__c).add(iv);
        }
        for(ID theID:studentIncomeMap.keySet()){
            List<IncomeVerification__c> incomes = studentIncomeMap.get(theID);
            Integer size = incomes.size();
            Integer beginMonth;
            Integer beginYear; 
            Integer endMonth;
            Integer endYear;             
            for(Integer i=0; i<size;i++){
                if(i==(size-1)){
                    //this is the latest income of the student  
                    beginMonth = incomes[i].beginDate__c.month();
                    beginYear = incomes[i].beginDate__c.year();
                    if(currentMonth == 1){
                        endMonth = 12;
                        endYear = currentYear -1;
                    }
                    else{ 
                        endMonth = currentMonth-1;
                        endYear = currentYear;  
                    } 
                }
                else{
                    //there are more income records after this
                    beginMonth = incomes[i].beginDate__c.month();
                    beginYear = incomes[i].beginDate__c.year();
                    endMonth = incomes[i+1].beginDate__c.month();
                    endYear = incomes[i+1].beginDate__c.year();
                    if(beginMonth == endMonth && beginYear == endYear){
                        continue;    
                    }
                    if(endMonth == 1){
                        endMonth = 12;
                        endYear = endYear - 1;
                    }
                    else{ 
                        endMonth = endMonth - 1;
                    } 
                }
                while((beginMonth<=endMonth && beginYear==endYear) || (beginYear<endYear)){
                    String key = String.valueOf(beginMonth) + String.valueOf(beginYear);
                    Boolean skip;
                    for(Id agreementID:studentAgreementMap.get(theID)){
                        skip = false;
                        if(sortedAgreementsMap.containsKey(key)){
                            if(sortedAgreementsMap.get(key).contains(agreementID)) break;
                        }
                        skip = true;
                    }
                    if(!skip){
                        //add the income to the key month
                        if(!incomeByMonth.containsKey(key)){
                            incomeByMonth.put(key,new List<Decimal>());
                        }
                        incomeByMonth.get(key).add(incomes[i].IncomePerMonth__c); 
                        //check if income below threshold
                        if(!numberBelowThreshold.containsKey(key)){
                            numberBelowThreshold.put(key,0);
                        }
                        if(incomes[i].IncomePerMonth__c<MinimumIncomePerMonth) numberBelowThreshold.put(key,numberBelowThreshold.get(key)+1);
                    }
                    //increment the counters
                    if(beginMonth==12){
                        beginMonth=1;
                        beginYear++;
                    }
                    else{
                        beginMonth++;
                    }
                }
            }
        }
        //calulate stats from the incomeByMonth
        for(String key:incomeByMonth.keySet()){
            List<Decimal> incomes = incomeByMonth.get(key);
            incomes.sort();
            Integer size = incomes.size();
            Integer index;
            Decimal result;
            //minimum income
            outputMap.get(key).incData.minIncome = incomes[0]; 
            //maximum income
            outputMap.get(key).incData.maxIncome = incomes[size-1];
            //calculate median
            if(size>=3){
                if(Math.mod(size,2) == 0){
                    index = Integer.valueOf(size*0.5);
                    result = incomes[index]; 
                    result += incomes[index-1];
                    result /= 2;
                    outputMap.get(key).incData.median = result;
                }
                else{
                    index = Integer.valueOf(size*0.5);
                    result = incomes[index];
                    outputMap.get(key).incData.median = result;    
                }
            }
            //calculate 25th percentile
            if(size>=4){
                if(Math.mod(size,4) == 0){
                    index = Integer.valueOf(size*0.25);
                    result = incomes[index]; 
                    result += incomes[index-1];
                    result /= 2;
                    outputMap.get(key).incData.twentyFifthTile = result;
                }
                else{
                    Decimal temp = size*0.25;
                    temp.round(System.RoundingMode.HALF_EVEN);
                    index = Integer.valueOf(temp);
                    result = incomes[index];
                    outputMap.get(key).incData.twentyFifthTile = result;    
                }    
            }  
            //calculate 75th percentile
            if(size>=4){
                if(Math.mod(size,4) == 0){
                    index = Integer.valueOf(size*0.75);
                    result = incomes[index]; 
                    result += incomes[index-1];
                    result /= 2;
                    outputMap.get(key).incData.seventyFifthTile = result;
                }
                else{
                    Decimal temp = size*0.75;
                    temp.round(System.RoundingMode.HALF_EVEN);
                    index = Integer.valueOf(temp);
                    result = incomes[index];
                    outputMap.get(key).incData.seventyFifthTile = result;    
                }    
            }
            //Below minimum income threshold
            System.debug('@@@Below'+numberBelowThreshold.get(key));
            Decimal percent = Decimal.valueOf(numberBelowThreshold.get(key)*100)/size; 
            System.debug('@@@Total'+size);
            System.debug('@@@Percent'+percent);
            //outputMap.get(key).incData.numberBelowThreshold = numberBelowThreshold.get(key);
            outputMap.get(key).incData.numberBelowThreshold = numberBelowThreshold.get(key);
            outputMap.get(key).incData.percentBelowThreshold = percent.setScale(2);
                    
        }
    }
    
    /////////////////////////////////////////////////////
    ///Description: get Deferment data
    /////////////////////////////////////////////////////
    private void getDefermentData(Map<ID,Set<ID>> studentAgreementMap,Map<String,Set<ID>> sortedAgreementsMap,Map<String,ReportDataWrapper> outputMap){
        List<Deferment__c> deferments = new List<Deferment__c>();
        deferments = [SELECT id,type__c,beginDate__c,endDate__c,student__c
                      FROM Deferment__c
                      WHERE student__c IN :studentAgreementMap.keySet()
                      ORDER BY beginDate__c ASC];    
        Map<id,List<Deferment__c>> studentDefermentMap = new Map<Id,List<Deferment__c>>();
        for(Deferment__c def:deferments){
            if(!studentDefermentMap.containsKey(def.student__c)){
                studentDefermentMap.put(def.student__c,new List<Deferment__c>());
            }
            studentDefermentMap.get(def.student__c).add(def);
        }
        
        /*******************************************************************/
        for(ID theID:studentDefermentMap.keySet()){
            Integer beginMonth;
            Integer beginYear; 
            Integer endMonth;
            Integer endYear;             
            for(Deferment__c def:studentDefermentMap.get(theID)){
                
                if(def.beginDate__c == null || def.endDate__c == null){
                    continue;
                }
                
                beginMonth = def.beginDate__c.month();
                beginYear = def.beginDate__c.year();
                endMonth = def.endDate__c.month();
                endYear = def.endDate__c.year();
                
                //skip if the beginDate falls in current month or beyond
                if((beginMonth >= currentMonth && beginYear == currentYear) || (beginYear > currentYear)){
                    continue;
                }
                 
                //if end month falls in current month or beyond set it to currentMonth -1
                if((endMonth >= currentMonth && endYear == currentYear) || (endYear > currentYear)){
                    if(currentMonth == 1){
                        endMonth = 12;
                        endYear = currentYear -1;
                    }
                    else{
                        endMonth = currentMonth -1;
                        endYear = currentYear;                            
                    }
                }    
                    
                while((beginMonth<=endMonth && beginYear==endYear) || (beginYear<endYear)){
                    String key = String.valueOf(beginMonth) + String.valueOf(beginYear);
                    Boolean skip;
                    for(Id agreementID:studentAgreementMap.get(theID)){
                        skip = false;
                        if(sortedAgreementsMap.containsKey(key)){
                            if(sortedAgreementsMap.get(key).contains(agreementID)) break;
                        }
                        skip = true;
                    }
                    if(!skip){
                        //add the deferment type to the ouput map
                        if(outputMap.containsKey(key)){
                            if(outputMap.get(key).defermentData == null){
                                outputMap.get(key).defermentData = new DefermentType();        
                            }
                            if(def.type__c == 'Below minimum income, working full-time' || def.type__c == 'Below minimum income, working part-time') outputMap.get(key).defermentData.lowIncome += 1;
                            if(def.type__c == 'Unemployed, seeking employment' || def.type__c == 'Unemployed, not seeking employment') outputMap.get(key).defermentData.notInLaborForce += 1;
                            if(def.type__c == 'Enrolled in School') outputMap.get(key).defermentData.reEnrolled += 1;
                        }
                    }
                    //increment the counters
                    if(beginMonth==12){
                        beginMonth=1;
                        beginYear++;
                    }
                    else{
                        beginMonth++;
                    }
                }
            }
        }
        /*******************************************************************/
    } 
    
    private Static String getMonthName(Integer monthNum){
        if(monthNum == 1) return 'Jan';
        if(monthNum == 2) return 'Feb';
        if(monthNum == 3) return 'Mar';
        if(monthNum == 4) return 'Apr';
        if(monthNum == 5) return 'May';
        if(monthNum == 6) return 'Jun';
        if(monthNum == 7) return 'Jul';
        if(monthNum == 8) return 'Aug';
        if(monthNum == 9) return 'Sep';
        if(monthNum == 10) return 'Oct';
        if(monthNum == 11) return 'Nov';
        if(monthNum == 12) return 'Dec';
        return '';    
    }
    
    private Static Integer getMonthNumber(String monthName){
        if(monthName == 'Jan') return 1;
        if(monthName == 'Feb') return 2;
        if(monthName == 'Mar') return 3;
        if(monthName == 'Apr') return 4;
        if(monthName == 'May') return 5;
        if(monthName == 'Jun') return 6;
        if(monthName == 'Jul') return 7;
        if(monthName == 'Aug') return 8;
        if(monthName == 'Sep') return 9;
        if(monthName == 'Oct') return 10;
        if(monthName == 'Nov') return 11;
        if(monthName == 'Dec') return 12;
        return 0;
    }
    
    ////////////////////////////////////////
    ///Set the report mode
    ////////////////////////////////////////
    private void setMode(){
        //get page name and set the flow accordingly
        //{1=> MonthlyInvestorReport, 2 => SalesForecast}
        String currentPage = ApexPages.currentPage().getParameters().get('currentvfpage');
        if(currentPage == 'ReportMonthlyInvestorPeriodic'){
            mode = '1';
            fileName = 'MonthlyInvestorReport-Periodic.csv';
        }
        if(currentPage == 'ReportSalesForecast'){
            mode = '2';
            fileName = 'SalesForecastReport-ActualData.csv';
        }
    }
    
    ////////////////////////////////////////
    ///Call the export VF Page
    ////////////////////////////////////////
    public PageReference exportToCSV(){
        //set the mode
        setMode();
        PageReference pg = new PageReference('/apex/ReportMonthlyInvestorPeriodicExport?mode=');
        pg.setRedirect(false);
        return pg;
    }
    
    ////////////////////////////////////////
    ///Generate a csv string
    ////////////////////////////////////////
    public void buildCsvString(){
        buildReportData();
            
        if(reportData == null || reportData.size()==0) return;
        
        if(mode == '1'){
            csv = 'MONTH,REMAINING ISA ASSETS,ISA PAYMENTS MADE(#),ISA PAYMENTS MADE($),CUMULATIVE ISA PAYMENTS MADE($),';
            csv += 'IN SCHOOL(#),PERCENT IN SCHOOL,GRADUATED/DROPPED OUT(#),PERCENT GRADUATED/DROPPED OUT,IN GRACE(#),';
            csv += 'PERCENT IN GRACE,IN PAYMENT(#),PERCENT IN PAYMENT,IN DEFERMENT(#),PERCENT IN DEFERMENT,DEFAULT,PAID OFF,';
            csv += 'ON TIME,30-59 DAYS DELINQUENT,60-89 DAYS DELINQUENT,90+ DAYS DELINQUENT,';
            csv += 'MIN INCOME,25th TILE,MEDIAN,75th TILE,MAX INCOME,BELOW MIN INCOME THRESHOLD(#)';
            csv += '\n';
            
            Decimal cumulativePayment = 0;
            Decimal percentInSchool;
            Decimal percentGraduated;
            Decimal percentGrace;
            Decimal percentPayment;
            Decimal percentDeferment;
            Decimal numDefault = 0;
            Decimal numPaid = 0;
            Decimal numOfIsaAssets = 0; //used for promoting numerators to Decimal while calculating percentages
            for(reportDataWrapper row:reportData){
                numOfIsaAssets = row.numOfIsaAssets;
                cumulativePayment += row.sumOfIsaPayments;
                numDefault += row.accStatus.numDefault;
                numPaid += row.accStatus.numPaid;
                percentInSchool = (row.enrollmentData.numInSchool/numOfIsaAssets)*100; 
                percentInSchool = percentInSchool.setScale(2);
                percentGraduated = (row.enrollmentData.numGraduated/numOfIsaAssets)*100;
                percentGraduated = percentGraduated.setScale(2);
                System.debug('###percentGraduated:'+percentGraduated);
                percentGrace = (row.numInGrace/numOfIsaAssets)*100;
                percentGrace = percentGrace.setScale(2);
                percentPayment = (row.numInPayment/numOfIsaAssets)*100;
                percentPayment = percentPayment.setScale(2);
                percentDeferment = (row.numInDeferment/numOfIsaAssets)*100;
                percentDeferment = percentDeferment.setScale(2);
                
                csv += row.month  + ',';
                csv += row.numOfIsaAssets + ',';
                csv += row.numOfIsaPayments + ',';
                csv += row.sumOfIsaPayments + ',';
                csv += cumulativePayment + ',';
                csv += row.enrollmentData.numInSchool + ',';
                csv += percentInSchool + ',';
                csv += row.enrollmentData.numGraduated + ',';
                csv += percentGraduated + ',';
                csv += row.numInGrace + ',';
                csv += percentGrace + ',';
                csv += row.numInPayment + ',';
                csv += percentPayment + ',';
                csv += row.numInDeferment + ',';
                csv += percentDeferment + ',';
                csv += numDefault + ',';
                csv += numPaid + ',';
                if(row.delinquencyData.numOnTime == null) csv += ',';
                else csv += row.delinquencyData.numOnTime + ',';
                
                if(row.delinquencyData.num30To59 == null) csv += ',';
                else csv += row.delinquencyData.num30To59 + ',';
                
                if(row.delinquencyData.num60To89 == null) csv += ',';
                else csv += row.delinquencyData.num60To89 + ',';
                
                if(row.delinquencyData.num90Plus == null) csv += ',';
                else csv += row.delinquencyData.num90Plus + ',';
                
                if(row.incData.minIncome == null) csv += ',';
                else csv += row.incData.minIncome + ',';
                
                if(row.incData.twentyFifthTile == null) csv += ',';
                else csv += row.incData.twentyFifthTile + ',';
                
                if(row.incData.median == null) csv += ',';
                else csv += row.incData.median + ',';
                
                if(row.incData.seventyFifthTile == null) csv += ',';
                else csv += row.incData.seventyFifthTile + ',';
                
                if(row.incData.maxIncome == null) csv += ',';
                else csv += row.incData.maxIncome + ',';
                
                if(row.incData.numberBelowThreshold == null) csv += '';
                else csv += row.incData.numberBelowThreshold;
                
                //if(row.incData.percentBelowThreshold == null) csv += '' + '';
                //else csv += row.incData.percentBelowThreshold + ',';
                
                csv += '\n';
                
            }
        }
        if(mode == '2'){
            csv = 'MONTH,REMAINING ISA ASSETS(#),IN SCHOOL,DROPPED OUT/GRADUATED,TOTAL,IN GRACE,REENROLLED,IN PAYMENT,TOTAL,';
            csv += 'NOT IN LABOR FORCE,LOW INCOME,DELINQUENT,TOTAL,MONTHLY($),CUMULATIVE($)';
            csv += '\n';
            
            Decimal cumulativePayment = 0;
            Integer totalEnrollmentStatus = 0; 
            Integer totalAccountStatus = 0;
            Integer totalPaymentStatus = 0;
            
            for(reportDataWrapper row:reportData){
                cumulativePayment += row.sumOfIsaPayments;
                totalEnrollmentStatus = row.enrollmentData.numInSchool + row.enrollmentData.numGraduated; 
                totalAccountStatus = row.numInGrace + row.defermentData.reEnrolled + row.numInPayment; 
                totalPaymentStatus = row.defermentData.notInLaborForce + row.defermentData.lowIncome;
                if(row.delinquencyData.totalDelinquent <> null) totalPaymentStatus += row.delinquencyData.totalDelinquent;
                 
                csv += row.month  + ',';
                csv += row.numOfIsaAssets + ',';
                
                csv += row.enrollmentData.numInSchool + ',';
                csv += row.enrollmentData.numGraduated + ',';
                csv += totalEnrollmentStatus + ',';
                
                csv += row.numInGrace + ',';
                csv += row.defermentData.reEnrolled + ',';
                csv += row.numInPayment + ',';
                csv += totalAccountStatus + ',';
                
                csv += row.defermentData.notInLaborForce + ',';
                csv += row.defermentData.lowIncome + ','; 
                if(row.delinquencyData.totalDelinquent == null) csv += ',';
                else csv += row.delinquencyData.totalDelinquent + ',';
                csv += totalPaymentStatus + ',';
                
                csv += row.sumOfIsaPayments + ',';
                csv += cumulativePayment;
                
                csv += '\n';
                
            }
        }
    }
    
    /////////////////////////////////////////
    ///Wrapper to hold report data
    ///////////////////////////////////////////
    public class reportDataWrapper implements Comparable{
        public String month {get;set;}
        public Integer numOfIsaAssets {get;set;}
        public Integer numOfIsaPayments {get;set;}
        public Decimal sumOfIsaPayments {get;set;}
        public Decimal cumulativeIsaPaymentsMade {get;set;}
        public Integer numInGrace {get;set;}
        public Integer numInPayment {get;set;}
        public Integer numInDeferment {get;set;}
        public AccountStatus accStatus {get;set;} 
        public EnrollmentStatus enrollmentData {get;set;}
        public DelinquencyStatus delinquencyData {get;set;}
        public IncomeData incData {get;set;}
        public DefermentType defermentData {get;set;}
    
        public Integer compareTo(Object compareTo){
            reportDataWrapper compareToElement = (reportDataWrapper)compareTo;
            
            String [] compateToDateStrAr;
            String [] instanceDateStrAr;

            if(compareToElement.month <> null) compateToDateStrAr = compareToElement.month.split('-');
            else return 1;
            if(month <> null) instanceDateStrAr = month.split('-'); 
            else return -1;
            
            Date compareWith = Date.newInstance(Integer.valueOf(compateToDateStrAr[1]), ReportMnthlyInvstrPeriodicController.getMonthNumber(compateToDateStrAr[0]), 1);
            Date instance = Date.newInstance(Integer.valueOf(instanceDateStrAr[1]), ReportMnthlyInvstrPeriodicController.getMonthNumber(instanceDateStrAr[0]), 1);
            
            if(instance == compareWith) return 0;
            if(instance > compareWith) return 1; 
            return -1;
        }
    }
    
    ////////////////////////////////////
    ///Enrollment Status Wrapper
    ////////////////////////////////////    
    public class EnrollmentStatus{
        public Integer numInSchool {get;set;}
        public Integer numGraduated {get;set;} 
        
        public EnrollmentStatus(){
            this.numInSchool = 0;
            this.numGraduated = 0;
        }
    }
    
    ////////////////////////////////////
    ///Account Status Wrapper
    ////////////////////////////////////
    public class AccountStatus{
        public Integer numDefault {get;set;}
        public Integer numPaid {get;set;}
        
        public AccountStatus(){
            this.numDefault = 0;
            this.numPaid = 0;
        }
    }
    
    ///////////////////////////////////
    ///Payment Status Wrapper
    ///////////////////////////////////
    public class DelinquencyStatus{
        public Integer numOnTime {get;set;}
        public Integer num30To59 {get;set;}
        public Integer num60To89 {get;set;}
        public Integer num90Plus {get;set;}
        public Integer totalDelinquent {get;set;}
    }
    
    //////////////////////////////////////
    ///Income data wrapper
    //////////////////////////////////////
    public class IncomeData{
        public Decimal minIncome {get;set;}
        public Decimal maxIncome {get;set;}
        public Decimal median {get;set;}
        public Decimal twentyFifthTile {get;set;}
        public Decimal seventyFifthTile {get;set;}
        public Decimal numberBelowThreshold {get;set;}
        public Decimal percentBelowThreshold {get;set;}
    }
    
    ////////////////////////////////////////
    ///Defertment type wrapper
    ////////////////////////////////////////
    public class DefermentType{
        public Integer lowIncome {get;set;}
        public Integer notInLaborForce {get;set;}
        public Integer reEnrolled {get;set;} 
        
        public DefermentType(){
            this.lowIncome = 0;
            this.notInLaborForce = 0;
            this.reEnrolled = 0;
        }   
    }
}