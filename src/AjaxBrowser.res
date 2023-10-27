open AjaxManager

module AjaxEnvBrowser: AjaxEnv = {
  let getAxios: unit => axios = %raw(`
  function () {
    return require('axios/dist/browser/axios.cjs');
  }
  `)
}

module AjaxBrowser: AjaxManager = MakeAjaxManager(AjaxEnvBrowser)
