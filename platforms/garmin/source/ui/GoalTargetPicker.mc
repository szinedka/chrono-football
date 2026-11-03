import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class GoalTargetFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }

    function getSize() as Number {
        return GoalTarget.MAX - GoalTarget.MIN + 1;
    }

    private function valueForIndex(index as Number) as Number {
        if (index < 0 || index >= getSize()) {
            throw new Lang.InvalidValueException("Invalid goal target index");
        }
        return GoalTarget.MIN + index;
    }

    function getValue(index as Number) as Object? {
        return valueForIndex(index);
    }

    function getDrawable(index as Number, selected as Boolean) as WatchUi.Drawable? {
        return new WatchUi.Text({
            :text => valueForIndex(index).toString(),
            :font => Graphics.FONT_NUMBER_MILD,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
}

class GoalTargetPicker extends WatchUi.Picker {
    function initialize() {
        var title = new WatchUi.Text({
            :text => "GOALS TO WIN",
            :font => Graphics.FONT_TINY,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        Picker.initialize({
            :title => title,
            :pattern => [new GoalTargetFactory()],
            :defaults => [GoalTarget.DEFAULT - GoalTarget.MIN]
        });
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}
