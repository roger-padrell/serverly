import serverly

var rout: Router = initRouter();

rout.get("/", proc(req: Request, res: Response) = 
  res.send("Hello")
)

rout.get("/hello/:name/:sname", proc (req: Request, res: Response) = 
  res.send("Hello " & req.itemParams.get("name") & " " & req.itemParams.get("sname"))
)

rout.start(8080)