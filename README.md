This datafield shows useful live road gradient. 
It does this much better than the stock gradient data field,
which seems to rely on GPS data, which is the worst sensor for the job.

A vertical speed / VAM field is also available.

Details:

- Uses the best available data: barometric altitude, bike speed sensors, GPS as a fallback.
- Adjustable smoothing: fast response vs. smooth values.
- 3s altitude sampling interval to accumulate significant altitude delta.
- FIR filter smoothing. 
- Almost native look: uses system fonts. Todo: adapt font to field height.
