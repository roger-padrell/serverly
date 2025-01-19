import net, tables

type
    Response* = object
        client*: Socket
        origin*: string
        httpMethod*: string
        path*: string

    Params* = Table[string, string]

    
    Request* = object
        body*: string
        path*: string
        httpMethod*: string
        origin*: string
        itemParams*: Params
        queryParams*: Params

    RouteHandler* = proc(req: Request, res: Response)

    Route* = object
        httpMethod*: string
        path*: string
        handler*: RouteHandler
        description*:string

    Router* = object
        routes*: seq[Route]
        running*: bool

    SemiParsedRequest* = object
        httpMethod*: string
        path*: string
        body*: string
        raw*: string
        headers*: Table[string,string]
    ParsedRequest* = object
        httpMethod*: string
        path*: string
        body*: string
        raw*: string
        itemParams*: Table[string, string]
        queryParams*: Table[string, string]
        headers*: Table[string, string]