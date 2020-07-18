using Toybox.WatchUi;
using DataFieldUtils.Base;

class garmin_data_field_gradeView extends Base.StandardDataField {
	var _filter;
	var _filterlen;
	var _h0 = 0.0;
	var _h1 = 0.0;
	var _init = true;
	var _div_i = 0;
	const _div = 3;
	var _way = 0;
	var _vpostfix = "%";


	function getFilterLen() {
		var l = Application.Properties.getValue("filterlen");
		System.println("filterlen " + l);
		return l.toNumber();
	}

	// Set the label of the data field here.
    function initialize() {
        StandardDataField.initialize();
        _ref_value = "+00.0" + _vpostfix;
        label = "Grade";
        value = "_._"  + _vpostfix;

		dataInit();
	}

	function dataInit() {
		_filterlen = getFilterLen();
        _filter = new DataFieldUtils.AvgFilter(_filterlen, 0, 100.0 / _filterlen);
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
		if (v == null) {
			v = 0;
			_init = true;
		}
  		_div_i++;
  		var way;
  		if (_div_i == _div) {
	    	_div_i = 0;
	    	way = _way;
	    	_way = v;
	    } else {
	    	_way += v;
	    	return value;
	    }

		if (way < 3 || v < 1) {		// when almost stopped. React fast on v.
			_init = true;
			value = "_._" + _vpostfix;
			return value;
		}
		if (_init) {
			System.println("init");
			_filter.reset(0.0);
	  		_init = false;
			_h0 = info.altitude;
	  	}
		_h1 = _h0;
		_h0 = info.altitude;
		var g = ((_h0 - _h1) / way);
        var gf = _filter.push_back(g);

		if (gf.abs() < 0.11) {
			value = "0.0"  + _vpostfix;
		} else {
			value = gf.format("%+.1f")  + _vpostfix;
		}

        return value;
    }
}