/////////////////////////////////////////////////////////////////////////
// Class: RenderStatementCTRL
// 
// Description: 
// 	Controller for RenderStatmentComponent
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-19   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class RenderStatementCTRL {
	public StatementService.StatementV1 statement {get;set;}
	public RenderStatementCTRL() {
		Id studentId = (Id)ApexPages.currentPage().getParameters().get('id');
		Map<ID, StatementService.StatementV1> statementMap = StatementService.getCurrentStatementV1ByStudentWithStudentID(new Set<Id>{studentId});
		statement = statementMap.values().get(0);
		
	}
}