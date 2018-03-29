public with sharing class setupAssistant {
    @AuraEnabled
    public static String getData() {
        responseData response = new responseData();

        try {
            List<String> fields = new List<String>();

            for (Schema.SObjectField field : Setup_Assistant_Data__c.sObjectType.getDescribe().fields.getMap().values()) {
                fields.add(field.getDescribe().getName());
            }

            List<SObject> data = Database.query('SELECT ' + String.join(fields, ',') + ' FROM ' + constants.NAMESPACE_API + 'Setup_Assistant_Data__c WHERE Name = \'Default\'');
            if (data.isEmpty()) {
                response.put('data', new Setup_Assistant_Data__c(
                    Steps_Completed__c = 0,
                    Donation_Stage_Name__c = 'Closed Won',
                    Refund_Stage_Name__c = 'Closed Lost'
                ));
            } else {
                response.put('data', data[0]);
            }
        } catch (Exception e) {
            response.addError(e.getMessage());
        }

        return response.getJsonString();
    }

    @AuraEnabled
    public static String saveData(String data) {
        responseData response = new responseData();

        try {
            Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(data);

            Setup_Assistant_Data__c dataObj = (Setup_Assistant_Data__c)utilities.getSobjectByMap(dataMap, constants.NAMESPACE_API + 'Setup_Assistant_Data__c');
            dataObj.Name = 'Default';

            upsert dataObj;

            response.put('data', dataObj);
        } catch (Exception e) {
            response.addError(e.getMessage());
        }

        return response.getJsonString();
    }
}
