import parser, params, types
import net, strutils
import terminal

var openedPorts: seq[Socket] = @[]

proc initRouter*(): Router =
    return Router(routes: @[]);

proc removeRepeatedRoute*(targetRouter: var Router, path: string) = 
    for r in targetRouter.routes:
        if r.path == path:
            targetRouter.routes.delete(targetRouter.routes.find(r))

proc get*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.removeRepeatedRoute(path)
    targetRouter.routes.add(Route(path: path, httpMethod: "GET", handler: handler, description:description))

proc post*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.removeRepeatedRoute(path)
    targetRouter.routes.add(Route(path: path, httpMethod: "POST", handler: handler, description:description))
    
proc put*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.removeRepeatedRoute(path)
    targetRouter.routes.add(Route(path: path, httpMethod: "PUT", handler: handler, description:description))

proc head*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.removeRepeatedRoute(path)
    targetRouter.routes.add(Route(path: path, httpMethod: "HEAD", handler: handler, description:description))

proc options*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.removeRepeatedRoute(path)
    targetRouter.routes.add(Route(path: path, httpMethod: "OPTIONS", handler: handler, description:description))

proc delete*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.removeRepeatedRoute(path)
    targetRouter.routes.add(Route(path: path, httpMethod: "DELETE", handler: handler, description:description))

proc callRoute*(rout: Route, client: Socket, parsed: SemiParsedRequest, router:Router, origin: string) = 
    # Use parseParams to get fully parsed request
    let fullParsed = parsed.parseParams(rout);
    let request = Request(body: parsed.body, path: parsed.path, httpMethod: parsed.httpMethod, origin: origin, itemParams:fullParsed.itemParams, queryParams:fullParsed.queryParams);
    let response = Response(client: client, origin: origin, path: parsed.path, httpMethod: parsed.httpMethod);
    rout.handler(request, response);

proc filterRequest*(client: Socket, parsed: SemiParsedRequest, router:Router, origin: string) = 
    var match: bool = false;
    for rout in router.routes:
        let pathWithoutQueryParams = parsed.path.split("?")[0]
        if rout.httpMethod == parsed.httpMethod and rout.path == pathWithoutQueryParams:
            # call
            rout.callRoute(client, parsed, router, origin)
            match=true;
            break;
        elif pathWithoutQueryParams.isTemplated(rout.path):
            # call
            rout.callRoute(client, parsed, router, origin)
            match=true;
            break;
            
    # 404 Not found
    if not match:
        styledEcho(fgRed, parsed.httpMethod & " " & parsed.path & " " & origin & " 404 (Not Found)")
        client.send("HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: " & $len("Not Found") & "\r\n\r\nNot Found")
        let index = openedPorts.find(client)
        if index >= 0:
            delete(openedPorts, index)
        client.close()

# Create a gracefull server shutdown
proc onCtrlC() {.noconv.} =
    echo "Closing server and cleaning"
    for socket in openedPorts:
        socket.close()
    # Add your cleanup code here
    quit(0) # Exit the program gracefully

setControlCHook(onCtrlC)

proc start*(router: Router, portNumber: int, verbose:bool=false) = 
    let socket = newSocket()
    try: 
        socket.bindAddr(Port(portNumber))
    except:
        echo "Error in creating port. It may be already in use or the current user does not have rights to create ports."
    socket.listen()
    openedPorts.add(socket)
    var client: Socket
    if verbose==true:
        echo "Started listening on port portN".replace("portN", $portNumber)

    while true:
        socket.accept(client)

        # Recieved request
        openedPorts.add(client)
        let clientAddress = client.getPeerAddr()
        let parsed: SemiParsedRequest = parseRequest(client)
        client.filterRequest(parsed, router, clientAddress[0])