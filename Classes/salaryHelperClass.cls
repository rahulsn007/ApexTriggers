/*
Update salary employee on tech firm object's field Min and Max
*/
public class salaryHelperClass {
    
    public static void salaryUpdate(List<Employee_Detail__c> empList, Map<Id, Employee_Detail__c> oldMap){
        Set<Id> parentIds = new Set<Id>(); // id of tech firm object
        
        if(!empList.isEmpty()){  // there can be situation where user can change the parent of child record in that case we need id of new parent as well as old parent
            for(Employee_Detail__c newEmp :empList)
            {
                if(oldMap != null){                                   // this block mailny for update
                    Employee_Detail__c oldEmp = oldMap.get(newEmp.id);  // to get old value of record
                    if(oldEmp.Tech_Firm__c != newEmp.Tech_Firm__c)     // new parent != old parent
                    {
                        parentIds.add(oldEmp.Tech_Firm__c);
                        parentIds.add(newEmp.Tech_Firm__c);
                    }
                    else
                    {
                        parentIds.add(newEmp.Tech_Firm__c);     // when user update field values and no change in parent 
                    }
                }
                else{
                          parentIds.add(newEmp.Tech_Firm__c);    // apart from update operation  ! If there are no updates to existing records (i.e., oldMap is empty), it adds the Tech_Firm__c value of the new record to the parentIds set.
                }
            }
        }
        
         Map<Id,Tech_Firm__c>  mapToUpdate = new  Map<Id,Tech_Firm__c>();
         
         //if employee record are NOT present
           for(Id ids : parentIds){
            Tech_Firm__c tf = new Tech_Firm__c();
            tf.id = ids;
            tf.Max_Salary__c = 0;
            tf.Min_Salary__c = 0;
            mapToUpdate.put(tf.Id, tf);
        }
        System.debug('rsn ' + mapToUpdate.keySet());
        System.debug('rsn v ' + mapToUpdate.values());
        
        List<AggregateResult> arrList = [SELECT Tech_Firm__c tfid, max(Salary__c) MaxSalary, Min(Salary__c) MinSalary
                                         FROM Employee_Detail__c WHERE Tech_Firm__c IN : parentIds group by Tech_Firm__c];
        
        
        //if employee record are present
        if(!arrList.isEmpty()){
            for(AggregateResult ar : arrList){
                Tech_Firm__c tf = new Tech_Firm__c();
                tf.id = (Id)ar.get('tfid');
                tf.Max_Salary__c = (Decimal)ar.get('MaxSalary');
                tf.Min_Salary__c = (Decimal)ar.get('MinSalary');
                mapToUpdate.put(tf.Id, tf);              
            }
            if(!mapToUpdate.isEmpty()){
                update mapToUpdate.values();
            }
            
        }
        
    }
}