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
  | Some(htmlEl) => {
      let res =
        await FormUrlencoded(#get, "/get")->AjaxBrowserUnknown.sendAjaxFormData(
          collectFormData(htmlEl),
          [],
        )
      Js.Console.log(res)
    }
  }
}

let sendPost = async () => {
  switch sendQuerySelectHtmlElem("#postForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => {
      let res =
        await FormUrlencoded(#post, "/post")->AjaxBrowserUnknown.sendAjaxFormData(
          collectFormData(htmlEl),
          [],
        )
      Js.Console.log(res)
    }
  }
}

let sendMultipart = async () => {
  switch sendQuerySelectHtmlElem("#multipartForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => {
      let res =
        await MultipartFormData(#post, "/multipart")->AjaxBrowserUnknown.sendAjaxFormData(
          collectFormData(htmlEl),
          [],
        )
      Js.Console.log(res)
    }
  }
}

@@warning("+26")
%%raw(`
document.getElementById("sendGetBtn").onclick = sendGet;
document.getElementById("sendPostBtn").onclick = sendPost;
document.getElementById("sendMultipartBtn").onclick = sendMultipart;
`)
