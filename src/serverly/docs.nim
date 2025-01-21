import types, router, response, strutils, params

#[
  Color palette: https://coolors.co/5fb1ef-f7a072-ff5356-9a275a-aaffb1
  GET: AAFFB1
  POST: 5FB1EF
  PUT: F7A072
  OPTIONS: 9A275A
  DELETE: FF5356
]#

const docJS = """
function copyBlockCode(){
  let copyText = window.event.target.parentNode.children[0];
  console.log(copyText)
   copyText.select();
    copyText.setSelectionRange(0, 99999);
 navigator.clipboard.writeText(copyText.value)
}

function toggleBlock(){
  let cont = window.event.target.parentNode.children[1];
cont.classList.toggle("block-content-vis")
}

let undefinedValue = {
  number: 0,
  string: "something"
}

function runBlock(e){
  let block = e.target.parentNode;
  window.runningResponse = block.getElementsByClassName("block-run-response")[0];
  let path = block.getElementsByClassName("block-code-content")[0].value;
  let arr = Array.from(block.getElementsByClassName("block-single-parameter"))
  let queryParams = new URLSearchParams("");
  let body=null;
  for(let p in arr){
    if(arr[p].getAttribute("paramtype") == "item"){
      path = path.replace(":" + arr[p].children[0].innerText.replace(":",""), arr[p].children[1].value)
    }
    else if(arr[p].getAttribute("paramtype") == "query"){
      queryParams.set(arr[p].children[0].innerText.replace(":",""),arr[p].children[1].value);
    }
    else if(arr[p].getAttribute("paramtype") == "body"){
      body=arr[p].children[1].value
    }
  }
  
  path += queryParams.toString()

  let method = block.parentNode.children[0].innerText.split(" ")[0];
  console.log(path, method)
  
  // send req
  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "text/plain");

  const raw = body != null ? body : "null";

  let requestOptions;
  if(raw == "null"){
    requestOptions = {
      method: method,
      headers: myHeaders,
      redirect: "follow"
    };
  }
  else{
    requestOptions = {
      method: method,
      headers: myHeaders,
      body: raw,
      redirect: "follow"
    };
  }

  fetch(path, requestOptions)
    .then((response) => response.text())
    .then((result) => runningResponse.innerHTML = result)
    .catch((error) => console.error(error));
}

function startTestingBlock(){
  let block = window.event.target.parentNode;
  // Activate param input
  let arr = Array.from(block.getElementsByClassName("block-single-parameter"))
  for(let p in arr){
    arr[p].children[1].type=arr[p].children[1].getAttribute("value");
    arr[p].children[1].value=undefinedValue[arr[p].children[1].value];
    arr[p].children[1].disabled=false;
  }
  // Change button text and function
  block.getElementsByClassName("block-test")[0].innerHTML = "Run test";
  block.getElementsByClassName("block-test")[0].onclick = runBlock;
}
"""

const docCSS = """
@import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100..800;1,100..800&display=swap');

* {
  font-family: "JetBrains Mono", serif;
  font-optical-sizing: auto;
  font-style: normal;
}

.block-title{
  cursor: pointer;
}

.subtext, .subtext *{
  font-style: italic;
}

.block{
  width: 95%;
  border: 5px solid green;
  border-radius: 1rem;
  padding: 10px;
  padding-bottom: 20px;
  margin-bottom: 10px;
}

.block-code *{
  all: unset;
  display: inline;
  margin: 0px;
}

.block-code{
  display: flex;
  justify-content: space-between;
  flex-direction: row;
  width: calc(100% - 40px);
  padding: 15px;
  background-color: lightgray;
  margin: 5px;
  border-radius: .5rem;
  align-items: center;
  height: 20px;
}

.block-code button{
  opacity: 0;
  padding: 11px;
  background-color: white;
  border-radius: 1rem;
  aspect-ratio: 1;
  text-align: center;
  cursor: pointer;
  transition: opacity .3s;
}

.block-code:hover button{
  opacity: 1;
}

.block-code input{
  font-size: 20px;
}

.block-test{
  all: unset;
  cursor: pointer;
  font-family: inherit;
  background-color: green;
  color: white;
  padding: 10px;
  border-radius: .5rem;
}

.block-single-parameter *{
  all: unset;
  font-family: inherit;
  display: inline;
}

.block-content{
  transition: height,opacity 1s;
  height: 0px;
  opacity: 0;
}

.block-content-vis{
  transition: height,opacity 1s;
  height: 100%;
  opacity: 1;
}

.GET{
  border-color: #AAFFB1;
}
.GET input[type="string"] {
  border: 2px solid #AAFFB1;
  border-radius: .5rem;
}

.POST{
  border-color: #5FB1EF;
}
.POST input[type="string"] {
  border: 2px solid #5FB1EF;
  border-radius: .5rem;
}

.PUT{
  border-color: #F7A072;
}
.PUT input[type="string"] {
  border: 2px solid #F7A072;
  border-radius: .5rem;
}

.OPTIONS{
  border-color: #9A275A;
}
.OPTIONS input[type="string"] {
  border: 2px solid #9A275A;
  border-radius: .5rem;
}

.DELETE{
  border-color: #FF5356;
}
.DELETE input[type="string"] {
  border: 2px solid #FF5356;
  border-radius: .5rem;
}

"""

proc generateSingleRouteBlock(targetRoute: Route): string = 
    let title = targetRoute.httpMethod & " " & targetRoute.path.split("?")[0];
    var parameters = """""";
    # Parameters
    # Item parameters
    var itemParams = targetRoute.path.split("?")[0].formatString().split("/");
    for ipar in itemParams:
      if ipar.startsWith(":"):
        parameters = parameters & """
        <div class="block-single-parameter" paramtype="item"><p>""" & ipar.replace(":","") & """:</p><input disabled value="string"></div>
        """
    return """
        <div class="block """ & targetRoute.httpMethod &  """">
    <h2 onclick="toggleBlock()" class="block-title">""" & title &  """</h2>
    <div class="block-content">
      <p class="block-description">""" & targetRoute.description & """</p>
      <div class="block-code">
        <input class="block-code-content" value="""" & targetRoute.path.split("?")[0] & """" disabled>
        <button class="block-code-copy" onclick="copyBlockCode()">Copy</button>
      </div>
      <div class="block-parameters">
        <h2>Parameters</h2>
        """ & parameters & """
      </div>
      <button onclick="startTestingBlock()" class="block-test">Test</button>
      <p class="block-run-response"></p>
    </div>
  </div>
    """

proc generateBlocksFromRouter(targetRouter: var Router): string =
  var code = """""";
  for r in targetRouter.routes:
    code = code & r.generateSingleRouteBlock()
  return code;

var docString: string

proc docs*(targetRouter: var Router, path: string="/docs") = 
    docString = """
    <!DOCTYPE html>
    <html>
    <h1>API documentation</h1>
    <p class="subtext">Automatically generated by <a href="https://nimble.directory/pkg/serverly">Serverly</a></p>
    <div id="blocks">
    """ & targetRouter.generateBlocksFromRouter() & """
    </div>
    <script>
    """ & docJS & """
    </script>
    <style>
    """ & docCSS & """
    </style>
    </html>
    """

    targetRouter.get(path, proc(req: Request, res: Response) = 
        res.send(docString, contentType="text/html")
    )
