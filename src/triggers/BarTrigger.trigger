trigger BarTrigger on Bar__c (before update) {  
    
    for (Bar__c b: Trigger.new) {  
        
        if(!System.isFuture()){
            
            Bar__c oldbar = Trigger.oldMap.get(b.Id);
            
            
            b.Apex_Rollback__c = false;
            b.Apex_Rollback_Description__c = '';
            b.MessageShow__c = 'INFO';
            
            CalloutClass.makeCallout(b.Id, b.OwnerId, b.Name, b.Address__c);
            
            b.Name = oldbar.Name; 
            b.Address__c = oldbar.Address__c;
        }   
    } 
}