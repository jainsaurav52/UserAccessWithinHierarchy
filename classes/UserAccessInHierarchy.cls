/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* @description   :-  Apex class To check user access within User hierarchy
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author        :-  Saurav Jain <saurav.jain@salesforce.com>
* @Company       :-  Salesforce
* @version       :-  1.0
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public with sharing class UserAccessInHierarchy {

    /**************************************************************************************************
    * @description: Method to check if user has access within role hierarchy
    * @param:  ID recordId, string buttonName
    * @return: boolean
    **************************************************************************************************/
    @AuraEnabled
    public static Boolean checkUserAccess(Id recordId){
        try{
            Set<Id> roleIds = new Set<Id>();
            String currObjectName = recordId.getSObjectType().getDescribe().getName();
            String currRecordQuery = 'select id, Owner.Id from '+currObjectName + ' where id = \''+String.escapeSingleQuotes(recordId)+'\'';
            
            SObject currentRecord = Database.query(currRecordQuery);
            Id ownerId = (Id) currentRecord.getSobject('Owner').get('Id');
            
            Id currentUserId = System.UserInfo.getUserId();
            if(currentUserId == ownerId){
                return true;
            }
            roleIds.add(ownerId);
            
            if(roleIds.size() > 0){
            	return checkInParentHierarchy(roleIds, currentUserId);
                     
            }
    
        }
        catch(Exception e){
            system.debug('error: '+e.getStackTraceString() + ' '+ e.getMessage());
        }
        return false;
    }

    public static Boolean checkInParentHierarchy(Set<Id> managerIds, Id currentUserId){
        Set<Id> parentlevelRoleList = getAllSubordinates(managerIds);
        
        return parentlevelRoleList.contains(currentUserId);
        
    }
    
    
    /**************************************************************************************************
    * @description: Method to fetch all subordinates of the passed manager ids
    * @param:  Set<Id> managerIds
    * @return: set of all user ids 
    **************************************************************************************************/
    public static Set<Id> getAllSubordinates(Set<Id> managerIds){
        Set<ID> currentLevelUserIds = new Set<ID>();
        Set<Id> tempManagerIds = new Set<Id>();
        // fetch all the users below in hierarchy using the passed user Id
        List<User> tempUsers = new List<User>();
        if(User.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.User.fields.Id.isAccessible() && Schema.SObjectType.User.fields.ManagerId.isAccessible()){
            tempUsers = [select Id, ManagerId, Manager.ManagerId, Manager.Manager.ManagerId, Manager.manager.manager.managerId from User where ManagerId IN :managerIds
                         or Manager.ManagerId in :managerIds or Manager.Manager.ManagerId in :managerIds or Manager.manager.manager.managerId in :managerIds ];
        }
        for(User urs : tempUsers){
            currentLevelUserIds.add(urs.Id);
            if(urs.ManagerId != null && urs.Manager.ManagerId != null && urs.Manager.Manager.ManagerId != null && urs.Manager.manager.manager.managerId != null && managerIds.contains(urs.Manager.Manager.Manager.ManagerId)){
                tempManagerIds.add(urs.Id);
                
            }
        }
        if(tempManagerIds.size() > 0){
            currentLevelUserIds.addAll(getAllSubordinates(tempManagerIds));
        }
        return currentLevelUserIds;
    }

}