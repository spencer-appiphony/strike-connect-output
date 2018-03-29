public with sharing class utilities {
    public static sObject getSobjectByMap(Map<String, Object> sourceMap, String sObjectName) {
        return getSobjectByMap(sourceMap, sObjectName, constants.NAMESPACE_API);
    }

    public static sObject getSobjectByMap(Map<String, Object> sourceMap, String sObjectName, String namespace) {
        if (!Schema.getGlobalDescribe().containsKey(sObjectName)) {
            if (Schema.getGlobalDescribe().containsKey(namespace + sObjectName)) {
                sObjectName = namespace + sObjectName;
            } else {
                return null;
            }
        }

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        Map<String, Object> objMap = new Map<String, Object>();

        for (String field : sourceMap.keySet()) {
            String value = String.valueOf(sourceMap.get(field));

            if (!fieldMap.containsKey(field)) {
                if (fieldMap.containsKey(namespace + field)) {
                    field = namespace + field;
                } else {
                    continue;
                }
            }

            objMap.put(field, String.isEmpty(value) ? null : value);
        }

        if (objMap.size() > 0) {
            return (sObject)JSON.deserialize(JSON.serialize(objMap), Type.forName(sObjectName));
        } else {
            return null;
        }
    }

    public static Boolean run = true;

    public static Boolean runOnce() {
        if (true == run) {
            run = false;

            return true;
        } else {
            return false;
        }
    }
}
