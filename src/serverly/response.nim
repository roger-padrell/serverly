import net, strutils, terminal, types

proc send*(resp: Response, content: string, statusCode:int=200, statusText:string="OK") = 
    try: 
        let response = "HTTP/1.1 %STATUS-CODE% %STATUS-TEXT%\r\nContent-Type: text/plain\r\nContent-Length: %CONTENTLEN%\r\n\r\n%CONTENT%"
            .replace("%STATUS-CODE%",$statusCode)
            .replace("%STATUS-TEXT%", statusText)
            .replace("%CONTENTLEN%", $len(content))
            .replace("%CONTENT%", content)
        resp.client.send(response)
        resp.client.close()
        styledEcho(fgGreen, resp.httpMethod & " " & resp.path & " " & resp.origin & " " & $statusCode & " (" & statusText & ")")
    except:
        echo "Error when sending"