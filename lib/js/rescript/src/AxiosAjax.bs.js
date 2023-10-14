// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var AjaxData = require("./AjaxData.bs.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var AxiosAjaxParams = require("./AxiosAjaxParams.bs.js");

var sendAxios = (function (axios, params) {
  return axios(params);
});

function MakeAjaxManager(AE) {
  var sendAjaxParams = function (action, params, advParams) {
    var reqParams;
    if (action.TAG === /* FormUrlencoded */0) {
      var method = action._0;
      reqParams = {
        method: method,
        url: action._1,
        params: method === "get" ? Caml_option.some(params) : undefined,
        data: method === "get" ? undefined : Caml_option.some(AjaxData.structToFormData(params))
      };
    } else {
      var method$1 = action._0;
      reqParams = {
        method: method$1,
        url: action._1,
        params: method$1 === "get" ? Caml_option.some(params) : undefined,
        data: method$1 === "get" ? undefined : Caml_option.some(AjaxData.structToFormData(params))
      };
    }
    var paramsContainer = AxiosAjaxParams.buildParamsContainer(reqParams, advParams);
    return sendAxios(Curry._1(AE.getAxios, undefined), paramsContainer);
  };
  var sendAjaxFormData = function (action, formData, advParams) {
    var reqParams;
    if (action.TAG === /* FormUrlencoded */0) {
      var method = action._0;
      reqParams = {
        method: method,
        url: action._1,
        params: method === "get" ? Caml_option.some(AjaxData.formDataToStruct(formData)) : undefined,
        data: method === "get" ? undefined : Caml_option.some(formData)
      };
    } else {
      var method$1 = action._0;
      reqParams = {
        method: method$1,
        url: action._1,
        params: method$1 === "get" ? Caml_option.some(AjaxData.formDataToStruct(formData)) : undefined,
        data: method$1 === "get" ? undefined : Caml_option.some(formData)
      };
    }
    var paramsContainer = AxiosAjaxParams.buildParamsContainer(reqParams, advParams);
    return sendAxios(Curry._1(AE.getAxios, undefined), paramsContainer);
  };
  return {
          sendAjaxParams: sendAjaxParams,
          sendAjaxFormData: sendAjaxFormData
        };
}

exports.sendAxios = sendAxios;
exports.MakeAjaxManager = MakeAjaxManager;
/* No side effect */