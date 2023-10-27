open AjaxParams
open WebTypes
open AjaxConfig
open Belt

type axios
type url = string
type action =
  | FormUrlencoded(method, url)
  | MultipartFormData(method, url)

type ajaxResponse<'d> = {
  data: 'd,
  status: int,
  headers: unknown,
}

module type AjaxEnv = {
  let getAxios: unit => axios
}

module type AjaxManager = {
  let sendAjaxParams: (
    action,
    'p,
    array<advAjaxParam>,
  ) => promise<result<ajaxResponse<unknown>, exn>>
  let sendAjaxFormData: (
    action,
    formData,
    array<advAjaxParam>,
  ) => promise<result<ajaxResponse<unknown>, exn>>
}

module type MakeAjaxManager = (AE: AjaxEnv) => AjaxManager

module MakeAjaxManager: MakeAjaxManager = (AE: AjaxEnv) => {
  let sendAxios: (axios, reqConfigContainer) => promise<result<ajaxResponse<unknown>, exn>> = %raw(`
  function (axios, params) {
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
  }
  `)

  let sendAjaxParams = (action: action, params: 'p, advParams: array<advAjaxParam>): promise<
    result<ajaxResponse<unknown>, exn>,
  > => {
    let reqParams: reqConfig<'p> = switch action {
    | FormUrlencoded(method, url) => {
        method,
        url,
        params: switch method {
        | #get => Some(params)
        | _ => None
        },
        data: switch method {
        | #get => None
        | _ => Some(structToFormData(params))
        },
      }
    | MultipartFormData(method, url) => {
        method,
        url,
        params: switch method {
        | #get => Some(params)
        | _ => None
        },
        data: switch method {
        | #get => None
        | _ => Some(structToFormData(params))
        },
      }
    }
    let paramsContainer = buildParamsContainer(reqParams, advParams)
    sendAxios(AE.getAxios(), paramsContainer)
  }

  let sendAjaxFormData = (
    action: action,
    formData: formData,
    advParams: array<advAjaxParam>,
  ): promise<result<ajaxResponse<unknown>, exn>> => {
    let reqParams: reqConfig<'p> = switch action {
    | FormUrlencoded(method, url) => {
        method,
        url,
        params: switch method {
        | #get => Some(formDataToStruct(formData))
        | _ => None
        },
        data: switch method {
        | #get => None
        | _ => Some(formData)
        },
      }
    | MultipartFormData(method, url) => {
        method,
        url,
        params: switch method {
        | #get => Some(formDataToStruct(formData))
        | _ => None
        },
        data: switch method {
        | #get => None
        | _ => Some(formData)
        },
      }
    }
    let paramsContainer = switch action {
    | FormUrlencoded(_, _) =>
      advParams->Array.concat([AjaxHeaders([("Content-Type", "application/json")])])
        |> buildParamsContainer(reqParams)
    | MultipartFormData(_, _) =>
      advParams->Array.concat([AjaxHeaders([("Content-Type", "multipart/form-data")])])
        |> buildParamsContainer(reqParams)
    }
    sendAxios(AE.getAxios(), paramsContainer)
  }
}
