class AvgFilter {
	/* Recursive moving average filter.
	*/
	hidden var _N;
	hidden var _fifo;
	hidden var _gain;
	hidden var _y;
	function initialize(len, val, gain) {
		_N = len;
		_fifo = new [_N];
		_gain = gain;
		reset(val);
	}

	function reset(val) {
		for(var i = 0; i < _N; i++) {
		  _fifo[i] = val;
  		}
  		// initialize the accumulator
  		_y = _N * val;
	}

	function push_back(x) {
    	_y += x - _fifo[0];
	   for (var i = 0; i < _N - 1; i++) {
    	_fifo[i] = _fifo[i+1];
    	}
    	_fifo[_N - 1] = x;
    	return _y * _gain;
	}

}