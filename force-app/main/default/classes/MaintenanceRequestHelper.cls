public with sharing class MaintenanceRequestHelper {
 
        public static void updateWorkOrders(List<Case> caseList){
            List<Case> newMaintenanceRequests = new List<Case>();
          
            for(Case c : [
                SELECT 
                    Id,
                    AccountId,
                    ContactId,
                    Status, 
                    Type, 
                    Origin, 
                    Vehicle__c,
                    Equipment__c, 
                    Subject, 
                    Date_Reported__c, 
                    Date_Due__c,
                    (SELECT 
                        Equipment__r.Maintenance_Cycle__c
                        
                    FROM Equipment_Maintenance_Items__r )
                   
                FROM Case
                WHERE Id IN : caseList]) {
    
                if(c.Status == 'Closed' && (c.Type == 'Routine Maintenance' || c.Type == 'Repair')) {
                    Case newCase = new Case(
                        Status = 'New',
                        Origin = c.Origin,
                        Type = 'Routine Maintenance',
                        AccountId = c.AccountId,
                        ContactId = c.ContactId,
                        Vehicle__c = c.Vehicle__c,
                        Equipment__c = c.Equipment__c,
                        Subject = 'Nueva rutina de mantenimiento de  ' + String.valueOf(c.Vehicle__c),
                        Date_Reported__c = System.today(),
                        ParentId = c.Id,
                        Date_Due__c = (c.Equipment_Maintenance_Items__r.size() > 0 ? System.today().addDays(Integer.valueOf(c.Equipment_Maintenance_Items__r[0].Equipment__r.Maintenance_Cycle__c)) : System.today())
                    );
                    
                    newMaintenanceRequests.add(newCase);
                }
            }
            
            if(!newMaintenanceRequests.isEmpty()) {
                insert newMaintenanceRequests;
            }
        }        
    }
