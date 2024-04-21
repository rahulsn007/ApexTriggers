//! Close opportunities with probablity grater then 70% when checkbox is checked on account.

public with sharing class CloseOpportunityClass {
  
    public static void CloseOpportunities(List<Account> accList, Map<Id, Account> oldMap){

        Set<Id>  accIds = new Set<Id>();

        if (!accList.isEmpty()) {
            for (Account acc : accList) {
                if(acc.Close_Opportunity_70__c == true && oldMap.get(acc.Id).Close_Opportunity_70__c == false && oldMap.containsKey(acc.Id) ){
                    accIds.add(acc.Id);
                }
            }
        }

        if(!accIds.isEmpty()){
            List<Opportunity> relatedOppy =[SELECT id, accountid, stageName, Probability FROM Opportunity
                                             WHERE accountid IN :accIds and stageName != 'Closed Won' AND Probability >=70 ];

            List<Opportunity> opsToUpdate = new  List<Opportunity>();                                

             for(Opportunity ops : relatedOppy){
                ops.stageName = 'Closed Won';
                ops.CloseDate  = date.today();
                opsToUpdate.add(ops);
             }
             
             if(!opsToUpdate.isEmpty()){
                UPDATE opsToUpdate;
             }

        }
    }
}