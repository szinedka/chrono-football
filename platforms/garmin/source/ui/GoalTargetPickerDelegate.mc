import Toybox.Lang;
import Toybox.WatchUi;

class GoalTargetPickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }

    function onAccept(values as Array) as Boolean {
        MatchLauncher.open(new MatchSettings(MatchMode.GOAL_TARGET,
            PickerValues.singleNumber(values)));
        return true;
    }

    function onCancel() as Boolean {
        return true;
    }
}
