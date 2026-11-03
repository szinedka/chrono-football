import Toybox.Lang;

class ChronometerController {
    private var _chronometer as Chronometer;
    private var _session as PossessionSession;
    private var _lastElapsed as Long?;

    function initialize(chronometer as Chronometer, session as PossessionSession) {
        _chronometer = chronometer;
        _session = session;
        _lastElapsed = null;
    }

    function toggle() as Void {
        refresh();
        if (_session.isFinished()) {
            return;
        }
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

    function refresh() as Void {
        if (_session.isTimed() && !_session.isFinished()) {
            var elapsed = _chronometer.isRunning() ?
                _chronometer.elapsedMilliseconds() : _chronometer.completedMilliseconds();
            _session.updateElapsed(elapsed);
        }
        if (_session.isFinished() && _chronometer.isRunning()) {
            _chronometer.cancel();
        }
    }

    function isRunning() as Boolean {
        return _chronometer.isRunning();
    }

    function displayMilliseconds() as Long {
        if (_session.timedOut()) {
            return _session.timeLimitMilliseconds();
        }
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
