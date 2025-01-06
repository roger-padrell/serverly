# Serverly documentation
This documentation is made of examples on how to use Serverly.

## Table of contents
- [Router](#router)
- [Methods](#methods)
    - [GET](#get)
    - [POST](#post)
    - [PUT](#put)
    - [Other methods](#other-methods)
- [Params](#params)
    - [Item Params](#item-params)
    - [URL Params](#url-params)

## Router
The router is the core of your server. It's used to define the different entries where requests can be sent.

At the start of a server file, you should always import serverly and create a router, where you will be adding the ports and connections. The router should always be variable, because you change it's ports every time you add a request.

After initializing the router, you add the server code, and then you start/run the router with `Router.start`
```
import serverly

var rout: Router = initRouter()

# ...server code

rout.start(8000) # Start at port 8000
```


## Methods
These are the methods available with serverly

### GET
To use a get method, you just have to run `Router.get`.
```
# ...Import serverly and initialize the Router

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello world")
)

# ... Start the router
```
Now, if you send a GET request to localhost:8000 you will get `Hello world` as a response.

### POST
To use a post method, you just have to run `Router.post`.
In post requests, there is usually a body, which you can acces with `req.body.text()` or `req.body.json()` depending on the type of data you're expecting.
```
# ...Import serverly and initialize the Router

rout.post("/", proc(req: Request, res: Response) = 
  res.send("Recieved: " & req.body.text())
)

# ... Start the router
```
Now, if you send a POST request to localhost:8000 with the body `something` you will get `Recieved: something` as a response.

### PUT
To use a put method, you just have to run `Router.put`.
In put requests, there is usually a body, wich you can acces with `req.body.text()` or `req.body.json()` depending on the type of data you're expecting.
```
# ...Import serverly and initialize the Router

rout.put("/", proc(req: Request, res: Response) = 
  res.send("Recieved: " & req.body.text())
)

# ...Import serverly and initialize the Router
```
Now, if you send a PUT request to localhost:8000 with the body `something` you will get `Recieved: something` as a response.

### Other methods
You can also use `Router.head` and `Router.options` in the same way as previous methods, and I'll be adding more in the future.

## Params
There are two types of params:
- Item params (`/id/1000`)
- URL params (`app?id=1000`)

You can use them as follows

### Item params
As previously stated, item params are the ones that get included in the path as if they where part of the route.
To define item params in the path, use `:paramName`
To acces item params you can use `Request.itemParams.get`
```
# ...Import serverly and initialize the Router

rout.get("/item/:id", proc(req: Request, res: Response) = 
  res.send("Item ID: " & req.itemParams.get("id"))
)

# ...Import serverly and initialize the Router
```

### URL params
These are not implemented yet, but are expected to come in the following Serverly version.