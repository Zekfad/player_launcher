// ==UserScript==
// @name         Anime365 play via PotPlayer
// @namespace    https://znnme.eu.org/
// @version      1.0.0
// @description  Add play via PotPlayer button to Anime365 website.
// @downloadUrl  https://raw.githubusercontent.com/Zekfad/potplayer_launcher/master/userscripts/anime365.user.js
// @updateUrl    https://raw.githubusercontent.com/Zekfad/potplayer_launcher/master/userscripts/anime365.meta.js
// @author       Zekfad
// @match        https://smotret-anime.com/*
// @match        https://smotret-anime.online/*
// @match        https://anime365.ru/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=anime365.ru
// @grant        none
// @run-at document-end
// ==/UserScript==

(async function () {
	'use strict';
	class Selectors {
		static page = '.is-anime-site';
		static downloadCard = '.card .m-translation-view-download';
		static downloadVideoButton = 'a[download].btn[href*="/translations/mp4/"]';
		static downloadSubtitlesButton = 'a[download].btn[href*="/translations/ass/"]';
	}
	const pageLoadingClass = 'dynpage-loading';
	const pageElement = document.querySelector(Selectors.page);
	const pageObserver = new MutationObserver(mutationHandler);

	pageObserver.observe(pageElement, {
		attributes     : true,
		attributeFilter: ['class',],
		// attributeOldValue: true,
	});

	onPageLoad(true);

	function mutationHandler(mutationList, observer) {
		for (const mutation of mutationList) {
			if (pageElement === mutation.target) {
				onPageLoad(!mutation.target.classList.contains(pageLoadingClass));
			}
		}
	}

	function onPageLoad(loaded = true) {
		if (loaded) {
			const card = document.querySelector(Selectors.downloadCard);
			if (card) {
				const videoDownloadButtons = document.querySelectorAll(Selectors.downloadVideoButton)
				const subtitlesUrl = document.querySelector(Selectors.downloadSubtitlesButton)?.href;
				videoDownloadButtons.forEach(
					createPlayViaPotPlayerButton.bind(createPlayViaPotPlayerButton, subtitlesUrl)
				);
			}
		}
	}

	async function createPlayViaPotPlayerButton(subtitlesUrl, button) {
		const quality = Array.from(
			new URL(button.href).searchParams
		).find(
			(query) => query[0] == 'height'
		)[1];
		const downloadUrl = await getTargetUrl(button.href);
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
		playButton.innerText = `Play via PotPlayer (${quality}P)`;
		playButton.href = `potplayer:?${JSON.stringify({
			url     : downloadUrl,
			subtitle: subtitlesUrl,
		})}`;

		button.after(playButton);
	}

	async function getTargetUrl(url) {
		const controller = new AbortController();
		const res = await fetch(url, {
			signal: controller.signal,
		});
		controller.abort();
		return res.url;
	}
})();
