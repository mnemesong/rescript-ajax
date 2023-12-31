// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var AjaxConfig = require("./AjaxConfig.bs.js");
var AjaxParams = require("./AjaxParams.bs.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Caml_option = require("rescript/lib/js/caml_option.js");

function MakeAjaxManager(AE) {
  var sendAxios = (function (axios, params) {
      return axios(params).then(res => ({
        TAG: /* Ok */ 0,
        _0: {
          data: res.data,
          status: res.status,
          headers: res.headers
        }
      })).catch(e => ({
        TAG: /* Error */ 1,
        _0: e
      }));
  });
  var sendAjaxParams = function (action, params, advParams) {
    var reqParams;
    if (action.TAG === /* FormUrlencoded */0) {
      var method = action._0;
      reqParams = {
        method: method,
        url: action._1,
        params: method === "get" ? Caml_option.some(params) : undefined,
        data: method === "get" ? undefined : Caml_option.some(AjaxParams.structToFormData(params))
      };
    } else {
      var method$1 = action._0;
      reqParams = {
        method: method$1,
        url: action._1,
        params: method$1 === "get" ? Caml_option.some(params) : undefined,
        data: method$1 === "get" ? undefined : Caml_option.some(AjaxParams.structToFormData(params))
      };
    }
    var paramsContainer = AjaxConfig.buildParamsContainer(reqParams, advParams);
    return sendAxios(Curry._1(AE.getAxios, undefined), paramsContainer);
  };
  var sendAjaxFormData = function (action, formData, advParams) {
    var reqParams;
    if (action.TAG === /* FormUrlencoded */0) {
      var method = action._0;
      reqParams = {
        method: method,
        url: action._1,
        params: method === "get" ? Caml_option.some(AjaxParams.formDataToStruct(formData)) : undefined,
        data: method === "get" ? undefined : Caml_option.some(formData)
      };
    } else {
      var method$1 = action._0;
      reqParams = {
        method: method$1,
        url: action._1,
        params: method$1 === "get" ? Caml_option.some(AjaxParams.formDataToStruct(formData)) : undefined,
        data: method$1 === "get" ? undefined : Caml_option.some(formData)
      };
    }
    var paramsContainer;
    paramsContainer = action.TAG === /* FormUrlencoded */0 ? AjaxConfig.buildParamsContainer(reqParams, Belt_Array.concat(advParams, [{
                  TAG: /* AjaxHeaders */1,
                  _0: [[
                      "Content-Type",
                      "application/json"
                    ]]
                }])) : AjaxConfig.buildParamsContainer(reqParams, Belt_Array.concat(advParams, [{
                  TAG: /* AjaxHeaders */1,
                  _0: [[
                      "Content-Type",
                      "multipart/form-data"
                    ]]
                }]));
    return sendAxios(Curry._1(AE.getAxios, undefined), paramsContainer);
  };
  return {
          sendAjaxParams: sendAjaxParams,
          sendAjaxFormData: sendAjaxFormData
        };
}

exports.MakeAjaxManager = MakeAjaxManager;
/* No side effect */
