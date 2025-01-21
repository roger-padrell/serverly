import serverly, unittest, strutils

const port: int = 8080

var rout: Router = initRouter()

rout.serveSingleFile("./fileTests/text.txt")
rout.serveSingleFile("./fileTests/html.html")

echo "Go to localhost:" & $port & "/text or localhost:" & $port & "/html to check if this worked."

rout.start(port)