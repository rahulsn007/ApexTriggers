trigger highestAmountOnAccountTrigger on Opportunity (after insert, after update, after delete, after undelete) {

    if(Trigger.isAfter && Trigger.isUpdate){
        highestAmountOppName.oppNameOnAccount(Trigger.new, Trigger.oldMap);
    }
    
    else if(Trigger.isAfter && Trigger.isDelete){
        highestAmountOppName.oppNameOnAccount(Trigger.old, null);
    }
    else{
        highestAmountOppName.oppNameOnAccount(Trigger.new, null);  //A insert and undelete 
    }
}


// trigger highestAmountOnAccountTrigger on Opportunity (after insert, after update, after delete, after undelete) {
//     if (Trigger.isAfter) {
//         if (Trigger.isInsert || Trigger.isUpdate) {
//             highestAmountOppName.oppNameOnAccount(Trigger.new, Trigger.oldMap);
//         } else if (Trigger.isDelete || Trigger.isUndelete) {
//             highestAmountOppName.oppNameOnAccount(null, Trigger.oldMap);
//         }
//     }
// }
