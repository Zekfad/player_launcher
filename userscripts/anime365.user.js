// ==UserScript==
// @name         Anime365 play via PotPlayer
// @namespace    https://znnme.eu.org/
// @version      2.0.0
// @description  Add play via PotPlayer button to Anime365 website.
// @downloadURL  https://raw.githubusercontent.com/Zekfad/player_launcher/master/userscripts/anime365.user.js
// @updateURL    https://raw.githubusercontent.com/Zekfad/player_launcher/master/userscripts/anime365.meta.js
// @author       Zekfad
// @match        https://smotret-anime.com/*
// @match        https://smotret-anime.online/*
// @match        https://anime365.ru/*
// @match        https://hentai365.ru/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=anime365.ru
// @grant        none
// @run-at document-end
// ==/UserScript==

(async function () {
	'use strict';
	const launcherProtocol = 'player-launcher:';
	const launcherProtocolVersion = 2;

	const isMac = navigator.platform.indexOf("Mac") === 0;
	// const isMac = true;

	class QuerySelectors {
		static page = '.is-anime-site,.is-hentai-site';
		static downloadCard = '.card .m-translation-view-download';
		static downloadVideoButton = 'a[download].btn[href*="/translations/mp4/"]';
		static downloadSubtitlesButton = 'a[download].btn[href*="/translations/ass/"]';
	}
	const pageLoadingClass = 'dynpage-loading';
	const pageElement = document.querySelector(QuerySelectors.page);
	const pageObserver = new MutationObserver(mutationHandler);

	pageObserver.observe(pageElement, {
		attributes     : true,
		attributeFilter: [ 'class', ],
		// attributeOldValue: true,
	});

	onPageLoad(true);

	/** @type {MutationCallback} */
	function mutationHandler(mutations, observer) {
		for (const mutation of mutations) {
			if (pageElement === mutation.target) {
				onPageLoad(!pageElement.classList.contains(pageLoadingClass));
			}
		}
	}

	function onPageLoad(loadingDone = true) {
		if (loadingDone) {
			const card = document.querySelector(QuerySelectors.downloadCard);
			if (card) {
				/** @type {NodeListOf<HTMLAnchorElement>} */
				const videoDownloadButtons = document.querySelectorAll(QuerySelectors.downloadVideoButton);
				/** @type {HTMLAnchorElement} */
				const subtitlesDownloadButton = document.querySelector(QuerySelectors.downloadSubtitlesButton);
				const subtitlesUrl = subtitlesDownloadButton?.href;
				videoDownloadButtons.forEach(
					createAndAttachPlayViaExternalPlayerButton.bind(
						createAndAttachPlayViaExternalPlayerButton,
						subtitlesUrl
					)
				);
			}
		}
	}

	/**
	 * @param {string}            subtitlesUrl Subtitles URL.
	 * @param {HTMLAnchorElement} button       Button to place new button after. 
	 */
	async function createAndAttachPlayViaExternalPlayerButton(subtitlesUrl, button) {
		const quality = Array.from(
			new URL(button.href).searchParams
		).find(
			(keyValue) => keyValue[0] == 'height'
		)[1];
		const videoDownloadUrl = await getTargetUrl(button.href);
		const playButton = document.createElement('a');

		playButton.classList.add(...[
			'waves-effect',
			'waves-light',
			'btn',
			'blue',
			'darken-1',
			'white-text',
			'no-dynpage',
		]);

		const protocolUri = `${launcherProtocol}?v=${launcherProtocolVersion}&payload=${encodeURIComponent(JSON.stringify({
			video: videoDownloadUrl,
			subtitles: subtitlesUrl,
		}))}`;

		playButton.innerText = `Play via external player (${quality}P)`;
		playButton.href = protocolUri;

		if (isMac) {
			// Temporary workaround
			// const iinaCmd = `/Applications/IINA.app/Contents/MacOS/iina-cli "${videoDownloadUrl}" --mpv-sub-files-append="${subtitlesUrl}"`;
			// playButton.innerText = `Copy IINA command-line (${quality}P)`;
			// playButton.href = `javascript:navigator.clipboard.writeText('${iinaCmd}');`;

			playButton.onclick = async () => {
				let retry = true;
				setTimeout(() => {
					retry = false;
				}, 5000);
				while (retry) {
					try {
						await fetch(`http://127.0.0.1:13370/?uri=${encodeURIComponent(protocolUri)}`, {
							mode: 'cors',
						});
						retry = false;
					} catch(e) {}
				}
			}
		}

		button.after(playButton);
	}

	/**
	 * @param {String} url
	 * @returns {Promise<string>}
	 */
	async function getTargetUrl(url) {
		const abortController = new AbortController();
		const response = await fetch(url, {
			signal: abortController.signal,
		});
		abortController.abort();
		return response.url;
	}
})();
