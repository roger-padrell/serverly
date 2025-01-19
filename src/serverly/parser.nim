import net, strutils
import tables, params, types, terminal

proc parseParams*(parsed: SemiParsedRequest, rout: Route): ParsedRequest = 
    # Item params
    # Use params.getParamsFromString
    var itemParams = parsed.path.split("?")[0].getParamsFromString(rout.path)

    # Query params
    # Use params.getQueryParams
    var queryParams: Table[string,string]
    if len(parsed.path.split("?")) > 1:
        queryParams = parsed.path.split("?")[1].getQueryParams()
    else: 
        queryParams = initTable[string,string]()

    # Return
    return ParsedRequest(httpMethod: parsed.httpMethod, path: parsed.path, body: parsed.body, raw: parsed.raw, itemParams: itemParams, queryParams: queryParams)

proc get*(params: Params, key: string): string = 
    return params.getOrDefault(key);

proc parseRequest*(client: Socket): SemiParsedRequest = 
    var requestSeq: seq[string] = @[]
    var line = ""

    try:
        # Read the first line (method, path, version)
        client.readLine(line)
        requestSeq.add(line)  # First line

        # Get data
        while true:
            var line = ""
            client.readLine(line)
            if len("l line".replace("line",line))==4:
                break  # Blank line marks the end of headers
            requestSeq.add("\r\n" & line)  # Add headers

        # Parse Content-Length header
        var contentLength = 0
        for header in requestSeq:
            if "Content-Length:" in header:
                contentLength = parseInt(header.split(":")[1].strip())
                break
        
        var body = ""
        if contentLength > 0:
            body = client.recv(contentLength)  # Read the exact number of bytes

        # Get data from fist line
        let splitted = split(requestSeq[0], " ");
        


        # return
        
        let recivedReq = SemiParsedRequest(httpMethod:splitted[0], path:splitted[1], body:body, raw: $requestSeq)
        return(recivedReq)
    except:
        styledEcho(fgRed, "Error handling request")