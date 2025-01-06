import json, types

proc text*(body: string): string = 
    return(body)

proc json*(body: string): JsonNode = 
    parseJson(body.text())

proc body*(req: Request): string = 
    return(req.body)