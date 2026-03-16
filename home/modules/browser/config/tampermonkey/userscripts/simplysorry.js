// ==UserScript==
// @name         SimplySorry
// @namespace    http://tampermonkey.net/
// @version      2025-01-09
// @description  Checks if page blocked and deals with it.
// @author       You
// @match        https://simplywall.st/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=simplywall.st
// @grant        none
// ==/UserScript==

(function () {
  "use strict";
  setInterval(() => {
    document
      .querySelector("[data-cy-id='premium-price']")
      ?.closest("#modal-container")
      .remove();
    document.getElementById("root").style.filter = "initial";
    document
      .querySelector("[data-cy-id='careers-upsell']")
      ?.closest("#empty-container")
      .remove();
  }, 100);
})();
