import Toybox.Lang;
import Toybox.Test;

(:test)
function chronometerFormatShowsHundredths(logger as Test.Logger) as Boolean {
    return ChronometerFormat.format(0l).equals("00:00:00") &&
        ChronometerFormat.format(9l).equals("00:00:00") &&
        ChronometerFormat.format(10l).equals("00:00:01") &&
        ChronometerFormat.format(100l).equals("00:00:10") &&
        ChronometerFormat.format(999l).equals("00:00:99") &&
        ChronometerFormat.format(1000l).equals("00:01:00");
}

(:test)
function chronometerFormatShowsMinutesAndSeconds(logger as Test.Logger) as Boolean {
    return ChronometerFormat.format(59999l).equals("00:59:99") &&
        ChronometerFormat.format(60000l).equals("01:00:00") &&
        ChronometerFormat.format(3599999l).equals("59:59:99") &&
        ChronometerFormat.format(3600000l).equals("60:00:00") &&
        ChronometerFormat.format(6000000l).equals("100:00:00");
}

(:test)
function chronometerFormatRejectsNegativeTime(logger as Test.Logger) as Boolean {
    try {
        ChronometerFormat.format(-1l);
        return false;
    } catch (error instanceof Lang.InvalidValueException) {
        return true;
    }
}
