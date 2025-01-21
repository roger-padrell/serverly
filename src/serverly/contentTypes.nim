type
  ContentTypes = object
    plainText*: string
    html*: string
    json*: string
    xml*: string
    formUrlEncoded*: string
    multipartFormData*: string
    javascript*: string
    css*: string
    csv*: string
    pdf*: string
    zip*: string
    png*: string
    jpeg*: string
    gif*: string
    webp*: string
    mp3*: string
    mp4*: string
    wav*: string
    ogg*: string
    avi*: string
    binary*: string

let contype* = ContentTypes(
  plainText: "text/plain",
  html: "text/html",
  json: "application/json",
  xml: "application/xml",
  formUrlEncoded: "application/x-www-form-urlencoded",
  multipartFormData: "multipart/form-data",
  javascript: "application/javascript",
  css: "text/css",
  csv: "text/csv",
  pdf: "application/pdf",
  zip: "application/zip",
  png: "image/png",
  jpeg: "image/jpeg",
  gif: "image/gif",
  webp: "image/webp",
  mp3: "audio/mpeg",
  mp4: "video/mp4",
  wav: "audio/wav",
  ogg: "audio/ogg",
  avi: "video/x-msvideo",
  binary: "application/octet-stream"
)

type
  ContentTypesByExtension = object
    txt*: string
    html*: string
    json*: string
    xml*: string
    js*: string
    css*: string
    csv*: string
    pdf*: string
    zip*: string
    png*: string
    jpeg*: string
    gif*: string
    webp*: string
    mp3*: string
    mp4*: string
    wav*: string
    ogg*: string
    avi*: string
    bin*: string

let contypeByExt* = ContentTypesByExtension(
  txt: "text/plain",
  html: "text/html",
  json: "application/json",
  xml: "application/xml",
  js: "application/javascript",
  css: "text/css",
  csv: "text/csv",
  pdf: "application/pdf",
  zip: "application/zip",
  png: "image/png",
  jpeg: "image/jpeg",
  gif: "image/gif",
  webp: "image/webp",
  mp3: "audio/mpeg",
  mp4: "video/mp4",
  wav: "audio/wav",
  ogg: "audio/ogg",
  avi: "video/x-msvideo",
  bin: "application/octet-stream",
)

proc get*(obj: ContentTypesByExtension, propertyName: string): string =
  for key, value in fieldPairs(obj):
    if key == propertyName:
      return value
  return ""