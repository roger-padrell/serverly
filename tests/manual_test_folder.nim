import serverly, unittest, strutils

const port: int = 8080

var rout: Router = initRouter()

rout.serveDirectory("./fileTests")

echo "Go to localhost:" & $port & "/fileTests/file or localhost:" & $port & "/fileTests/html to check if this worked."
echo "Also go to localhost:" & $port & "/fileTests/subfolder/subfile to check if subfolder accessing is available."

rout.start(port)