open AjaxManager

module AjaxEnvNode = {
  let getAxios: unit => axios = %raw(`
  function() {
    return require('axios/dist/node/axios.cjs');
  }
  `)
}

module AjaxNode = MakeAjaxManager(AjaxEnvNode)
