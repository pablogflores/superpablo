public class DataFactory {
    public static Vehicle__c buildVehicle(Integer i) {
        Vehicle__c vehicle = new Vehicle__c(
            Name = 'TEST ' + i
        );
        return vehicle;
    }
    
    public static Case buildCase(Id vehicleId) {
        Case maintenanceRequest = new Case(
            Status = 'New',
            Origin = 'Web',
            Type = 'Routine Maintenance',
            Vehicle__c = vehicleId
        );
        return maintenanceRequest;
    }
}