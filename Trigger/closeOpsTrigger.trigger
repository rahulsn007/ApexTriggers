trigger closeOpsTrigger on Account (after update) {
if(Trigger.isAfter && Trigger.isUpdate){
    CloseOpportunityClass.CloseOpportunities(trigger.new, trigger.oldMap);

 }
}