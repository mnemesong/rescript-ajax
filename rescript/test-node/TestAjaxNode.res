open AjaxNode

type param = {}

let sendAjaxToDotabuff = async () => {
  let result = await AjaxNodeText.sendAjaxParams(
    FormUrlencoded(#get, "http://ru.dotabuff.com/"),
    ({}: param),
    [],
  )
  Js.Console.log(result)
}

let a = sendAjaxToDotabuff()
