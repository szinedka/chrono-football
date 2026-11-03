import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class NumericOptionsFactory extends WatchUi.PickerFactory {
    private var _values as Array<Number>;

    function initialize(values as Array<Number>) {
        PickerFactory.initialize();
        if (values.size() == 0) {
            throw new Lang.InvalidValueException("Picker requires at least one value");
        }
        _values = values;
    }

    function getSize() as Number {
        return _values.size();
    }

    private function valueForIndex(index as Number) as Number {
        if (index < 0 || index >= getSize()) {
            throw new Lang.InvalidValueException("Invalid picker index");
        }
        return _values[index];
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
