open AjaxManager

module AjaxEnvNode: AjaxEnv

module type AjaxNode = (Data: AjaxData.Data) => (AjaxManager with type data = Data.data)
module AjaxNode: AjaxNode

module type AjaxNodeUnknown = AjaxManager with type data = unknown
module AjaxNodeUnknown: AjaxNodeUnknown

module type AjaxNodeText = AjaxManager with type data = string
module AjaxNodeText: AjaxNodeText
