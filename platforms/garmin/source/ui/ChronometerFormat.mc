import Toybox.Lang;

module ChronometerFormat {
    function format(milliseconds as Long) as String {
        var hundredths = StopwatchValue.hundredths(milliseconds);
        var minutes = milliseconds / 60000l;
        var seconds = (milliseconds / 1000l) % 60l;
        return minutes.format("%02d") + ":" + seconds.format("%02d") + ":" +
            hundredths.format("%02d");
    }
}
