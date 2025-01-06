import net, strutils
import tables, templated, types
from std/sequtils import zip

proc parseParams*(parsed: SemiParsedRequest, rout: Route): ParsedRequest = 
    # Item Params
    # It does not have item params or format is incorrect
    if not parsed.path.isTemplated(rout.path):
        let tb = initTable[string,string]()
        # Return
        return ParsedRequest(httpMethod: parsed.httpMethod, path: parsed.path, body: parsed.body, raw: parsed.raw, itemParams: tb)

    # Start formatting strings
    let strSplit = formatString(parsed.path).split("/");
    let templSplit = formatString(rout.path).split("/")
    # Remove all non-params in both lists
    var mutStr = strSplit;
    var mutTempl = templSplit;
    mutStr.delete(0)
    for t in templSplit:
        if not t.startsWith(":"):
            mutTempl.delete(mutTempl.find(t))

    # Create table and fill it with pairs
    var tb = initTable[string,string]()
    for pairs in zip(mutTempl, mutStr):
        let (mutTempl, mutStr) = pairs
        tb[mutTempl.replace(":","")] = mutStr

    # Return
    return ParsedRequest(httpMethod: parsed.httpMethod, path: parsed.path, body: parsed.body, raw: parsed.raw, itemParams: tb)

proc get*(params: ItemParams, key: string): string = 
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
        echo "Error handling request"