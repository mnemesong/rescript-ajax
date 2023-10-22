open AjaxNode

let paramsToSend: {..} = %raw(`{}`)

let sendAjaxToDotabuff = async () => {
  let result = await AjaxNode.sendAjaxParams(
    FormUrlencoded(#get, "http://ru.dotabuff.com/"),
    paramsToSend,
    [],
  )
  Js.Console.log(result)
}

let a = sendAjaxToDotabuff()
