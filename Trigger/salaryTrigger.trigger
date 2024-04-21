trigger salaryTrigger on Employee_Detail__c (after insert, after update, after delete, after undelete) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        salaryHelperClass.salaryUpdate(Trigger.new, Trigger.oldMap);
    }
    
    else if(Trigger.isAfter && Trigger.isDelete){
        salaryHelperClass.salaryUpdate(Trigger.old, null);
    }
    else{
        salaryHelperClass.salaryUpdate(Trigger.new, null);  //A insert and undelete 
    }
    
}