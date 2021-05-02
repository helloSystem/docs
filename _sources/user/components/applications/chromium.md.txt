# Chromium

__Chromium__ is an optional web browser that can be used on helloSystem.

Upon first start of the Chromium browser, the following extensions are automatically installed from [https://chrome.google.com/webstore/](https://chrome.google.com/webstore/) to increase privacy and convenience:

* __I don't care about cookies__: Tries to remove annoying cookie popups automatically. Visit [https://www.i-dont-care-about-cookies.eu](https://www.i-dont-care-about-cookies.eu) to learn more about this extension. Deactivate or uninstall this extension if you would like to see cookie popups
* __uBlock Origin__: Tries to block unwanted adversising and tracking. Visit [https://github.com/gorhill/uBlock](https://github.com/gorhill/uBlock) to learn more about this extension. Deactivate or uninstall this extension if you would like to see adversising and allow trackers to track you.

You can uninstall those extensions at any time from within Chromium.

If wou would like Chromium not to install those extensions from the Chrome Web Store in the first place, remove the files in `/usr/local/share/chromium/extensions/*.json` prior to launching Chromium for the first time.
