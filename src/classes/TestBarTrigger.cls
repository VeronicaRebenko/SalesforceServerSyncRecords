@isTest
public class TestBarTrigger {
    @isTest static void TestBarTriggerValidation() {
        // Test data setup
        // Create an record, and then try to edit it
        Bar__c b = new Bar__c(Name='Cool Bar', Address__c='123 Apple Str.', OwnerId = UserInfo.getUserId(),
                                Apex_Rollback__c = false, Apex_Rollback_Description__c = '', MessageShow__c='');
        insert b;
        Bar__c oldbar = new Bar__c();
        oldbar = b;
        
        b.Name='MyCool Bar%';
        upsert b;
        
        Test.setMock(HttpCalloutMock.class, new CalloutClassMock()); 
        // Perform test
        Test.startTest();
        
    
    	// This causes a fake response to be sent
    	// from the class that implements HttpCalloutMock. 
    	CalloutClass.makeCallout(b.Id, b.OwnerId, b.Name, b.Address__c);
        
      // Database.UpsertResult result = Database.up sert(b, false);
        Test.stopTest();
        
    }

}