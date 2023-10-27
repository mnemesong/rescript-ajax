// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var AjaxNode = require("../src/AjaxNode.bs.js");
var ResultExn = require("rescript-result-exn/lib/js/src/ResultExn.bs.js");

async function sendAjaxToDotabuff(param) {
  return ResultExn.getExn(await ResultExn.thenTryMap(Curry._3(AjaxNode.AjaxNode.sendAjaxParams, {
                      TAG: /* FormUrlencoded */0,
                      _0: "get",
                      _1: "http://ru.dotabuff.com/"
                    }, {}, []), (function (res) {
                    console.log(res.data);
                  })));
}

sendAjaxToDotabuff(undefined);

exports.sendAjaxToDotabuff = sendAjaxToDotabuff;
/*  Not a pure module */