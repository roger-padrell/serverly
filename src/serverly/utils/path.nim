import os, strutils

proc parsePath*(path: string): string = 
    var outputPath: string = path;
    
    # Replace "./" to file directory
    let fileDir = parentDir(getAppFilename())
    outputPath = outputPath.replace("./",fileDir&"/")

    # Replace "$/" to running directory
    let currentDir = getCurrentDir();
    outputPath = outputPath.replace("$/",currentDir & "/")

    # Return
    return outputPath;