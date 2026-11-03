import Toybox.Application;
import Toybox.WatchUi;

class ChronoFootballApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [new GoalTargetPicker(), new GoalTargetPickerDelegate()];
    }
}
