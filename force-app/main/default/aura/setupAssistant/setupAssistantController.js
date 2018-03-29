({
    init: function(component, event, helper) {
        var action = component.get('c.getData');

        action.setCallback(this, function(res) {
            if ('SUCCESS' == res.getState()) {
                var parsedRes = JSON.parse(res.getReturnValue());

                if (parsedRes.isSuccess) {
                    component.set('v._data', parsedRes.results.data);

                    helper.buildSetup(component);
                } else {
                    component.set('v.error', parsedRes.error);
                }
            } else {
                component.set('v.error', res.getError()[0].message);
            }

            component.set('v.loading', false);
        });

        $A.enqueueAction(action);
    },

    clickBack: function(component, event, helper) {
        component.set('v.loading', true);
        component.set('v.error', null);

        var activeStep = component.get('v.activeStep');
        var steps = component.get('v.steps');

        helper.navigateToStep(component, steps[activeStep.stepIndex - 1]);

        component.set('v.loading', false);
    },
    clickCancel: function(component, event, helper) {
        var activeStep = component.get('v.activeStep');

        if (activeStep.isComplete) {
            helper.navigateToLanding(component);
        } else {
            var modal = component.find('modal');
            modal.show();
        }
    },
    clickCancelModal: function(component, event, helper) {
        var modal = component.find('modal');
        modal.hide();
    },
    clickHideError: function(component, event, helper) {
        component.set('v.error', null);
    },
    clickNavigate: function(component, event, helper) {
        component.set('v.loading', true);
        component.set('v.error', null);

        var sectionName = event.getParam('data');

        var settings = component.get('v._data');
        var steps = component.get('v.steps');
        var stepIndex;

        if (null == sectionName) {
            stepIndex = settings.Steps_Completed__c;
        } else {
            component.get('v.sections').forEach(function(section) {
                if (section.name == sectionName) {
                    if ('started' == section.status) {
                        stepIndex = settings.Steps_Completed__c;
                    } else {
                        stepIndex = section.initStepIndex;
                    }
                }
            })
        }

        if (stepIndex >= steps.length) {
            helper.navigateToLanding(component);
        } else {
            helper.navigateToStep(component, steps[stepIndex]);
        }

        component.set('v.loading', false);
    },
    clickNext: function(component, event, helper) {
        component.set('v.loading', true);
        component.set('v.error', null);

        var activeStep = component.get('v.activeStep');

        activeStep.component.validate().then($A.getCallback(function() {
            helper.save(component).then($A.getCallback(function() {
                var activeStep = component.get('v.activeStep');

                if (activeStep.isLastStep) {
                    helper.navigateToComplete(component, activeStep.sectionIndex);
                } else {
                    var steps = component.get('v.steps');

                    helper.navigateToStep(component, steps[activeStep.stepIndex + 1]);
                }

                component.set('v.loading', false);
            }));
        })).catch($A.getCallback(function(error) {
            component.set('v.error', error);
            component.set('v.loading', false);
        }));
    },
    clickOkayModal: function(component, event, helper) {
        var modal = component.find('modal');
        modal.hide();
        helper.navigateToLanding(component);
    }
})
