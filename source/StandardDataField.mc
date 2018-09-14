using Toybox.WatchUi;


class StandardDataField extends WatchUi.DataField {
	var value = "";
	var label = "";

	var _value_font = Graphics.FONT_SYSTEM_NUMBER_MILD;
	var _label_font = Graphics.FONT_SYSTEM_TINY;
	var _value_x;
	var _value_y;
	var _label_x;
	var _label_y;
	const PAD = 3;

	function initialize() {
		DataField.initialize();
	}

	function onLayout(dc) {
		DataField.onLayout(dc);
		_value_x = dc.getWidth() / 2;
		_label_x = _value_x;
		_value_y = dc.getHeight() - Graphics.getFontAscent(_value_font) - PAD ;
		_label_y = Graphics.getFontDescent(_label_font);
		System.println("onLayout");
		return true;
	}

	function onUpdate(dc) {
		var bgc = getBackgroundColor();
		var fgc = Graphics.COLOR_BLACK;
		if (bgc == Graphics.COLOR_BLACK) {
			fgc = Graphics.COLOR_WHITE;
		}
		dc.setColor(fgc, bgc);

		dc.clear();
		dc.drawText(_value_x, _value_y, _value_font, value, Graphics.TEXT_JUSTIFY_CENTER);
		dc.drawText(_label_x, _label_y, _label_font, label, Graphics.TEXT_JUSTIFY_CENTER);
		return true;
	}

}