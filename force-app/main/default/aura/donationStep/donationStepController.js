({
    init: function(component, event, helper) {
        var action = component.get('c.getStageNames');

        action.setCallback(this, function(res) {
            if ('SUCCESS' == res.getState()) {
                var parsedRes = JSON.parse(res.getReturnValue());

                if (parsedRes.isSuccess) {
                    component.set('v.stageNames', parsedRes.results.stageNames);
                } else {
                    // handle error
                    // parsedRes.error
                }
            } else {
                // handle error
                // res.getError()[0].message);
            }
        });

        $A.enqueueAction(action);
    }
})
