open AjaxData
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
  type data

  let sendAjaxParams: (action, 'p, array<advAjaxParam>) => promise<ajaxResponse<data>>
  let sendAjaxFormData: (action, formData, array<advAjaxParam>) => promise<ajaxResponse<data>>
}

module type MakeAjaxManager = (AE: AjaxEnv, Data: Data) => (AjaxManager with type data = Data.data)

module MakeAjaxManager: MakeAjaxManager = (AE: AjaxEnv, Data: Data) => {
  type data = Data.data

  let checkResult = (res: result<'a, string>): 'a => res->Result.getExn

  let sendAxios: (
    axios,
    reqConfigContainer,
    unknown => result<data, string>,
    result<'a, string> => 'a,
  ) => promise<ajaxResponse<data>> = %raw(`
  function (axios, params, parse, checkResult) {
      return axios(params).then(res => {
        return {
          data: checkResult(parse(res.data)),
          status: res.status,
          headers: res.headers
        }
      });
  }
  `)

  let sendAjaxParams = (action: action, params: 'p, advParams: array<advAjaxParam>): promise<
    ajaxResponse<data>,
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
    sendAxios(AE.getAxios(), paramsContainer, Data.parseData, checkResult)
  }

  let sendAjaxFormData = (
    action: action,
    formData: formData,
    advParams: array<advAjaxParam>,
  ): promise<ajaxResponse<data>> => {
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
    sendAxios(AE.getAxios(), paramsContainer, Data.parseData, checkResult)
  }
}
