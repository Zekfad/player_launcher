class PotPlayerLaunchArguments {
  const PotPlayerLaunchArguments({
    required this.contents,
    this.fileDialog = false,
    this.urlDialog = false,
    this.folderDialog = false,
    this.simpleFileNavigator = false,
    this.screenCapture = false,
    this.camera = false,
    this.analogTv = false,
    this.analogTvChannel,
    this.digitalTv = false,
    this.digitalTvChannel,
    this.digitalTvChannelIndex,
    this.dvd = false,
    this.cd = false,
    this.cdDrive,
    this.add = false,
    this.insert = false,
    this.autoplay = false,
    this.loadAsSingleEntry = false,
    this.sort = false,
    this.randomize = false,
    this.newInstance = false,
    this.currentInstance = false,
    this.clipboard = false,
    this.seek,
    this.subtitle,
    this.userAgent,
    this.referer,
    this.httpHeaders,
    this.title,
    this.config,
  });

  /// You can specify a file, folder or URL as content.
  /// 
  /// - You can specify multiple contents by separating them with a space.
  /// - You can specify titles for URLs by separating them with a backslash (\)
  /// at the end of URLs. ("http://...\title of this url")
  /// - Wildcards (*,?) are allowed.
  /// - The setting "Misc > When Files Opened" affects this when a file is specified.
  final List<String> contents;

  /// Opens the open file dialog box.
  final bool fileDialog;

  /// Opens the open URL dialog box.
  final bool urlDialog;

  /// Opens the open folder dialog box.
  final bool folderDialog;

  /// Opens file navigator.
  final bool simpleFileNavigator;

  /// Runs screen capture.
  final bool screenCapture;

  /// Runs webcam/Other devices.
  final bool camera;

  /// Runs Analog TV device from the specified in [analogTvChannel] channel.
  final bool analogTv;

  /// Selected Analog TV channel.
  final int? analogTvChannel;

  /// Runs Digital TV device from the specified in [digitalTvChannel] channel
  /// and optionally [digitalTvChannelIndex] index.
  final bool digitalTv;

  /// Selected Analog TV channel.
  final int? digitalTvChannel;

  /// Selected Analog TV channel index.
  final int? digitalTvChannelIndex;

  /// Runs DVD device.
  final bool dvd;

  /// Runs the specified in [cdDrive] drive.
  final bool cd;

  /// Selected CD drive.
  final int? cdDrive;

  /// A ppends the specified content(s) into playlist.
  final bool add;

  /// Inserts the specified content(s) just below the item being played
  /// in playlist.(Or adds at the end of playlist if there is nothing playing
  /// at the time)
  final bool insert;

  /// Plays the last played item.
  final bool autoplay;

  /// Loads and plays the specified contents as multiple streams.
  /// - You can independently select loaded video and audio streams under
  /// Video/Audio/Filters context menus.
  final bool loadAsSingleEntry;

  /// Sorts the specified contents by name before adding them into playlist.
  final bool sort;

  /// Sorts the specified contents by randomly before adding them into playlist.
  final bool randomize;

  /// Plays the specified content(s) within a new instance of the program.
  /// - The setting "F5 > General > Multiple instances" does not affect this.
  final bool newInstance;

  /// Plays the specified content(s) within an existing instance of the program.
  /// - The setting "F5 > General > Multiple instances" does not affect this.
  final bool currentInstance;

  /// Appends content(s) from clipboard into playlist and starts playback immediately.
  final bool clipboard;

  /// Starts playback of the specified/last played content from the specified time point.
  /// - time format is: hh:mm:ss.ms (OR specify seconds only e.g.
  /// /seek=1800 to start at 30th min)
  final Duration? seek;

  /// Loads the specified subtitle(s) from the specified paths or URLs.
  final String? subtitle; 

  /// Sets user agent header for HTTP(S) requests.
  final String? userAgent;

  /// Sets referer header for HTTP(S) requests.
  final String? referer;

  /// Appends the specified header(s) to HTTP(S) requests.
  final List<String>? httpHeaders;

  /// Use title
  final String? title;

  /// Activates the specified preset.
  final String? config;

  @override
  String toString() {
    final arguments = <String>[
      for (final content in contents)
        '"$content"',
    ];
    if (fileDialog)
      arguments.add('/filedlg');
    if (urlDialog)
      arguments.add('/urldlg');
    if (folderDialog)
      arguments.add('/folderdlg');
    if (simpleFileNavigator)
      arguments.add('/simple');
    if (screenCapture)
      arguments.add('/cap');
    if (camera)
      arguments.add('/cam');
    if (analogTv)
      arguments.add(
        '/atv${
          analogTvChannel != null
            ? ':$analogTvChannel'
            : ''
        }',
      );
    if (digitalTv)
      arguments.add(
        '/dtv${
          digitalTvChannel != null
            ? ':$digitalTvChannel${
              digitalTvChannelIndex != null
                ? ':$digitalTvChannelIndex'
                : ''
            }'
            : ''
        }',
      );
    if (dvd)
      arguments.add('/dvd');
    if (cd)
      arguments.add(
        '/cd${
          cdDrive != null
            ? ':$cdDrive'
            : ''
        }',
      );
    if (add)
      arguments.add('/add');
    if (insert)
      arguments.add('/insert');
    if (autoplay)
      arguments.add('/autoplay');
    if (loadAsSingleEntry)
      arguments.add('/same');
    if (sort)
      arguments.add('/sort');
    if (randomize)
      arguments.add('/randomize');
    if (newInstance)
      arguments.add('/new');
    if (currentInstance)
      arguments.add('/current');
    if (clipboard)
      arguments.add('/clipboard');
    if (seek != null)
      arguments.add('/seek=${seek!.inMilliseconds / Duration.millisecondsPerSecond}');
    if (subtitle != null)
      arguments.add('/sub="$subtitle"');
    if (userAgent != null)
      arguments.add('/user_agent="$userAgent"');
    if (referer != null)
      arguments.add('/referer="$referer"');
    if (httpHeaders != null)
      arguments.add('/headers="${httpHeaders!.join(r'\r\n')}"');
    if (title != null)
      arguments.add('/title="$title"');
    if (config != null)
      arguments.add('/config="$config"');
    return arguments.join(' ');
  }
}
