open AjaxNode

type param = {}

let sendAjaxToDotabuff = async () => {
  (await AjaxNode.sendAjaxParams(FormUrlencoded(#get, "http://ru.dotabuff.com/"), ({}: param), [])
  ->ResultExn.thenTryMap(res => Js.Console.log(res.data)))
  ->ResultExn.getExn
}

sendAjaxToDotabuff()->ignore
