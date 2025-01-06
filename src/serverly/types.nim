import net, tables

type
    Response* = object
        client*: Socket
        origin*: string
        httpMethod*: string
        path*: string

    ItemParams* = Table[string, string]
    
    Request* = object
        body*: string
        path*: string
        httpMethod*: string
        origin*: string
        itemParams*: ItemParams

    RouteHandler* = proc(req: Request, res: Response)

    Route* = object
        httpMethod*: string
        path*: string
        handler*: RouteHandler

    Router* = object
        routes*: seq[Route]

    SemiParsedRequest* = object
        httpMethod*: string
        path*: string
        body*: string
        raw*: string
    ParsedRequest* = object
        httpMethod*: string
        path*: string
        body*: string
        raw*: string
        itemParams*: Table[string, string]