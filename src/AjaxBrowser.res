open AjaxManager

module AjaxEnvBrowser: AjaxEnv = {
  let getAxios: unit => axios = %raw(`
  function () {
    return require('axios/dist/browser/axios.cjs');
  }
  `)
}

module type AjaxBrowser = (Data: AjaxData.Data) => (AjaxManager with type data = Data.data)
module AjaxBrowser: AjaxBrowser = MakeAjaxManager(AjaxEnvBrowser)

module type AjaxBrowserUnknown = AjaxManager with type data = unknown
module AjaxBrowserUnknown: AjaxBrowserUnknown = MakeAjaxManager(
  AjaxEnvBrowser,
  AjaxData.DataUnknown,
)

module type AjaxBrowserText = AjaxManager with type data = string
module AjaxBrowserText: AjaxBrowserText = MakeAjaxManager(AjaxEnvBrowser, AjaxData.DataText)
