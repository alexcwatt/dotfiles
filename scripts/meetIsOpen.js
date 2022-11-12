(function () {
  var chrome = Application("Chrome");
  for (win of chrome.windows()) {
    var tabIndex = win
      .tabs()
      .findIndex((tab) => tab.url().match(/meet.google.com/));
    if (tabIndex != -1) {
      return true;
    }
  }

  return false;
})();
