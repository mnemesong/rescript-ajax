open AjaxBrowser

let sendData: {..} = %raw(`({
  data1: "val1",
  data2: 124,
})`)

let sendGet = () => {
  FormUrlencoded(#get, "http://localhost/get")->AjaxBrowser.sendAjaxParams(sendData, [])
    |> Js.Promise.then_(a => {
      Js.Console.log(a)
      Js.Promise.resolve([])
    })
}

let sendPost = () => {
  FormUrlencoded(#post, "http://localhost/post")->AjaxBrowser.sendAjaxParams(sendData, [])
    |> Js.Promise.then_(a => {
      Js.Console.log(a)
      Js.Promise.resolve([])
    })
}

%%raw(`
document.getElementById("sendGetBtn").onclick = sendGet;
document.getElementById("sendPostBtn").onclick = sendPost;
`)
