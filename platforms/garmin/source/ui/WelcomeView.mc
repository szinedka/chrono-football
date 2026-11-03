import Toybox.Graphics;
import Toybox.WatchUi;

class WelcomeView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(centerX, centerY - 38, Graphics.FONT_MEDIUM,
            "CHRONO", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY, Graphics.FONT_MEDIUM,
            "FOOTBALL", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 45, Graphics.FONT_SMALL,
            "Ready", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
