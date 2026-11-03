import Toybox.Lang;

class PossessionMatrixListener {
    private var _lastOutcome as PossessionMatrix.Outcome?;

    function initialize() {
        _lastOutcome = null;
    }

    function onChronometerStopped(event as ChronometerStoppedEvent) as Void {
        _lastOutcome = null;
        var hundredths = StopwatchValue.hundredths(event.getElapsedMilliseconds());
        _lastOutcome = PossessionMatrix.resolve(hundredths);
    }

    function lastOutcome() as PossessionMatrix.Outcome? {
        return _lastOutcome;
    }
}
