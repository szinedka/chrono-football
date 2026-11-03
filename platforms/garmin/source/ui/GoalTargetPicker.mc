import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class GoalTargetPicker extends WatchUi.Picker {
    function initialize() {
        var values = new Array<Number>[GoalTarget.MAX - GoalTarget.MIN + 1];
        for (var index = 0; index < values.size(); index += 1) {
            values[index] = GoalTarget.MIN + index;
        }
        var title = new WatchUi.Text({
            :text => "GOALS TO WIN",
            :font => Graphics.FONT_TINY,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        Picker.initialize({
            :title => title,
            :pattern => [new NumericOptionsFactory(values)],
            :defaults => [GoalTarget.DEFAULT - GoalTarget.MIN]
        });
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}
