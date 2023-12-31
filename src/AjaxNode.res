open AjaxManager

module AjaxEnvNode = {
  let getAxios: unit => axios = %raw(`
  function() {
    return require('axios');
  }
  `)
}

module AjaxNode: AjaxManager = MakeAjaxManager(AjaxEnvNode)
