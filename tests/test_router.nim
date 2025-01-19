import serverly
import unittest

var rout: Router;
test "Init router":
  rout = initRouter();

test "GET request":
  rout.get("/get", proc(req: Request, res: Response) = 
    discard
  )

test "POST request":
  rout.post("/post", proc(req: Request, res: Response) = 
    discard req.body
  )

test "Item parameters":
  rout.get("/itemParams/:param", proc (req: Request, res: Response) = 
    discard req.itemParams.get("param")
  )

test "Query parameters":
  rout.get("/queryParams", proc (req: Request, res: Response) = 
    discard req.queryParams.get("a")
  )