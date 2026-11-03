import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

class ChronometerView extends WatchUi.View {
    private var _controller as ChronometerController;
    private var _preview as PossessionMatrixListener;
    private var _refreshTimer as Timer.Timer;
    private var _visible as Boolean;

    function initialize(controller as ChronometerController, preview as PossessionMatrixListener) {
        View.initialize();
        _controller = controller;
        _preview = preview;
        _refreshTimer = new Timer.Timer();
        _visible = false;
    }

    function onShow() as Void {
        _visible = true;
        updateRefreshTimer();
    }

    function onHide() as Void {
        _visible = false;
        _refreshTimer.stop();
    }

    function updateRefreshTimer() as Void {
        _refreshTimer.stop();
        if (_visible && _controller.isRunning()) {
            _refreshTimer.start(method(:requestRefresh), 50, true);
        }
    }

    function requestRefresh() as Void {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var status = "READY";
        if (_controller.isRunning()) {
            status = "RUNNING";
        } else if (_controller.hasResult()) {
            var outcome = _preview.lastOutcome();
            status = outcome == null ? "STOPPED" : PossessionOutcomeLabel.text(outcome);
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(centerX, centerY - 95, Graphics.FONT_SMALL,
            "MATRIX PREVIEW", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY - 40, Graphics.FONT_MEDIUM,
            ChronometerFormat.format(_controller.displayMilliseconds()),
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 25, Graphics.FONT_SMALL,
            status, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 70, Graphics.FONT_SMALL,
            "TAP OR PRESS", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
