@IsTest
private class WarehouseCalloutServiceTest {
///
	@isTest
    static void testWarehouseCallout() {
     
        test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        test.startTest();
        WarehouseCalloutService.execute(null);
        test.stopTest();
       
        
        System.assertEquals(3, [select count() from Product2]);
    }
}