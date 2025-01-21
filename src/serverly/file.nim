import router, types, strutils, sequtils, contentTypes, response, tables, os, utils/path

var servedFileList: Table[string, ServedFile] = initTable[string, ServedFile]();

proc getFileContent*(filePath: string): string = 
    let entireFile = readFile(filePath)
    return entireFile

proc getFileType*(filePath: string): string = 
    let fileExt = filePath.split(".")[len(filePath.split("."))-1];
    if(contypeByExt.get(fileExt) != ""):
        return contypeByExt.get(fileExt)
    else:
        return contypeByExt.bin;

proc serveSingleFile*(rout: var Router, filePathIncompl: string, servedPathIncompl: string="/" & filePathIncompl.split("/")[len(filePathIncompl.split("/"))-1], removeExt: bool=true) = 
    let filePath: string = filePathIncompl.parsePath();
    var servedPath: string = servedPathIncompl;
    if removeExt:
        servedPath = servedPath.split(".")[0]
    let conType = filePath.getFileType()
    let content = filePath.getFileContent()
    let fl = ServedFile(filePath: filePath, fileType: conType, fileContent: content);
    servedFileList[servedPath] = fl;
    
    # Create route
    rout.get(servedPath, proc (req: Request, res: Response) = 
        let fil = servedFileList[req.path];
        res.send(fil.fileContent, 200, fil.fileType)
    )

proc serveDirectory*(rout: var Router, dirPathIncoml: string, servedPath: string="/" & dirPathIncoml.split("/")[len(dirPathIncoml.split("/"))-1], removeExt: bool=true) = 
    # Get everything in directory
    let dirPath: string = dirPathIncoml.parsePath()
    let filesInDir = toSeq(walkDir(dirPath, relative=true));
    for item in filesInDir:
        if item.kind == pcFile:
            rout.serveSingleFile(dirPath & "/" & item.path, servedPath & "/" & item.path, removeExt)
        elif item.kind == pcDir:
            rout.serveDirectory(dirPath & "/" & item.path, servedPath & "/" & item.path, removeExt)