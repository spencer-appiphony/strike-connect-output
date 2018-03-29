public with sharing class donationStep {
    @AuraEnabled
    public static String getStageNames() {
        responseData response = new responseData();

        try {
            List<Map<String, Object>> stageNames = new List<Map<String, Object>>();

            Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();

            for (Schema.PicklistEntry ple : fieldResult.getPicklistValues()) {
                stageNames.add(new Map<String, Object> {
                    'label' => ple.getLabel(),
                    'value' => ple.getValue(),
                    'disabled' => !ple.isActive()
                });
            }

            response.put('stageNames', stageNames);
        } catch (Exception e) {
            response.addError(e.getMessage());
        }

        return response.getJsonString();
    }
}
