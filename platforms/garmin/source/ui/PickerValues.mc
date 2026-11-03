import Toybox.Lang;

module PickerValues {
    function singleNumber(values as Array) as Number {
        if (values.size() != 1) {
            throw new Lang.InvalidValueException("Expected one selection");
        }
        var value = values[0];
        if (!(value instanceof Number)) {
            throw new Lang.InvalidValueException("Selection must be a number");
        }
        return value;
    }
}
