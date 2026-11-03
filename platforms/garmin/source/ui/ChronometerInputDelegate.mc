import Toybox.Lang;
import Toybox.WatchUi;

class ChronometerInputDelegate extends WatchUi.BehaviorDelegate {
    private var _controller as ChronometerController;
    private var _view as ChronometerView;

    function initialize(controller as ChronometerController, view as ChronometerView) {
        BehaviorDelegate.initialize();
        _controller = controller;
        _view = view;
    }

    function onSelect() as Boolean {
        try {
            _controller.toggle();
        } finally {
            _view.updateRefreshTimer();
            WatchUi.requestUpdate();
        }
        return true;
    }
}
