public with sharing class constants {
    public static FINAL String NAMESPACE = String.valueOf(constants.class).split('[.]').size() > 1 ? String.valueOf(constants.class).split('[.]')[0] : 'c';
    public static FINAL String NAMESPACE_API = NAMESPACE == 'c' ? '' : NAMESPACE + '__';
}
