# Hello world in `serverly` (nim)
## Description
This is the simplest example of serverly: an HTTP server that returns `Hello World`.

This template introduces to:
- Importing serverly
- Initiating the router
- Using a GET request
- Sending a response
- Starting the server

## Code
```
import serverly #Import the module

var rout: Router = initRouter(); # Init the router

rout.get("/", proc(req: Request, res: Response) = # Initiate a GET request
    res.send("Hello World") # Send a response
) # Close the GET request function

rout.start(8080) # Start the router at port 8080 (localhost:8080)
```

## Explanation
`import serverly`: Import the serverly module to be able to use it's functions.

`var rout: Router = initRouter();`: Instantiate the route with `initRouter`. The `var` keyword is important, because it let's us add routes to it. The semicolor (`;`) is optional. The name used here `rout` is recommended, but not necessary to be the same.

`rout.get("/", proc(req: Request, res: Response)`: Initiate a GET route at the path `/`, and create it's handler function with two parameters: 
- `req`: to acces request data like headers and origin
- `res`: to responde to the request

`   res.send("Hello World")`: Respond to the request with `Hello World` (mind the tab before the function in the [code](#code) part).

`)`: Close the request creation function to prevent errors.

`rout.start(8080)`: Start the router at port 8080. You can now enter `localhost:8080` on a browser (in the same computer) and get `Hello World`.