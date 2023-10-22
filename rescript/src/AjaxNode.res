open AjaxManager

module AjaxEnvNode = {
  let getAxios: unit => axios = %raw(`
  function() {
    return require('axios');
  }
  `)
}

module AjaxNode = MakeAjaxManager(AjaxEnvNode)

module AjaxNodeUnknown = MakeAjaxManager(AjaxEnvNode, AjaxData.DataUnknown)

module AjaxNodeText = MakeAjaxManager(AjaxEnvNode, AjaxData.DataText)
