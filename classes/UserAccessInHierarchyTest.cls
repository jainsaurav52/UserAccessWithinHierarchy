/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description   :-  Apex test class for UserAccessInHierarchy
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author        :-  Saurav Jain <saurav.jain@salesforce.com>
* @Company       :-  Salesforce
* @version       :-  1.0
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

@isTest
public class UserAccessInHierarchyTest {

    @testSetup
    static void createSetupData(){
        
        Id tempId = [SELECT Id FROM Profile WHERE Name =: 'Sales Manager' limit 1]?.Id;
        User user1;
        User user2;
        User user3;
        System.runAs(new User(Id = UserInfo.getUserId())){
            user1 = TestDataFactoryUtility.getUser(tempId, null, true);
            user2 = TestDataFactoryUtility.getUser(tempId, null, false);
            user2.ManagerId = user1.Id;
            insert user2;
            user3 = TestDataFactoryUtility.getUser(tempId, null, false);
            user3.ManagerId = user2.Id;
            insert user3;
            
        }
        Account objAcc = TestDataFactoryUtility.getAccount(Effectv_GlobalConstants.CONST_ADVERTISER_ACCOUNT_RECORDTYPE, user3.id, true);
        
    }
    
    @isTest
    public static void checkUserAccessTest(){
        Account acc = [select id,Owner.managerID from Account limit 1];
        System.runAs(new User(Id = acc.Owner.managerID)){
			Test.startTest();
            Boolean result = UserAccessInHierarchy.checkUserAccess(acc?.Id);
            Test.stopTest();
        }
    }
    @isTest
    public static void checkOwnerAccessTest(){
        Account acc = [select id,ownerId from Account limit 1];
        System.runAs(new User(Id = acc.OwnerId)){
		Test.startTest();
        Boolean result = UserAccessInHierarchy.checkUserAccess(acc?.Id);
        Test.stopTest();
        System.assertEquals(true, result,'User has access and is owner of record');
        }
        
    }
}