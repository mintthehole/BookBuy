// Load the Google Transliterate API
google.load("elements", "1", {
  packages: "transliteration"
});

var transliterationControl;
function onLoad() {
  var options = {
      sourceLanguage: 'en',
      destinationLanguage: ['kn','hi','ml','ta','te'],
      transliterationEnabled: true,
      shortcutKey: 'ctrl+g'
  };
  // Create an instance on TransliterationControl with the required
  // options.
  transliterationControl =
    new google.elements.transliteration.TransliterationControl(options);

  // Enable transliteration in the textfields with the given ids.
  var ids = [ "noisbntitle_t_title", "noisbntitle_t_author" ];
  transliterationControl.makeTransliteratable(ids);

  // Add the STATE_CHANGED event handler to correcly maintain the state
  // of the checkbox.
  transliterationControl.addEventListener(
      google.elements.transliteration.TransliterationControl.EventType.STATE_CHANGED,
      transliterateStateChangeHandler);

  // Add the SERVER_UNREACHABLE event handler to display an error message
  // if unable to reach the server.
  transliterationControl.addEventListener(
      google.elements.transliteration.TransliterationControl.EventType.SERVER_UNREACHABLE,
      serverUnreachableHandler);

  // Add the SERVER_REACHABLE event handler to remove the error message
  // once the server becomes reachable.
  transliterationControl.addEventListener(
      google.elements.transliteration.TransliterationControl.EventType.SERVER_REACHABLE,
      serverReachableHandler);

  // Populate the language dropdown
  var supportedDestinationLanguages =
    google.elements.transliteration.getDestinationLanguages(
      google.elements.transliteration.LanguageCode.ENGLISH);    
} 


// Handler for dropdown option change event.  Calls setLanguagePair to
// set the new language.

$("#noisbntitle_language").live('click',function() 
  {
    try {
      var selectedLang = $("#noisbntitle_language option:selected").text().split(':')[0];
      transliterationControl.enableTransliteration();
      transliterationControl.setLanguagePair( 
        google.elements.transliteration.LanguageCode.ENGLISH, selectedLang );        
    } catch (e) {
      transliterationControl.disableTransliteration();
    }
  }
);

// SERVER_UNREACHABLE event handler which displays the error message.
function serverUnreachableHandler(e) {
  alert("Transliteration Server unreachable");      
}

// SERVER_UNREACHABLE event handler which clears the error message.
function serverReachableHandler(e) {
  ;
}
google.setOnLoadCallback(onLoad);