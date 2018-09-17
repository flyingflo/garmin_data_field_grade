using Toybox.WatchUi;
using Toybox.Math;


class garmin_data_field_gradeView extends StandardDataField {
	var _filter;
	const _filterlen = 5;
	var _h0 = 0.0;
	var _h1 = 0.0;
	var _init = true;
	var _div_i = 0;
	const _div = 3;
	var _way = 0;

    // Set the label of the data field here.
    function initialize() {
        StandardDataField.initialize();
        label = "Grade %";

        _filter = new AvgFilter(_filterlen, 0, 100 / _filterlen);
        _init = true;
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.
		//info.altitude
		if (info.altitude == null) {
			System.println("info incomplete");
			value = "??";
			return value;
		}
		var v = info.currentSpeed;
		if (!(v != null && v > 1.0f)) {
			_init = true;
			value =  "__";
			return value;
		}
		if (_init) {
			System.println("init");
			_filter.reset(0);
	  		_init = false;
			_h0 = info.altitude;
			_h1 = _h0;
	  		value = "__";
	  		return value;
	  	}

  		_div_i++;
  		if (_div_i == _div) {
	    	_div_i = 0;
	    } else {
	    	_way += v;
	    	return value;
	    }
		_h1 = _h0;
		_h0 = info.altitude;
		var g = ((_h0 - _h1) / _way) *100;
    	_way = v;

        var gi = _filter.push_back(g.toNumber());
        var gf = gi.toFloat() / 100.0;

		if (gf.abs() < 0.11) {
			value = "0.0";
		} else {
			value = gf.format("%+.1f");
		}

        return value;
    }
}