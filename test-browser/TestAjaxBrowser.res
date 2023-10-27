open AjaxBrowser
open AjaxParams

let sendQuerySelectHtmlElem: string => option<Dom.htmlElement> = %raw(`
function (qs) {
  return document.querySelector(qs);
}
`)
@@warning("-26")

let sendGet = async () => {
  switch sendQuerySelectHtmlElem("#getForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) =>
    (await FormUrlencoded(#get, "/get")
    ->AjaxBrowser.sendAjaxFormData(collectFormData(htmlEl), [])
    ->ResultExn.thenTryMap(res => Js.Console.log(res.data)))
    ->ResultExn.getExn
  }
}

let sendPost = async () => {
  switch sendQuerySelectHtmlElem("#postForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) =>
    (await FormUrlencoded(#post, "/post")
    ->AjaxBrowser.sendAjaxFormData(collectFormData(htmlEl), [])
    ->ResultExn.thenTryMap(res => Js.Console.log(res.data)))
    ->ResultExn.getExn
  }
}

let sendMultipart = async () => {
  switch sendQuerySelectHtmlElem("#multipartForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => (await MultipartFormData(#post, "/multipart")
    ->AjaxBrowser.sendAjaxFormData(collectFormData(htmlEl), [])
    ->ResultExn.thenTryMap(res => Js.Console.log(res.data)))
    ->ResultExn.getExn
  }
}

@@warning("+26")
%%raw(`
document.getElementById("sendGetBtn").onclick = sendGet;
document.getElementById("sendPostBtn").onclick = sendPost;
document.getElementById("sendMultipartBtn").onclick = sendMultipart;
`)
