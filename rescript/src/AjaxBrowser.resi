open AjaxManager

module AjaxEnvBrowser: AjaxEnv

module type AjaxBrowser = (Data: AjaxData.Data) => (AjaxManager with type data = Data.data)

module AjaxBrowser: AjaxBrowser

module type AjaxBrowserUnknown = AjaxManager with type data = unknown

module AjaxBrowserUnknown: AjaxBrowserUnknown

module type AjaxBrowserText = AjaxManager with type data = string

module AjaxBrowserText: AjaxBrowserText
