// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var AjaxManager = require("./AjaxManager.bs.js");

var getAxios = (function () {
    return require('axios/dist/browser/axios.cjs');
  });

var AjaxEnvBrowser = {
  getAxios: getAxios
};

var AjaxBrowser = AjaxManager.MakeAjaxManager(AjaxEnvBrowser);

exports.AjaxEnvBrowser = AjaxEnvBrowser;
exports.AjaxBrowser = AjaxBrowser;
/* AjaxBrowser Not a pure module */
