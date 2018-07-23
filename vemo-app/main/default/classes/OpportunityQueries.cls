/////////////////////////////////////////////////////////////////////////
// Class: OpportunityQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public class OpportunityQueries {
	public static Map<ID, Opportunity> getOpportunityMapByID(){
		return new Map<ID, Opportunity>([SELECT id,
										   Name,
										   StageName,
										   CloseDate
									 	 FROM Opportunity
										 LIMIT 50000]);
	}
}