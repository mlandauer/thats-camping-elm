var _user$project$Native_Standalone = function()
{

var standalone = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)	{
	callback(_elm_lang$core$Native_Scheduler.succeed(("standalone" in window.navigator) &&
    !window.navigator.standalone));
});

return {
	standalone: standalone
};

}();
