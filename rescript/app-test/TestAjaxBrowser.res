open AjaxBrowser
open AjaxData

let sendQuerySelectHtmlElem: string => option<Dom.htmlElement> = %raw(`
function (qs) {
  return document.querySelector(qs);
}
`)
@@warning("-26")

let sendGet = () => {
  switch sendQuerySelectHtmlElem("#getForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => {
      let res =
        FormUrlencoded(#get, "/get")->AjaxBrowser.sendAjaxFormData(collectFormData(htmlEl), [])
          |> Js.Promise.then_(a => {
            Js.Console.log(a)
            Js.Promise.resolve()
          })
    }
  }
}

let sendPost = () => {
  switch sendQuerySelectHtmlElem("#postForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => {
      let res =
        FormUrlencoded(#post, "/post")->AjaxBrowser.sendAjaxFormData(collectFormData(htmlEl), [])
          |> Js.Promise.then_(a => {
            Js.Console.log(a)
            Js.Promise.resolve()
          })
    }
  }
}

let sendMultipart = () => {
  switch sendQuerySelectHtmlElem("#multipartForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => {
      let res =
        MultipartFormData(#post, "/multipart")->AjaxBrowser.sendAjaxFormData(
          collectFormData(htmlEl),
          [],
        )
          |> Js.Promise.then_(a => {
            Js.Console.log(a)
            Js.Promise.resolve()
          })
    }
  }
}

@@warning("+26")
%%raw(`
document.getElementById("sendGetBtn").onclick = sendGet;
document.getElementById("sendPostBtn").onclick = sendPost;
document.getElementById("sendMultipartBtn").onclick = sendMultipart;
`)
