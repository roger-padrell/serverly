import strutils
import tables, strutils
from std/sequtils import zip

proc formatString*(input: string): string =
  var res = input
  # Remove first character if it's a slash
  if res.len > 0 and res[0] == '/':
    res = res[1..^1]
  # Remove last character if it's a slash
  if res.len > 0 and res[^1] == '/':
    res = res[0..^2]
  return res

proc isTemplated*(str: string, templ: string): bool =
  var isTemplatedBool: bool = true;
  if not (":" in templ): 
    isTemplatedBool=false;

  let strSplit = formatString(str).split("/");
  let templSplit = formatString(templ).split("/")

  var mutStr = strSplit;
  var mutTempl = templSplit;
  # Remove first item
  mutStr.delete(0)

  # Remove all items that do not start with :
  for t in templSplit:
    if not t.startsWith(":"):
      mutTempl.delete(mutTempl.find(t))

  if len(strSplit) != len(templSplit):
    isTemplatedBool = false;
  elif len(mutStr) != len(mutTempl):
    isTemplatedBool = false;

  return isTemplatedBool

proc getParamsFromString*(path: string, templ: string): Table[string, string] = 
    if not path.isTemplated(templ):
        return initTable[string,string]()

     # Start formatting strings
    let strSplit = formatString(path).split("/");
    let templSplit = formatString(templ).split("/")
    # Remove all non-params in both lists
    var mutStr = strSplit;
    var mutTempl = templSplit;
    mutStr.delete(0)
    for t in templSplit:
        if not t.startsWith(":"):
            mutTempl.delete(mutTempl.find(t))

    # Create table and fill it with pairs
    var tb = initTable[string,string]()
    for pairs in zip(mutTempl, mutStr):
        let (mutTempl, mutStr) = pairs
        tb[mutTempl.replace(":","")] = mutStr

    return tb

proc getQueryParams*(path: string): Table[string,string] = 
  # Stop if the URL does not contain params
  if len(path) == 0:
    return initTable[string, string]()
  
  # Split param pairs separed by '&' (as ?a=some&b=other)
  var paramSeq = path.split("&")

  # Create table
  var tb = initTable[string, string]()

  # Loop over params in paramSeq
  for p in paramSeq:
    # Split variable-value by '=' and add it to table
    tb[p.split("=")[0]] = p.split("=")[1]

  return tb