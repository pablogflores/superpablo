@isTest
public with sharing class WarehouseSyncScheduleTest {
  

    @isTest
    public static void test(){

        String CRON_EXP  = '00 00 00 * * ? *';
        
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('WarehouseSyncScheduleTest', CRON_EXP, new WarehouseSyncSchedule());
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM CronTrigger WHERE CronJobDetail.Name = 'WarehouseSyncScheduleTest']);
      

    }
}