import serverly

var rout: Router = initRouter();

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello")
)

rout.get("/hello/:name/:sname", proc (req: Request, res: Response) = 
  res.send("Hello " & req.itemParams.get("name") & " " & req.itemParams.get("sname"))
)

rout.get("/qparams", proc (req: Request, res: Response) = 
  res.send("Recieved a is equal to: " & req.queryParams.get("a"), statusCode=status.OK)
, description="Hello"
)

rout.docs()

rout.start(8000)