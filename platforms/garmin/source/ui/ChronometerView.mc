import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

class ChronometerView extends WatchUi.View {
    private var _controller as ChronometerController;
    private var _session as PossessionSession;
    private var _refreshTimer as Timer.Timer;
    private var _visible as Boolean;

    function initialize(controller as ChronometerController, session as PossessionSession) {
        View.initialize();
        _controller = controller;
        _session = session;
        _refreshTimer = new Timer.Timer();
        _visible = false;
    }

    function onShow() as Void {
        _visible = true;
        _controller.refresh();
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
        _controller.refresh();
        if (_session.isFinished()) {
            _refreshTimer.stop();
        }
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        _controller.refresh();
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var running = _controller.isRunning();
        var phase = _session.phase();
        var turn = "";
        var winner = _session.winner();
        if (_session.isFinished()) {
            turn = winner == null ? "DRAW" : SessionLabels.player(winner) + " WINS";
        } else {
            turn = SessionLabels.turn(_session.actingPlayer(), phase);
        }
        var status = "READY";
        if (_session.timedOut()) {
            status = "TIME UP";
        } else if (running) {
            status = "RUNNING";
        } else if (_controller.hasResult()) {
            var moment = _session.lastMoment();
            status = moment == null ? "STOPPED" : SessionLabels.moment(moment);
        }
        var stopwatch = "--:--:--";
        if (!running || phase != SessionPhase.GOALKEEPER) {
            stopwatch = ChronometerFormat.format(_controller.displayMilliseconds());
        }
        var score = "P1 " + _session.p1Score().toString() + " : " +
            _session.p2Score().toString() + " P2";
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(centerX, centerY - 100, Graphics.FONT_SMALL,
            turn, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY - 45, Graphics.FONT_MEDIUM,
            stopwatch, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 15, Graphics.FONT_SMALL,
            status, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 60, Graphics.FONT_SMALL,
            score, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 100, Graphics.FONT_SMALL,
            _session.isFinished() ? "MATCH OVER" : "TAP OR PRESS",
            Graphics.TEXT_JUSTIFY_CENTER);
    }
}
