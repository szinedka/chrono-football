import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class MatchModeFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }

    function getSize() as Number {
        return 2;
    }

    function getValue(index as Number) as Object? {
        if (index < 0 || index >= getSize()) {
            throw new Lang.InvalidValueException("Invalid match mode index");
        }
        return index;
    }

    function getDrawable(index as Number, selected as Boolean) as WatchUi.Drawable? {
        var label = "";
        if (index == 0) {
            label = "GOALS";
        } else if (index == 1) {
            label = "TIMED";
        } else {
            throw new Lang.InvalidValueException("Invalid match mode index");
        }
        return new WatchUi.Text({
            :text => label,
            :font => Graphics.FONT_TINY,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
}

class MatchModePicker extends WatchUi.Picker {
    function initialize() {
        var title = new WatchUi.Text({
            :text => "MATCH MODE",
            :font => Graphics.FONT_TINY,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        Picker.initialize({
            :title => title,
            :pattern => [new MatchModeFactory()],
            :defaults => [0]
        });
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class MatchModePickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }

    function onAccept(values as Array) as Boolean {
        var selected = PickerValues.singleNumber(values);
        if (selected == 0) {
            WatchUi.switchToView(new GoalTargetPicker(), new GoalTargetPickerDelegate(),
                WatchUi.SLIDE_IMMEDIATE);
        } else if (selected == 1) {
            WatchUi.switchToView(new TimedDurationPicker(), new TimedDurationPickerDelegate(),
                WatchUi.SLIDE_IMMEDIATE);
        } else {
            throw new Lang.InvalidValueException("Invalid match mode selection");
        }
        return true;
    }

    function onCancel() as Boolean {
        return true;
    }
}
