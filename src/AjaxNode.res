open AjaxManager

module AjaxEnvNode = {
  let getAxios: unit => axios = %raw(`
  function() {
    return require('axios');
  }
  `)
}

module type AjaxNode = (Data: AjaxData.Data) => (AjaxManager with type data = Data.data)
module AjaxNode: AjaxNode = MakeAjaxManager(AjaxEnvNode)

module type AjaxNodeUnknown = AjaxManager with type data = unknown
module AjaxNodeUnknown: AjaxNodeUnknown = MakeAjaxManager(AjaxEnvNode, AjaxData.DataUnknown)

module type AjaxNodeText = AjaxManager with type data = string
module AjaxNodeText: AjaxNodeText = MakeAjaxManager(AjaxEnvNode, AjaxData.DataText)
