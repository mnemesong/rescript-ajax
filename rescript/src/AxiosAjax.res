open AjaxData
open WebTypes
open AxiosAjaxParams

type axios
type url = string
type action = 
  | FormUrlencoded(method, url)
  | MultipartFormData(method, url)

module type AjaxEnv = {
  let getAxios: unit => axios
}

module type AjaxManager = {
  let sendAjaxParams: (action, {..}, array<advAjaxParam>) => promise<{..}>
  let sendAjaxFormData: (action, formData, array<advAjaxParam>) => promise<{..}>
}

module type MakeAjaxManager = (AE: AjaxEnv) => AjaxManager

let sendAxios: (axios, reqParamsContainer) => promise<{..}> = 
%raw(`function (axios, params) {
  return axios(params);
}`)

module MakeAjaxManager: MakeAjaxManager = (AE: AjaxEnv) => {
  let sendAjaxParams = (
    action: action, 
    params: {..}, 
    advParams: array<advAjaxParam>
  ): promise<{..}> => {
    let reqParams: reqParams<{..}> = switch action {
      | FormUrlencoded(method, url) => ({
        method: method,
        url: url,
        params: switch method {
          | #get => Some(params)
          | _ => None
        },
        data: switch method {
          | #get => None
          | _ => Some(structToFormData(params))
        }
      })
      | MultipartFormData(method, url) => ({
        method: method,
        url: url,
        params: switch method {
          | #get => Some(params)
          | _ => None
        },
        data: switch method {
          | #get => None
          | _ => Some(structToFormData(params))
        }
      })
    }
    let paramsContainer = buildParamsContainer(reqParams, advParams)
    sendAxios(AE.getAxios(), paramsContainer)
  }

  let sendAjaxFormData = (
    action: action, 
    formData: formData, 
    advParams: array<advAjaxParam>
  ): promise<{..}> => {
    let reqParams: reqParams<{..}> = switch action {
      | FormUrlencoded(method, url) => ({
        method: method,
        url: url,
        params: switch method {
          | #get => Some(formDataToStruct(formData))
          | _ => None
        },
        data: switch method {
          | #get => None
          | _ => Some(formData)
        }
      })
      | MultipartFormData(method, url) => ({
        method: method,
        url: url,
        params: switch method {
          | #get => Some(formDataToStruct(formData))
          | _ => None
        },
        data: switch method {
          | #get => None
          | _ => Some(formData)
        }
      })
    }
    let paramsContainer = buildParamsContainer(reqParams, advParams)
    sendAxios(AE.getAxios(), paramsContainer)
  }
}

