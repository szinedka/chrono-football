import Toybox.Lang;

class Chronometer {
    private var _clock as MillisecondClock;
    private var _startedAt as Number?;
    private var _accumulated as Long;
    private var _nextActionId as Long;
    private var _stopListener as ChronometerStopListener?;
    private var _notifying as Boolean;

    function initialize(clock as MillisecondClock) {
        _clock = clock;
        _startedAt = null;
        _accumulated = 0l;
        _nextActionId = 1l;
        _stopListener = null;
        _notifying = false;
    }

    function setStopListener(listener as ChronometerStopListener?) as Void {
        _stopListener = listener;
    }

    function isRunning() as Boolean {
        return _startedAt != null;
    }

    function completedMilliseconds() as Long {
        return _accumulated;
    }

    function start() as Void {
        if (_notifying) {
            throw new Lang.OperationNotAllowedException("Cannot start during stop notification");
        }
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

        return elapsedSince(startedAt, _clock.nowMilliseconds());
    }

    function stop() as Long {
        if (_notifying) {
            throw new Lang.OperationNotAllowedException("Cannot stop during stop notification");
        }
        var startedAt = _startedAt;
        if (startedAt == null) {
            throw new Lang.OperationNotAllowedException("Chronometer is not running");
        }
        var elapsed = elapsedSince(startedAt, _clock.nowMilliseconds());
        _accumulated = elapsed;
        _startedAt = null;
        var actionId = _nextActionId;
        _nextActionId += 1l;
        var listener = _stopListener;
        if (listener != null) {
            _notifying = true;
            try {
                notifyStopped(listener, new ChronometerStoppedEvent(actionId, elapsed));
            } finally {
                _notifying = false;
            }
        }
        return elapsed;
    }

    function cancel() as Void {
        if (_notifying || !isRunning()) {
            throw new Lang.OperationNotAllowedException("Chronometer cannot be cancelled");
        }
        _accumulated = elapsedMilliseconds();
        _startedAt = null;
    }

    private function elapsedSince(startedAt as Number, reading as Number) as Long {
        var elapsed = reading.toLong() - startedAt.toLong();
        if (elapsed < 0l) {
            // Correct for the 32-bit counter crossing its signed boundary.
            elapsed += 4294967296l;
        }
        return _accumulated + elapsed;
    }

    private function notifyStopped(listener as ChronometerStopListener, event as ChronometerStoppedEvent) as Void {
        listener.invoke(event);
    }
}
