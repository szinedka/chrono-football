import Toybox.Lang;

class Chronometer {
    private var _clock as MillisecondClock;
    private var _startedAt as Number?;
    private var _accumulated as Long;

    function initialize(clock as MillisecondClock) {
        _clock = clock;
        _startedAt = null;
        _accumulated = 0l;
    }

    function isRunning() as Boolean {
        return _startedAt != null;
    }

    function start() as Void {
        if (isRunning()) {
            throw new Lang.OperationNotAllowedException("Chronometer is already running");
        }
        _startedAt = _clock.nowMilliseconds();
    }

    function elapsedMilliseconds() as Long {
        var startedAt = _startedAt;
        if (startedAt == null) {
            throw new Lang.OperationNotAllowedException("Chronometer is not running");
        }

        var elapsed = _clock.nowMilliseconds().toLong() - startedAt.toLong();
        if (elapsed < 0l) {
            // Correct for the 32-bit counter crossing its signed boundary.
            elapsed += 4294967296l;
        }
        return _accumulated + elapsed;
    }

    function stop() as Long {
        var elapsed = elapsedMilliseconds();
        _accumulated = elapsed;
        _startedAt = null;
        return elapsed;
    }
}
