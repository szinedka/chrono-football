import Toybox.Lang;

module ChronometerFormat {
    function format(milliseconds as Long) as String {
        if (milliseconds < 0l) {
            throw new Lang.InvalidValueException("Elapsed time cannot be negative");
        }

        var minutes = milliseconds / 60000l;
        var seconds = (milliseconds / 1000l) % 60l;
        var hundredths = (milliseconds / 10l) % 100l;
        return minutes.format("%02d") + ":" + seconds.format("%02d") + ":" +
            hundredths.format("%02d");
    }
}
