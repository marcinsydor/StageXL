part of stagexl;

class SoundMixer {
  
  static SoundTransform _soundTransform;
  static SoundTransform get soundTransform => _soundTransform;

  static set soundTransform(SoundTransform value) {
    // ToDo
  }

  //-------------------------------------------------------------------------------------------------
  
  static String engine = _getEngine();
  
  static AudioContext _audioContext = _getAudioContext(); 
  static List<String> _supportedTypes = _getSupportedTypes();
  
  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------
  
  static String _getEngine() {    
      
    var engine = (_audioContext != null) ? "WebAudioApi" : "AudioElement";

    var ua = html.window.navigator.userAgent;

    if (ua.contains("IEMobile"))
      if (ua.contains("9.0") || ua.contains("10.0"))
        engine = "Mock";

    if (ua.contains("iPhone") || ua.contains("iPad") || ua.contains("iPod"))
      if (ua.contains("OS 3") || ua.contains("OS 4") || ua.contains("OS 5"))
        engine = "Mock";
    
    if (_supportedTypes.length == 0)
      engine = "Mock";

    print("StageXL: supported audio engine is: $engine");
    
    return engine;
  }

  //-------------------------------------------------------------------------------------------------
  
  static AudioContext _getAudioContext() {
    
    if (AudioContext.supported)
      return new AudioContext();
    
    return null;
  }
  
  //-------------------------------------------------------------------------------------------------

  static List<String> _getSupportedTypes() {
    
    var supportedTypes = new List<String>();
    var audio = new AudioElement();
    var valid = ["maybe", "probably"];

    if (valid.indexOf(audio.canPlayType("audio/mpeg", "")) != -1) supportedTypes.add("mp3");
    if (valid.indexOf(audio.canPlayType("audio/mp4", "")) != -1) supportedTypes.add("mp4");
    if (valid.indexOf(audio.canPlayType("audio/ogg", "")) != -1) supportedTypes.add("ogg");
    if (valid.indexOf(audio.canPlayType("audio/wav", "")) != -1) supportedTypes.add("wav");
    
    print("StageXL: supported audio types are: ${supportedTypes}");
    
    return supportedTypes;
  }
  
  //-------------------------------------------------------------------------------------------------
  
  static List<String> _getOptimalAudioUrls(String originalUrl) {

    var regex = new RegExp(r"(mp3|mp4|ogg|wav)$", multiLine:false, caseSensitive:true);
    var availableTypes = _supportedTypes.toList();    
    var match = regex.firstMatch(originalUrl);
    var urls = new List<String>();

    if (match == null) {
      throw new ArgumentError("Unsupported file extension.");
    }

    if (availableTypes.length == 0) {
      throw new UnsupportedError("This browser supports no known audio codec.");
    }
    
    var fileType = match.group(1);
    
    if (availableTypes.contains(fileType)) {
      urls.add(originalUrl);
      availableTypes.remove(fileType);
    }
    
    for(var availableType in availableTypes) {
      urls.add(originalUrl.replaceAll(regex, availableType));
    }

    return urls;
  }
  
}
