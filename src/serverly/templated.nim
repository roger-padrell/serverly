import strutils

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