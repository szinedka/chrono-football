import Toybox.Lang;
import Toybox.WatchUi;

class ChronometerInputDelegate extends WatchUi.BehaviorDelegate {
    private var _controller as ChronometerController;
    private var _view as ChronometerView;
    private var _session as PossessionSession;

    function initialize(controller as ChronometerController, view as ChronometerView,
                        session as PossessionSession) {
        BehaviorDelegate.initialize();
        _controller = controller;
        _view = view;
        _session = session;
    }

    function onSelect() as Boolean {
        if (_session.isFinished()) {
            return true;
        }
        try {
            _controller.toggle();
        } finally {
            _view.updateRefreshTimer();
            WatchUi.requestUpdate();
        }
        return true;
    }

    function onBack() as Boolean {
        return true;
    }

    function onMenu() as Boolean {
        return true;
    }
}
