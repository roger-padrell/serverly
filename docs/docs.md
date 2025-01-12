# `Serverly` documentation
This documentation is made of examples on how to use `serverly`.

## Table of contents
- [Router](#router)
- [Methods](#methods)
    - [GET](#get)
    - [POST](#post)
    - [PUT](#put)
    - [DELETE](#delete)
    - [Other methods](#other-methods)
- [Parameters](#parameters)
    - [Item Parameters](#item-parameters)
    - [Query Parameters](#query-parameters)
- [Documentation generator](#docs)
- [Constants](#constants)
    - [Status codes and messages](#status-codes-and-messages)
    - [Content type](#content-type)

## Router
The router is the core of your server. It's used to define the different entries where requests can be sent.

At the start of a server file, you should always import `serverly` and create a router, where you will be adding the ports and connections. The router should always be variable, because you change it's ports every time you add a request.

After initializing the router, you add the server code, and then you start/run the router with `Router.start`
```
import serverly

var rout: Router = initRouter()

# ...server code

rout.start(8000) # Start at port 8000
```


## Methods
These are the methods available with `serverly`:

### GET
To use a get method, you just have to run `Router.get`.
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world")
)

# ... Start the router
```
Now, if you send a `GET` request to `localhost:8000` you will get `Hello world` as a response.

### POST
To use a post method, you just have to run `Router.post`.
In post requests, there's usually a body, which you can access with `req.body.text()` or `req.body.json()` depending on the type of data you're expecting.
```
# ...Import serverly and initialize the Router

rout.post("/", proc(req: Request, res: Response) = 
  res.send("Recieved: " & req.body.text())
)

# ... Start the router
```
Now, if you send a `POST` request to `localhost:8000` with the body `something` you will get `Recieved: something` as a response.

### PUT
To use a put method, you just have to run `Router.put`.
In put requests, there's usually a body, which you can access with `req.body.text()` or `req.body.json()` depending on the type of data you're expecting.
```
# ...Import serverly and initialize the Router

rout.put("/", proc(req: Request, res: Response) = 
  res.send("Recieved: " & req.body.text())
)

# ...Import serverly and initialize the Router
```
Now, if you send a `PUT` request to `localhost:8000` with the body `something` you will get `Recieved: something` as a response.

### DELETE
To use a delete method, you just have to run `Router.delete`.
In delete requests, there's usually a body, which you can access with `req.body.text()` or `req.body.json()` depending on the type of data you're expecting.
```
# ...Import serverly and initialize the Router

rout.delete("/", proc(req: Request, res: Response) = 
  res.send("Recieved: " & req.body.text())
)

# ...Import serverly and initialize the Router
```
Now, if you send a `DELETE` request to `localhost:8000` with the body `something` you will get `Recieved: something` as a response.

### Other methods
You can also use `Router.head` and `Router.options` in the same way as previous methods, and I'll be adding more in the future.

## Parameters
There are two types of parameters:
- Item parameters (`/id/1000`)
- Query parameters (`app?id=1000`)

You can use them as follows

### Item parameters
As previously stated, item parameters are the ones that get included in the path as if they where part of the route.
To define item parameters in the path, use `:paramName`
To access item parameters you can use `Request.itemParams.get`
```
# ...Import serverly and initialize the Router

rout.get("/item/:id", proc(req: Request, res: Response) = 
  res.send("Item ID: " & req.itemParams.get("id"))
)

# ...Import serverly and initialize the Router
```

### Query parameters
As previously stated, query parameters are the ones that follow the path and don't affect it (the server will serve the same route to `/app` and `/app?a=10`), but these can also be accessed by the server.
Query parameters do not need to be previously defined, unlike item parameters.
You can access query parameters with `Request.queryParams.get`
```
# ...Import serverly and initialize the Router

rout.get("/item/", proc(req: Request, res: Response) = 
  res.send("Item ID: " & req.queryParams.get("id"))
)

# ...Import serverly and initialize the Router
```
Now, if the a request is send at `/item?id=10` it will return: `Item ID: 10`
Keep in mind that if a request is send without the id parameter, it will be accepted, but checking the id query parameter will give an error. This makes item parameters more secure for required parameters and query parameters better for optional ones.

## Docs
The documentation generator (docs) is very easy to use.
You just use `Router.docs`.
```
# ...Import serverly and initialize the Router
# ... Add some requests

rout.docs()

# ...Import serverly and initialize the Router
```

The default path for docs is `/docs`, but you can change it with `Router.docs("/custom_path")`

Also, when adding a request, you can set it's description so it will appear at the documentation like this:
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world")
, description="Send a request to get 'Hello world'!"
)

rout.docs()
# ... Start the router
```

## Constants
### Status codes and messages
When responding to an HTTP request with `Response.send` (or `res.send`), you can customize the sent status code along with the status message in the following way:
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world", statusCode=200) # 200 is the status code for OK
)

# ... Start the router
```
As you have seen, you can manually type the code number and it will automatically fill the `statusText` parameter with the message specified by the code (`OK` in case of `200` status code).
You can customize the `statusText` too: 
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world", statusText="A cool status text")
)

# ... Start the router
```
But there's an easier way to do it, using the already implemented library of status codes and messages, `statusCode`:
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world", statusCode=status.OK) # The 200 status code
)

# ... Start the router
```
Here, you can see all the implemented codes and messages, all from the HTTP official status codes and messages.

| Variable Name           | Status Code | Status Text                  |
|-------------------------|-------------|------------------------------|
| `Continue`             | 100         | Continue                     |
| `SwitchingProtocols`   | 101         | Switching Protocols          |
| `Processing`           | 102         | Processing                   |
| `EarlyHints`           | 103         | Early Hints                  |
| `OK`                   | 200         | OK                           |
| `Created`              | 201         | Created                      |
| `Accepted`             | 202         | Accepted                     |
| `NonAuthoritativeInfo` | 203         | Non-Authoritative Information|
| `NoContent`            | 204         | No Content                   |
| `ResetContent`         | 205         | Reset Content                |
| `PartialContent`       | 206         | Partial Content              |
| `MultiStatus`          | 207         | Multi-Status                 |
| `AlreadyReported`      | 208         | Already Reported             |
| `IMUsed`               | 226         | IM Used                      |
| `MultipleChoices`      | 300         | Multiple Choices             |
| `MovedPermanently`     | 301         | Moved Permanently            |
| `Found`                | 302         | Found                        |
| `SeeOther`             | 303         | See Other                    |
| `NotModified`          | 304         | Not Modified                 |
| `UseProxy`             | 305         | Use Proxy                    |
| `TemporaryRedirect`    | 307         | Temporary Redirect           |
| `PermanentRedirect`    | 308         | Permanent Redirect           |
| `BadRequest`           | 400         | Bad Request                  |
| `Unauthorized`         | 401         | Unauthorized                 |
| `PaymentRequired`      | 402         | Payment Required             |
| `Forbidden`            | 403         | Forbidden                    |
| `NotFound`             | 404         | Not Found                    |
| `MethodNotAllowed`     | 405         | Method Not Allowed           |
| `NotAcceptable`        | 406         | Not Acceptable               |
| `ProxyAuthRequired`    | 407         | Proxy Authentication Required|
| `RequestTimeout`       | 408         | Request Timeout              |
| `Conflict`             | 409         | Conflict                     |
| `Gone`                 | 410         | Gone                         |
| `LengthRequired`       | 411         | Length Required              |
| `PreconditionFailed`   | 412         | Precondition Failed          |
| `PayloadTooLarge`      | 413         | Payload Too Large            |
| `URITooLong`           | 414         | URI Too Long                 |
| `UnsupportedMediaType` | 415         | Unsupported Media Type       |
| `RangeNotSatisfiable`  | 416         | Range Not Satisfiable        |
| `ExpectationFailed`    | 417         | Expectation Failed           |
| `ImATeapot`            | 418         | I'm a teapot                 |
| `MisdirectedRequest`   | 421         | Misdirected Request          |
| `UnprocessableEntity`  | 422         | Unprocessable Entity         |
| `Locked`               | 423         | Locked                       |
| `FailedDependency`     | 424         | Failed Dependency            |
| `TooEarly`             | 425         | Too Early                    |
| `UpgradeRequired`      | 426         | Upgrade Required             |
| `PreconditionRequired` | 428         | Precondition Required        |
| `TooManyRequests`      | 429         | Too Many Requests            |
| `HeaderFieldsTooLarge` | 431         | Request Header Fields Too Large |
| `LegalReasons`         | 451         | Unavailable For Legal Reasons |
| `InternalServerError`  | 500         | Internal Server Error        |
| `NotImplemented`       | 501         | Not Implemented              |
| `BadGateway`           | 502         | Bad Gateway                  |
| `ServiceUnavailable`   | 503         | Service Unavailable          |
| `GatewayTimeout`       | 504         | Gateway Timeout              |
| `HTTPVersionNotSupported` | 505     | HTTP Version Not Supported   |
| `VariantAlsoNegotiates`| 506         | Variant Also Negotiates      |
| `InsufficientStorage`  | 507         | Insufficient Storage         |
| `LoopDetected`         | 508         | Loop Detected                |
| `NotExtended`          | 510         | Not Extended                 |
| `NetworkAuthRequired`  | 511         | Network Authentication Required |

### Content type
When sending response to a request, you can also specify the type of the response sent (the default is text/plain). This is used, for example, in the [documentation generator](#docs), as it needs to send HTML code so the browser renders it.

You can set this manually:
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world", contentType="text/html") # Used so the browser understands it as HTML
)

# ... Start the router
```
You can also use the already implemented `contype` module:
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world", contentType=contype.html) # Is equal to "text/html"
)

# ... Start the router
```
Here you can see all implemented content-types:

| **Variable Name**      | **Content-Type Code**                 |
|-------------------------|---------------------------------------|
| `plainText`            | `text/plain`                         |
| `html`                 | `text/html`                          |
| `json`                 | `application/json`                   |
| `xml`                  | `application/xml`                    |
| `formUrlEncoded`       | `application/x-www-form-urlencoded`  |
| `multipartFormData`    | `multipart/form-data`                |
| `javascript`           | `application/javascript`             |
| `css`                  | `text/css`                           |
| `csv`                  | `text/csv`                           |
| `pdf`                  | `application/pdf`                    |
| `zip`                  | `application/zip`                    |
| `png`                  | `image/png`                          |
| `jpeg`                 | `image/jpeg`                         |
| `gif`                  | `image/gif`                          |
| `webp`                 | `image/webp`                         |
| `mp3`                  | `audio/mpeg`                         |
| `mp4`                  | `video/mp4`                          |
| `wav`                  | `audio/wav`                          |
| `ogg`                  | `audio/ogg`                          |
| `avi`                  | `video/x-msvideo`                    |
| `binary`               | `application/octet-stream`           |
