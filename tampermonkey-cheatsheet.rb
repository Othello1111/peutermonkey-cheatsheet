# encoding: utf-8

cheatsheet do
  title 'Tampermonkey'
  docset_file_name 'Tampermonkey'
  keyword 'tampermonkey'

  introduction '[Tampermonkey userscript headers and API](http://tampermonkey.net/documentation.php).'

  category do
    id 'Userscript Headers'

    entry do
      command '@name'
      notes 'The name of the script.'
    end

    entry do
      command '@namespace'
      notes 'The namespace of the script.'
    end

    entry do
      command '@version'
      notes 'The script version. This is used for the update check, in case the script is not installed from userscript.org or Tampermonkey has problems to retrieve the scripts meta data.'
    end

    entry do
      command '@author'
      notes 'The script\'s author.'
    end

    entry do
      command '@contributor'
      notes 'One ore more contributors. Multiple tag instances are allowed.'
    end

    entry do
      command '@description'
      notes 'A short significant description.'
    end

    entry do
      command '@homepage'
      command '@homepageURL'
      command '@website'
      command '@source'
      notes 'The authors homepage that is used at the options page to link from the scripts name to the given page. Please note that if the `@namespace` tag starts with `http://` its content will be used for this too.'
    end

    entry do
      command '@icon'
      command'@iconURL'
      command '@defaulticon'
      notes 'The sript icon in low res.'
    end

    entry do
      command '@icon64'
      command '@icon64URL'
      notes 'This scripts icon in 64x64 pixels. If this tag, but `@icon` is given the `@icon` image will be scaled at some places at the options page.'
    end

    entry do
      command '@updateURL'
      notes 'An update URL for the userscript.
      Note: The script must either use the `@version` tag or the server adds a `uso:hash` key to the update check data.'
    end

    entry do
      command '@downloadURL'
      notes 'Defines the URL where the script will be downloaded from when an update was detected.'
    end

    entry do
      command '@supportURL'
      notes 'Defines the URL where the user can report issues and get personal support.'
    end

    entry do
      command '@include'
      notes <<-'END'
      The pages on that a script should run. Multiple tag instances are allowed.
      Please note that `@include` doesn't support the URL hash parameter. Please visit this forum thread for more information: [click](http://forum.tampermonkey.net/viewtopic.php?p=3094#p3094).

      ```
      // @include http://tampermonkey.net/*
      // @include http://*
      // @include https://*
      // @include *
      ```
      END
    end

    entry do
      command '@match'
      notes 'More or less equal to the `@include` tag. You can get more information [here](http://code.google.com/chrome/extensions/match_patterns.html).

      Note: The `<all_urls>` statement is not yet supported and the scheme part also accepts `http*://`.

      Multiple tag instances are allowed.'
    end

    entry do
      command '@exclude'
      notes 'Exclude URLs even it they are included by `@include` or `@match`.

      Multiple tag instances are allowed.'
    end

    entry do
      command '@require'
      notes 'Points to a JavaScript file that is loaded and executed before the script itself starts running.

      Multiple tag instances are allowed.'
    end

      entry do

      command '@resource'
      notes <<-'END'
      Preloads resource that can by accessed by `GM_getResourceURL` and `GM_getResourceText` by the script.

      ```
      // @resource icon1 http://tampermonkey.net/favicon.ico
      // @resource icon2 /images/icon.png
      // @resource html http://tampermonkey.net/index.html
      // @resource xml http://tampermonkey.net/crx/tampermonkey.xml
      ```

      Multiple tag instances are allowed.
      END
    end

    entry do
      command '@run-at'
      notes <<-'END'
      Defines the moment the script is injected. In opposition to other script handlers, `@run-at` defines the first possible moment a script wants to run. This means it may happen, that a script that uses the `@require` tag may be executed after the document is already loaded, cause fetching the required script took that long. Anyhow, all `DOMNodeInserted` and `DOMContentLoaded` events that happended after the given injection moment are cached and delivered to the script when it is injected.

      - `// @run-at document-start` <br/>
      The script will be injected as fast as possible.

      - `// @run-at document-body` <br/>
      The script will be injected if the body element exists.

      - `// @run-at document-end` <br/>
      The script will be injected when or after the DOMContentLoaded event was dispatched.

      - `// @run-at document-idle` <br/>
      The script will be injected after the DOMContentLoaded event was dispatched.

      - `// @run-at context-menu` <br/>
      The script will be injected if it is clicked at the browser context menu (desktop Chrome-based browsers only).
      Note: All `@include` and `@exclude` statements will be ignored if this value is used, but this may change in the future.
      END
    end

    entry do
      command '@grant'
      notes <<-'END'
      `@grant` is used to whitelist `GM_*` functions and the `unsafeWindow` object. If no `@grant` tag is given Tampermonkey guesses the scripts needs.

      ```
      // @grant GM_setValue
      // @grant GM_getValue
      // @grant GM_setClipboard
      // @grant unsafeWindow
      ```

      Note: Multiple instances are allowed.

      If `@grant` is followed by `none` the sandbox is disabled and the script will run directly at the page context. In this mode no `GM_*` function but the `GM_info` property will be available.

      ```
      // @grant none
      ```
      END
    end

    entry do
      command '@noframes'
      notes 'This tag makes the script running on the main pages, but not at iframes.'
    end

    entry do
      command 'unwrap'
      notes 'This tag is ignored because it is not needed at Google Chrome/Chromium.'
    end

    entry do
      command '@nocompat'
      notes <<-'END'
      At the moment Tampermonkey tries to detect whether a script was written in knowledge of Google Chrome/Chromium by looking for the `@match` tag, but not every script uses it. That's why Tampermonkey supports this tag to disable all optimizations that might be necessary to run scripts written for Firefox/Greasemonkey. To keep this tag extensible you can to add the browser name that can be handled by the script.

      ```
      // @nocompat Chrome
      ```
      END
    end
  end

  category do
    id 'Application Programming Interface'

    entry do
      command 'unsafeWindow'
      notes 'The `unsafeWindow` object provides full access to the pages JavaScript functions and variables.'
    end

    entry do
      command 'DOMAttrModified'
      notes <<-'END'
      Chrome/Chromium does not have native `DOMAttrModified` support, but in Tampermonkey statements like

      ```
      var foo = document.getElementById('whatever');
      foo.addEventListener("DOMAttrModified", function (e) {
          console.log(e);
      }), false);
      ```

      are working as usual for any attribute change of `foo`.

      Event handlers that catch bubbled events like this:

      ```
      document.addEventListener("DOMAttrModified", function(e) {
          console.log(e);
      }), false);
      ```

      are working too, but will only be notified of changes of objects that are "registered" for `DOMAttrModified like the element `foo` is.
      END
    end

    entry do
      command 'wrappedJSObject'
      notes 'Although this is not needed in Chrome/Chromium some scripts need that object to be part of HTML elements to run successfully. That\'s why Tampermonkey adds this property to every `HTMLElement` to return the (never wrapped) element.'
    end

    entry do
      command 'GM_addStyle(css)'
      notes 'Adds the given style to the document.'
    end

    entry do
      command 'GM_deleteValue(name)'
      notes 'Deletes `name` from storage.'
    end

      entry do

      command 'GM_listValues()'
      notes 'List all names of the storage.'
    end

    entry do
      command 'GM_addValueChangeListener(name, callback)'
      notes <<-'END'
      Adds a change listener to the storage and returns the listener ID.

      `callback` is a function: `function(name, old_value, new_value, remote) {}`.

      `name` is the name of the observed variable.

      The `remote` argument of the callback function shows whether this value was modified from the instance of another tab (`true`) or within this script instance (`false`).

      Therefore this functionality can be used by scripts of different browser tabs to communicate with each other.
      END
    end

    entry do
      command 'GM_removeValueChangeListener(listener_id)'
      notes 'Removes a change listener by its ID.'
    end

    entry do
      command 'GM_setValue(name, value)'
      notes 'Set the value of `name` to the storage.'
    end

    entry do
      command 'GM_getValue(name, defaultValue)'
      notes 'Get the value of `name` from storage.'
    end

    entry do
      command 'GM_log(message)'
      notes 'Log a message to the console.'
    end

    entry do
      command 'GM_getResourceText(name)'
      notes 'Get the content of a predefined `@resource` tag at the script header.'
    end

    entry do
      command 'GM_getResourceURL(name)'
      notes 'Get the base64 encoded URI of a predefined `@resource` tag at the script header.'
    end

    entry do
      command 'GM_registerMenuCommand(name, fn, accessKey)'
      notes 'Register a menu to be displayed at the Tampermonkey menu at pages where this script runs and returns a menu command ID.'
    end

    entry do
      command 'GM_unregisterMenuCommand(menuCmdId)'
      notes 'Unregister a menu command that was previously registered by `GM_registerMenuCommand` with the given menu command ID.'
    end

    entry do
      command 'GM_openInTab(url, options)'
      command 'GM_openInTab(url, loadInBackground)'
      notes 'Open a new tab with this url. The options object can have two properties: `active` decides  whether the new tab should be focused and `insert` that inserts the new tab after the current one. Otherwise the new tab is just appended. `loadInBackground` has the opposite meaning of `active` and was added to achieve Greasemonkey compatibility. The function returns an object with the function `close`, the listener `onclosed` and a flag called `closed`.'
    end

    entry do
      command 'GM_xmlhttpRequest(details)'
      notes <<-'END'
        Make an `xmlhttpRequest`. Supports:

        - cross domain requests
        - headers (user-agent, referer, ...). (needs build nr. 2656 or greater)
        - Note: The synchronous flag at the details is not supported
      END
    end

    entry do
      command 'GM_download(details)'
      command 'GM_download(url, name)'
      notes <<-'END'
      Downloads a given URL to the local disk.

      `details` can have the following attributes:

      -  `url` - the URL from where the data should be downloaded
      - `name` - the filename - for security reasons the file extension needs to be whitelisted at the Tampermonkey options page
      - `headers` - see GM_xmlhttpRequest for more details
      - `saveAs` - boolean value, show a save-As dialog
      - `onload` - `function() {}` - callback function that is called when the download has finished
      - `onerror` - `function(download) {}` - callback function that is called when there was an error

      The `download` argument of the `onerror` callback can have the following attributes:

      - `error` - error reason

        - `not_enabled` - the download feature isn't enabled by the user
        - `not_whitelisted` - the requested file extension is not whitelisted
        - `not_permitted` - the user enabled the download feature, but did not give the downloads permission
        - `not_supported` - the download feature isn't supported by the browser/version
        - `not_succeeded` - the download wasn't started or failed, the details attribute may provide more information

      - `details` - detail about that error

      Depending on the download mode `GM_info` provides a property called `downloadMode` that is set to one of the following values: `native`, `disabled` or `browser`.
      END
    end

    entry do
      command 'GM_getTab(cb)'
      notes 'Get a object that is persistent as long as this tab is open.'
    end

    entry do
      command 'GM_saveTab(tab)'
      notes 'Save the tab object to reopen it after a page unload.'
    end

    entry do
      command 'GM_getTabs(cb)'
      notes 'Get all tab objects in an array to communicate with other script instances.'
    end

    entry do
      command 'GM_notification(details, ondone)'
      command 'GM_notification(text, title, image, onclick)'
      notes <<-'END'
      Shows a HTML5 Desktop notification and/or highlight the current tab.

      `details` can have the following attributes:

      - `text` - the text of the notification (optional if highlight is set)
      - `title` - the notificaton title (optional)
      - `image` - the image (optional)
      - `highlight` - a boolean flag whether to highlight the tab that sends the notfication (optional)
      - `timeout` - the time after that the notification will be hidden (optional, 0 = disabled)
      - `ondone` - called when the notification is closed (no matter if this was triggered by a timeout or a click) or the tab was highlighted (optional)
      - `onclick` - called in case the user clicks the notification (optional)

      All parameters do exactly the same like their corresponding details property pendant.
      END
    end

    entry do
      command 'GM_setClipboard(data, info)'
      notes 'Copies data into the clipboard. The parameter `info` can be an object like `{ type: \'text\', mimetype: \'text/plain\'}` or just a string expressing the type (`text` or `html`).'
    end

    entry do
      command 'GM_installScript(url, callback)'
      notes 'Install a userscript to Tampermonkey. The callback gets an object like `{ found: true, installed: true }` that shows whether the script was found and the user installed it.'
    end

    entry do
      command 'GM_info'
      notes <<-'END'
      Get some info about the script and Tampermonkey. The object might look like this:

        ```
        Object+
        ---> script: Object+
        ------> author: ""
        ------>copyright: "2012+, You"
        ------>description: "enter something useful"
        ------>excludes: Array[0]
        ------>homepage: null
        ------>icon: null
        ------>icon64: null
        ------>includes: Array[2]
        ------>lastUpdated: 1338465932430
        ------>matches: Array[2]
        ------>isIncognito: false
        ------>downloadMode: 'browser'
        ------>name: "Local File Test"
        ------>namespace: "http://use.i.E.your.homepage/"
        ------>options: Object+
        --------->awarENDChrome: true
        --------->compat_arrayleft: false
        --------->compat_foreach: false
        --------->compat_forvarin: false
        --------->compat_metadata: false
        --------->compat_prototypes: false
        --------->compat_uW_gmonkey: false
        --------->noframes: false
        --------->override: Object+
        ------------>excludes: false
        ------------>includes: false
        ------------>orig_excludes: Array[0]
        ------------>orig_includes: Array[2]
        ------------>use_excludes: Array[0]
        ------------>use_includes: Array[0]
        --------->run_at: "document-end"
        ------>position: 1
        ------>resources: Array[0]
        ------>run-at: "document-end"
        ------>system: false
        ------>unwrap: false
        ------>version: "0.1"
        ---> scriptMetaStr: undefined
        ---> scriptSource: "// ==UserScript==\n// @name       Local File Test\n ...."
        ---> scriptUpdateURL: undefined
        ---> scriptWillUpdate: false
        ---> scriptHandler: "Tampermonkey"
        ---> version: "2.4.2716"
        ```
      END
    end

    entry do
      command '<><![CDATA[blubber]]></>'
      notes 'Tampermonkey supports this way of storing meta data. Tampermonkey tries to automatically detect whether a script needs this option to be enabled.'
    end

    entry do
      command 'for each (var k in arr)'
      notes 'Tampermonkey replaces `for each` statements by chrome compatible code. Tampermonkey tries to automatically detect whether a script needs this option to be enabled.'
    end
  end

  notes 'Not affiliated with Tampermonkey. The documentation source text used in this cheat sheet is [© 2010-2015 Jan Biniok](http://tampermonkey.net/documentation.php).'
end
