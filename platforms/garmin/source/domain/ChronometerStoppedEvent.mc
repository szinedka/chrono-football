import Toybox.Lang;

class ChronometerStoppedEvent {
    private var _actionId as Long;
    private var _elapsedMilliseconds as Long;

    function initialize(actionId as Long, elapsedMilliseconds as Long) {
        _actionId = actionId;
        _elapsedMilliseconds = elapsedMilliseconds;
    }

    function getActionId() as Long {
        return _actionId;
    }

    function getElapsedMilliseconds() as Long {
        return _elapsedMilliseconds;
    }
}
