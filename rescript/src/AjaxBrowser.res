open AjaxManager

module AjaxEnvBrowser = {
  let getAxios: unit => axios = %raw(`
  function () {
    return require('axios/dist/browser/axios.cjs');
  }
  `)
}

module AjaxBrowser = MakeAjaxManager(AjaxEnvBrowser)

module AjaxBrowserUnknown = MakeAjaxManager(AjaxEnvBrowser, AjaxData.DataUnknown)

module AjaxBrowserText = MakeAjaxManager(AjaxEnvBrowser, AjaxData.DataText)
