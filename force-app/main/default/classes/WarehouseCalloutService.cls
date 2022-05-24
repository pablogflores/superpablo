public class WarehouseCalloutService implements Queueable {
    //LLamar a la api 
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    @Future(callout=true)
    public static void runWarehouseEquipmentSync(){
    
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(WAREHOUSE_URL);
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    List<Product2> listproducto = new List<Product2>();
    System.debug(response.getStatusCode());
    if (response.getStatusCode() == 200){
        String respuesta = response.getBody();
        respuesta = respuesta.replaceAll('_id', 'x_id');

       
        List<equipmentjson> results = (List<equipmentjson>) JSON.deserialize(respuesta, List<equipmentjson>.class);
        System.debug(response.getBody());
   
      for (equipmentjson inst : results) {
        Product2 product2 = new Product2();
        product2.Replacement_Part__c = inst.replacement;
        product2.Cost__c = inst.cost;
        product2.Current_Inventory__c = inst.quantity;
        product2.Lifespan_Months__c = inst.lifespan;
        product2.Maintenance_Cycle__c = inst.maintenanceperiod;
        product2.Warehouse_SKU__c = inst.sku;
        product2.Name = inst.name;
        product2.ProductCode = inst.x_id;
        listproducto.add(product2);
          
      }

    }
    if(!listproducto.isEmpty()){
        UPSERT listproducto Warehouse_SKU__c;
    }
    

    }
    public static void execute (QueueableContext context){
        System.debug('start runWarehouseEquipmentSync');
        runWarehouseEquipmentSync();
        System.debug('end runWarehouseEquipmentSync');
    }

    public class equipmentjson{
        public Integer maintenanceperiod{get;set;}
        public String name{get;set;}
        public Integer lifespan{get;set;}
        public Integer quantity{get;set;}
        public Integer cost{get;set;}
        public Boolean replacement{get;set;}
        public String sku{get;set;}
        public String x_id{get;set;}
    }

    
    
}