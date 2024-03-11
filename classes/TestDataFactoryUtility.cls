/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description   :-  Test Data Factory Utility class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author        :-  Saurav Jain <saurav.jain@salesforce.com>
* @Company       :-  Salesforce
* @version       :-  1.0
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

@isTest
public class TestDataFactoryUtility {

    public static Account getAccount(String recordType, Boolean doInsert) {
        Account testAcc = new Account();
        testAcc.Name = 'Test Account ' + Crypto.getRandomInteger();
		testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();testAcc.ShippingCity='test';
        testAcc.ShippingCountry ='Australia';
        testAcc.ShippingState = 'Queensland';
        testAcc.ShippingStreet = 'test';
        testAcc.ShippingPostalCode ='1234';
        if(doInsert){
        	insert testAcc;
        }
        return testAcc;
    }
    public static List<Account> getAccounts(String recordType, Boolean doInsert, Integer numAccs) {
        List<Account> tempAcc = new List<Account>();
        for(Integer i = 0; i < numAccs; i++){
            Account testAcc = new Account();
            testAcc.Name = 'Test Account ' + Crypto.getRandomInteger();
            testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();testAcc.ShippingCity='test';
            testAcc.ShippingCountry ='Australia';
            testAcc.ShippingState = 'Queensland';
            testAcc.ShippingStreet = 'test';
            testAcc.ShippingPostalCode ='1234';
            tempAcc.add(testAcc);
        }
        if(doInsert){
        	insert tempAcc;
        }
        return tempAcc;
    }
    public static Account getAccount(String recordType, Id userId, Boolean doInsert) {
        Account testAcc = new Account();
        testAcc.Name = 'Test Account ' + Crypto.getRandomInteger();
		testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();testAcc.ShippingCity='test';
        testAcc.ShippingCountry ='Australia';
        testAcc.ShippingState = 'Queensland';
        testAcc.ShippingStreet = 'test';
        testAcc.ShippingPostalCode ='1234';
        testAcc.OwnerId = userId;
        if(doInsert)
        {
            insert testAcc;  
        }        
        return testAcc;
    }
    
    
    public static UserRole getUserRole(String name, Id parentRoleId, Boolean doInsert){
        UserRole ur = new UserRole();
        ur.Name = name;
        ur.ParentRoleId = parentRoleId;
        if(doInsert){
        	insert ur;
        }
        return ur;
    }
    public static User getUser(Id profileId, Id urId, Boolean doInsert){
        User user = new User();
        user.ProfileId = profileId;
        user.Email = 'puser@gmail.com';
		user.Username = 'puser2@gmail.com' + System.currentTimeMillis();
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.UserRoleId = urId;
        user.LastName = 'lastname' + Crypto.getRandomInteger();
        if(doInsert){
        	insert user;
        }
        return user;
    }
   
    
}