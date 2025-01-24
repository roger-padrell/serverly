# Add A + B
## Description
This example creates a route where you can send two numbers (a, b) and get the sum of them.

It introduces:
- Item parameters

## Code
```
import serverly, strutils # Import modules (serverly for serving and strutils for converting string to int)

var rout: Router = initRouter(); # Init the router

rout.get("/add/:a/:b/", proc(req: Request, res: Response) = # Initiate a GET request
    let a = parseInt(req.itemParams.get("a")) # Get A from parameters
    let b = parseInt(req.itemParams.get("b")) # Get B from parameters
    let sum = a + b; # Add A and B
    res.send($sum) # Send a response
) # Close the GET request function

rout.start(8080) # Start the router at port 8080 (localhost:8080)
```

## Explanation
`import serverly`: Import modules (`serverly` for serving and `strutils` for converting string to int)

`var rout: Router = initRouter();`: Instantiate the route with `initRouter`. The `var` keyword is important, because it let's us add routes to it. The semicolor (`;`) is optional. The name used here `rout` is recommended, but not necessary to be the same.

`rout.get("/add/:a/:b/", proc(req: Request, res: Response)`: Initiate a GET route at the path `/add/:a/:b/`. The `/:a/:b/` is for definig to input params. If, when sending the request, they do not add this params, it will return 404. Then, create the handler function with two parameters: 
- `req`: to acces request data like headers and origin
- `res`: to responde to the request

`let a = parseInt(req.itemParams.get("a"))`: Get A from parameters using `req.itemParams.get`. This always returns a string (if the param does not exist it returns a blank string), that`s why we're using `parseInt` to convert it to a number that we can add to another.

`let b = parseInt(req.itemParams.get("b"))`: Get B from parameters using `req.itemParams.get`. This always returns a string (if the param does not exist it returns a blank string), that`s why we're using `parseInt` to convert it to a number that we can add to another.

`let sum = a + b;`: Add the two numbers using the `+` operator.

`   res.send($sum)`: Respond to the request with the sum of the two numbers (mind the  dollar sign `$` before `sum`, as it converts sum to a string and we always need to respond with strings).

`)`: Close the request creation function to prevent errors.

`rout.start(8080)`: Start the router at port 8080. You can now enter `localhost:8080/add/3/5` on a browser (in the same computer) and get `8`.