// ==UserScript==
// @name          StringPie
// @namespace     http://tampermonkey.net/
// @version       2025-01-30
// @description   Fills all inputs on a page with random string.
// @author        You
// @match         *://*/*
// @grant         none
// ==/UserScript==
// noinspection GrazieInspection

(function () {
  "use strict";

  const LETTERS = "qwertyuiopasdfghjklzxcvbnm";
  const SYMBOLS = "+!@#$%^&*";
  const NUMBERS = "0123456789";

  /**
   * @param {number} upper
   * @returns {number}
   */
  function rnd(upper) {
    return Math.ceil(Math.random() * upper || 1000);
  }

  /**
   * @param {string} seq
   * @returns {string}
   */
  function pickAnyFromString(seq) {
    return seq[rnd(seq.length)];
  }

  /**
   * @param {string} seq
   * @param {number} times
   * @returns {string}
   */
  function buildRandomString(seq, times) {
    const tokens = new Array(times).fill("");
    tokens.forEach((_, index) => {
      tokens[index] = pickAnyFromString(seq);
    });
    return tokens.join("");
  }

  /**
   * @param {HTMLInputElement} input
   */
  function guessType(input) {
    if (input.value.length > 0) {
      return "skip";
    }
    switch (input.autocomplete) {
      case "new-password": {
        return "password";
      }
    }
    if (input.placeholder.toLowerCase().indexOf("email") > -1) {
      return "email";
    }
    return input.type;
  }

  /**
   * @param {HTMLInputElement} input
   * @param {string} value
   */
  function setValue(input, value) {
    input.focus();
    input.value = value;
    input.dispatchEvent(new Event("input", { bubbles: true }));
    input.dispatchEvent(new Event("change", { bubbles: true }));
    input.blur();
  }

  /**
   * @param {HTMLInputElement} input
   * @param {boolean} value
   */
  function setChecked(input, value) {
    input.focus();
    input.checked = value;
    input.dispatchEvent(new Event("change", { bubbles: true }));
    input.blur();
  }

  document.addEventListener("keypress", (ev) => {
    if (!(ev.ctrlKey && ev.key === "i")) {
      return;
    }
    document.querySelectorAll("input").forEach((input) => {
      /** @type {string | undefined} **/
      let value = undefined;
      /** @type {boolean | undefined} **/
      let checked = undefined;
      switch (guessType(input)) {
        case "email":
          value = `${buildRandomString(LETTERS, 10)}@local.domain`;
          break;
        case "password":
          value = buildRandomString(LETTERS + SYMBOLS + NUMBERS, 16);
          break;
        case "checkbox":
          checked = true;
          break;
        case "skip":
          break;
        default:
          value = buildRandomString(LETTERS, 5);
          break;
      }
      if (value !== undefined) {
        setValue(input, value);
      } else if (checked !== undefined) {
        setChecked(input, checked);
      }
    });
    /** @type NodeListOf<HTMLInputElement> **/
    const pwd = document.querySelectorAll("input[autocomplete=new-password]");
    if (pwd.length === 2) {
      const [first, second] = pwd;
      setValue(second, first.value);
    }
  });
})();
