using Toybox.Application;

class garmin_data_field_gradeApp extends Application.AppBase {

	var _field;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	_field = new garmin_data_field_gradeView();
        return [ _field ];
    }

    function onSettingsChanged() {
    	_field.dataInit();
    }

}