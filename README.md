# Player launcher

Player launcher utility. Allows you to start video player from the browser.

List of supported players:

* PotPlayer (Windows)
* IINA (MacOS)

## Player launcher protocol

```url
player-launcher:?v=version&payload=json
```

Current version is `2`.

Where JSON in the following format:
```json
{
    "video"    : "Media file URL",
    "subtitles": "Optional subtitles file URL"
}
```

## launcher

Run
```shell
launcher --register [<PotPlayer executable path>]
```
to register protocol and write launcher config.

On Windows config is stored in Registry in protocol sub key "Config".

You can skip executable path, launcher will try to find executable via some known registry keys.

## Anime356 userscript

Userscript adds "Open via external player" buttons after download buttons.

Supports subtitles.

[Userscript source](userscripts/anime365.user.js) - [install userscript](https://raw.githubusercontent.com/Zekfad/player_launcher/master/userscripts/anime365.user.js).

## Mac Support

Mac support is done via IINA and launcher wrapper on Objective-C.

You can see [`main.m`](mac/launcher/main.m) for more details about how that works.
