import parser, params, types
import net, strutils, asyncdispatch
import terminal

var openedPorts: seq[Socket] = @[]

proc initRouter*(): Router =
    return Router(routes: @[]);

#[ 
Available methods for the router:
- GET
- POST
- PUT
- HEAD
- OPTIONS
- DELETE
]#
proc get*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.routes.add(Route(path: path, httpMethod: "GET", handler: handler, description:description))

proc post*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.routes.add(Route(path: path, httpMethod: "POST", handler: handler, description:description))
    
proc put*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.routes.add(Route(path: path, httpMethod: "PUT", handler: handler, description:description))

proc head*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.routes.add(Route(path: path, httpMethod: "HEAD", handler: handler, description:description))

proc options*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.routes.add(Route(path: path, httpMethod: "OPTIONS", handler: handler, description:description))

proc delete*(targetRouter: var Router, path: string, handler: RouteHandler, description:string="") = 
    targetRouter.routes.add(Route(path: path, httpMethod: "DELETE", handler: handler, description:description))

#[
Route filtering and calling.
The "filterRequest" function takes a request and semi-parsed request data, 
and filters throughout all requests in the router and call a route with callRoute 
if one of the routes match with the request.

The "callRoute" function takes a route to call with a semi-parsed request data, 
parses the full request data, creates the request and response objects and
calls the route's handler.
]#
proc callRoute*(rout: Route, client: Socket, parsed: SemiParsedRequest, router:Router, origin: string) = 
    # Use parseParams to get fully parsed request
    let fullParsed = parsed.parseParams(rout);
    # Create request and response objects
    let request = Request(body: parsed.body, path: parsed.path, httpMethod: parsed.httpMethod, origin: origin, itemParams:fullParsed.itemParams, queryParams:fullParsed.queryParams);
    let response = Response(client: client, origin: origin, path: parsed.path, httpMethod: parsed.httpMethod);
    # Call the route's handler
    rout.handler(request, response);

proc filterRequest*(client: Socket, parsed: SemiParsedRequest, router:Router, origin: string) = 
    var match: bool = false;
    # Search for a match
    for rout in router.routes:
        let pathWithoutQueryParams = parsed.path.split("?")[0]
        # No-parameter match
        if rout.httpMethod == parsed.httpMethod and rout.path == pathWithoutQueryParams:
            # call
            rout.callRoute(client, parsed, router, origin)
            match=true;
            break;
        # Match including item params
        elif pathWithoutQueryParams.isTemplated(rout.path):
            # call
            rout.callRoute(client, parsed, router, origin)
            match=true;
            break;
            
    # Match not found, return a 404 error
    if not match:
        styledEcho(fgRed, parsed.httpMethod & " " & parsed.path & " " & origin & " 404 (Not Found)")
        client.send("HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: " & $len("Not Found") & "\r\n\r\nNot Found")
        let index = openedPorts.find(client)
        if index >= 0:
            delete(openedPorts, index)
        client.close()

proc close*(rout: var Router) = 
    styledEcho(fgBlue, "Closing server and cleaning")
    rout.running=false;
    for socket in openedPorts:
        socket.close()

# Create a gracefull server shutdown
proc onCtrlC() {.noconv.} =
    # Add your cleanup code here
    quit(0) # Exit the program gracefully

setControlCHook(onCtrlC)

proc start*(router: var Router, portNumber: int, verbose:bool=false) = 
    router.running = true;
    let socket = newSocket()
    try: 
        socket.bindAddr(Port(portNumber))
    except:
        styledEcho(fgRed, "Error in creating port. It may be already in use or the current user does not have rights to create ports.")
    socket.listen()
    openedPorts.add(socket)
    var client: Socket
    if verbose==true:
        styledEcho(fgBlue, "Started listening on port portN".replace("portN", $portNumber))

    while router.running:
        socket.accept(client)

        # Recieved request
        openedPorts.add(client)
        let clientAddress = client.getPeerAddr()
        let parsed: SemiParsedRequest = parseRequest(client)
        client.filterRequest(parsed, router, clientAddress[0])