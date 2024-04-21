// public with sharing class highestAmountOppName {
//     public static void oppNameOnAccount(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
//         Set<Id> oppIds = new Set<Id>();
     
//          if(!newList.isEmpty()){
//             for(Opportunity newOpps : newList){
//                 if(oldMap != null){
//                     Opportunity oldOpps = oldMap.get(newOpps.Id);   // To get old values of record
//                     if(oldOpps.AccountId != newOpps.AccountId){
//                         oppIds.add(oldOpps.AccountId);
//                         oppIds.add(newOpps.AccountId);
//                     }
//                     else{
//                         oppIds.add(newOpps.AccountId);  // when user update field values and no change in parent 
//                     }
//                 }
//                 else{
//                     oppIds.add(newOpps.AccountId);   // apart from update operation like insert delete, undelete
//                 }
//             }
             

//          }

//          List<AggregateResult> arrList = [SELECT Max(Amount) highestAmount, AccountId FROM Opportunity where AccountId IN : oppIds group by AccountId
//                                             ORDER BY MAX(Amount) desc limit 1 ];

//          Map<Id, Account> accountToUpdate = new Map<Id, Account>();
//          if(!arrList.isEmpty()){
//             for(AggregateResult ar : arrList){
//                 Id accId = (Id) ar.get('AccountId');
//                 Decimal maxOppAmount = (Decimal) ar.get('highestAmount');
//                 Account acc = new Account(Id = accId, Opportunity_Name_with_Highest_Amount__c = [SELECT Name FROM Opportunity WHERE AccountId = :accId AND Amount = :maxOppAmount LIMIT 1].Name);
//                 accountToUpdate.put(acc.Id, acc);
//             }

//             if(!accountToUpdate.isEmpty()){
//                 update accountToUpdate.values();
//             }
             
//          }
//     }
// }



/**
 * Update Opportunity_Name_with_Highest_Amount__c field on account with opportunity which having
 * highest amount
 */
public with sharing class highestAmountOppName {
    public static void oppNameOnAccount(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        Set<Id> oppIds = new Set<Id>();
     
         if(!newList.isEmpty()){
            for(Opportunity newOpps : newList){
                if(oldMap != null){
                    Opportunity oldOpps = oldMap.get(newOpps.Id);   // To get old values of record
                    if(oldOpps.AccountId != newOpps.AccountId){
                        oppIds.add(oldOpps.AccountId);
                        oppIds.add(newOpps.AccountId);
                    }
                    else{
                        oppIds.add(newOpps.AccountId);  // when user update field values and no change in parent 
                    }
                }
                // else if (oldMap != null) {
                //     // If all Opportunities were deleted, set oppIds from the old map
                //     oppIds.add(oldMap.keySet());
                // }
                else{
                    oppIds.add(newOpps.AccountId);   // apart from update operation like insert delete, undelete
                }
            }
             

         }
         Map<Id, Account> accountToUpdate = new Map<Id, Account>();
         // if all opp deleted
      

         List<AggregateResult> arrList = [SELECT Max(Amount) highestAmount, AccountId, Name FROM Opportunity where AccountId IN : oppIds group by AccountId, Name
                                            ORDER BY MAX(Amount) desc limit 1 ];

        
         if(!oppIds.isEmpty()){
            for(AggregateResult ar : arrList){
                 Account acc = new Account();
                 acc.id = (Id)ar.get('AccountId');
                 acc.Opportunity_Name_with_Highest_Amount__c  = (String)ar.get('Name');
                 Decimal maxOppAmount = (Decimal) ar.get('highestAmount');
                 accountToUpdate.put(acc.id, acc);
            }

            if(!accountToUpdate.isEmpty()){
                update accountToUpdate.values();
            }
             
         }

    }
}