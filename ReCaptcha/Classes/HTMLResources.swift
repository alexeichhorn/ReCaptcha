//
//  HTMLResources.swift
//  
//
//  Created by Alexander Eichhorn on 13.12.19.
//

import Foundation


struct HTMLResources {
    
    static let main = #"""
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <style type="text/css">
      body > div {
        position: static !important;
        width: 100% !important;
        height: 100% !important;
      }

      body div > div {
        top: 50% !important;
        left: 50% !important;
        transform: translate(-50%, -50%) !important;
      }

      @media (prefers-color-scheme: dark) {
        body {
          background: rgb(28,28,30);
        }
      }
    </style>
    <script type="text/javascript">
      const post = function(value) {
        window.webkit.messageHandlers.recaptcha.postMessage(value);
      };

      console.log = function(message) {
        post({ log: message });
      };

      const observers = new Array();
      const observeDOM = function(element, completion) {
        const obs = new MutationObserver(completion);
        obs.observe(element, {
          attributes: true,
          childList: true,
          subtree: true,
          attributeFilter: ["style"]
        });

        observers.push(obs);
      };

      const clearObservers = function() {
        observers.forEach(function(o) {
          o.disconnect();
        });
        observers = [];
      };

      const execute = function() {
        console.log("executing");

        // Removes ReCaptcha dismissal when clicking outside div area
        try {
          document.getElementsByTagName("div")[4].outerHTML = "";
        } catch (e) {}

        try {
          // Listens to changes on the div element that presents the ReCaptcha challenge
          observeDOM(document.getElementsByTagName("div")[3], function() {
            post({ action: "showReCaptcha" });
          });
        } catch (e) {
          post({ error: 27 });
        }

        grecaptcha.execute();
      };

      const reset = function() {
        console.log("resetting");
        grecaptcha.reset();
        grecaptcha.ready(function() {
          post({ action: "didLoad" });
        });
      };

      var onloadCallback = function() {
        grecaptcha.render("submit", {
          sitekey: "${apiKey}",
          callback: function(token) {
            console.log(token);
            post({ token });
            clearObservers();
          },
          "expired-callback": function() {
            post({ error: 28 });
            clearObservers();
          },
          "error-callback": function() {
            post({ error: 29 });
            clearObservers();
          },
          size: "invisible"
        });

        grecaptcha.ready(function() {
          observeDOM(document.getElementById("body"), function(mut) {
            const success = !!mut.find(function({ addedNodes }) {
              return Array.from(
                addedNodes.values ? addedNodes.values() : addedNodes
              ).find(function({ nodeName, name }) {
                return nodeName === "IFRAME" && !!name;
              });
            });

            if (success) {
              post({ action: "didLoad" });
            }
          });
        });
      };
    </script>
  </head>
  <body id="body">
    <span id="submit" style="visibility: hidden;"></span>
    <script src="${endpoint}" async defer></script>
  </body>
</html>
"""#
    

    
    static let visible = #"""
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <style>
        form {
            text-align: center;
        }
        
        body {
            text-align: center;
        }
        
        h1 {
            text-align: center;
        }

        h3 {
            text-align: center;
        }

        div-captcha {
            text-align: center;
        }

        .g-recaptcha {
            display: inline-block;
        }
    </style>

    <meta name="referrer" content="never">
    <script type='text/javascript' src='https://www.google.com/recaptcha/api.js'></script>
    <script>
        const post = function(value) {
            window.webkit.messageHandlers.recaptcha.postMessage(value);
        }

        console.log = function(message) {
            post({ log: message });
        }

        const observers = new Array();
        const observeDOM = function(element, completion) {
            const obs = new MutationObserver(completion);
            obs.observe(element, {
              attributes: true,
              childList: true,
              subtree: true,
              attributeFilter: ["style"]
            });

            observers.push(obs);
        };

        const clearObservers = function() {
            observers.forEach(function(o) {
                o.disconnect();
            });
            observers = [];
        };

        const execute = function() {
            console.log("executing - noop");
        }

        const reset = function() {
            console.log("resetting");
            grecaptcha.reset();
            grecaptcha.ready(function() {
                post({ action: "didLoad" })
            });
        }

        function callback(token) {
            console.log(token);
            post({ token })
            clearObservers();
        }
        
        function errorCallback() {
            post({ error: 28 })
            clearObservers()
        }

        function expiredCallback() {
            post({ error: 29 })
            clearObservers()
        }

        grecaptcha.ready(function() {
            post({ action: "didLoad" })
        })
    </script>
</head>
<body bgcolor="#ffffff" oncontextmenu="return false">
    <div id="div-captcha">
        <br>
        <img width="50%"/>
        <br><br>
        <div class="g-recaptcha" data-sitekey="${apiKey}" data-callback="callback" data-expired-callback="expiredCallback" data-error-callback="errorCallback"></div>
    </div>
    <br>
</body>
</html>
"""#
    
}
