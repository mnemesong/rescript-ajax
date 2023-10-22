open AjaxData
open AjaxParams
open WebTypes
open AjaxConfig

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
module MakeAjaxManager: MakeAjaxManager
