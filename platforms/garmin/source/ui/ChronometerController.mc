import Toybox.Lang;

class ChronometerController {
    private var _chronometer as Chronometer;
    private var _lastElapsed as Long?;

    function initialize(chronometer as Chronometer) {
        _chronometer = chronometer;
        _lastElapsed = null;
    }

    function toggle() as Void {
        if (_chronometer.isRunning()) {
            try {
                _lastElapsed = _chronometer.stop();
            } finally {
                if (!_chronometer.isRunning()) {
                    _lastElapsed = _chronometer.completedMilliseconds();
                }
            }
        } else {
            _chronometer.start();
            _lastElapsed = null;
        }
    }

    function isRunning() as Boolean {
        return _chronometer.isRunning();
    }

    function displayMilliseconds() as Long {
        if (_chronometer.isRunning()) {
            return _chronometer.elapsedMilliseconds();
        }
        var lastElapsed = _lastElapsed;
        return lastElapsed == null ? 0l : lastElapsed;
    }

    function hasResult() as Boolean {
        return _lastElapsed != null;
    }
}
