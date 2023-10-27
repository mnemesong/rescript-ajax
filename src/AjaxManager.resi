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
module MakeAjaxManager: MakeAjaxManager
