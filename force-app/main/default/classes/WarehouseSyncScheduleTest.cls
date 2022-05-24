@isTest
public with sharing class WarehouseSyncScheduleTest {
  

    @isTest
    public static void test(){

        String scheduleTime = '00 00 00 * * ? *';
        
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobId = System.schedule('Warehouse Time to Schedule to test', scheduleTime, new WarehouseSyncSchedule());
        CronTrigger c = [SELECT State FROM CronTrigger WHERE Id =: jobId];
        System.assertEquals('WAITING', String.valueOf(c.State), 'JobId does not match');

    }
}