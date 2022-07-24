# PotPlayer launcher

## PotPlayer launcher protocol

```url
potplayer:?json
```

Where JSON in the following format:
```json
{
    "url"     : "Media file URL",
    "subtitle": "Optional subtitles file URL"
}
```

## launcher

Run
```shell
launcher --register <pot player executable path>
```
to register protocol and write launcher config.

## Anime356 userscript

Userscript adds "Open via PotPlayer" buttons after download buttons.

Supports subtitles.

[Userscript source](userscripts/anime365.user.js) - [install userscript](https://raw.githubusercontent.com/Zekfad/potplayer_launcher/master/userscripts/anime365.user.js).
