using Toybox.WatchUi;
using Toybox.Math;


class garmin_data_field_gradeView extends StandardDataField {
	const _taps = [0.0134969236341 ,
		0.0784508686231 ,
		0.24086247424 ,
		0.334379467006 ,
		0.24086247424 ,
		0.0784508686231 ,
		0.0134969236341];
	const _m_ft = 0.3048f;
	var _filter;
	var _fifo =  null;
	var _N = null;
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

        var options = {:coefficients => _taps, :gain => 1.0f};
  		_N = _taps.size();
  		_fifo = new [_N];
        _filter = new Math.FirFilter(options);
        _init = true;
		System.println("fifo init" + _N);
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
	  		for(var i = 0; i < _N; i++) {
	  			_fifo[i] = 0.0f;
	  		}
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
        for (var i = 0; i < _N - 1; i++) {
        	_fifo[i] = _fifo[i+1];
    	}
		_h1 = _h0;
		_h0 = info.altitude;
		var g = ((_h0 - _h1)*100.0f / _way);
    	_way = v;
    	_fifo[_N - 1] = g;

		System.println("x " + _fifo);
        var y = _filter.apply(_fifo);
        System.println("y " + y);
        var gf = y[_N - 1];

		if (gf.abs() < 0.11) {
			value = "0.0";
		} else {
			value = gf.format("%+.1f");
		}

        System.println("--");
        return value;
    }
}