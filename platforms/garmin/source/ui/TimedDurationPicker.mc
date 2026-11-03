import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class TimedDurationPicker extends WatchUi.Picker {
    function initialize() {
        var durations = TimedMatchDuration.options();
        var title = new WatchUi.Text({
            :text => "MINUTES",
            :font => Graphics.FONT_TINY,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        Picker.initialize({
            :title => title,
            :pattern => [new NumericOptionsFactory(durations)],
            :defaults => [durations.indexOf(TimedMatchDuration.DEFAULT_MINUTES)]
        });
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class TimedDurationPickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }

    function onAccept(values as Array) as Boolean {
        MatchLauncher.open(new MatchSettings(MatchMode.TIMED,
            PickerValues.singleNumber(values)));
        return true;
    }

    function onCancel() as Boolean {
        return true;
    }
}
