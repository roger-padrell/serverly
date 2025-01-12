import tables

type
  HttpStatus* = object
    Continue*: int
    SwitchingProtocols*: int
    Processing*: int
    EarlyHints*: int
    OK*: int
    Created*: int
    Accepted*: int
    NonAuthoritativeInfo*: int
    NoContent*: int
    ResetContent*: int
    PartialContent*: int
    MultiStatus*: int
    AlreadyReported*: int
    IMUsed*: int
    MultipleChoices*: int
    MovedPermanently*: int
    Found*: int
    SeeOther*: int
    NotModified*: int
    UseProxy*: int
    TemporaryRedirect*: int
    PermanentRedirect*: int
    BadRequest*: int
    Unauthorized*: int
    PaymentRequired*: int
    Forbidden*: int
    NotFound*: int
    MethodNotAllowed*: int
    NotAcceptable*: int
    ProxyAuthRequired*: int
    RequestTimeout*: int
    Conflict*: int
    Gone*: int
    LengthRequired*: int
    PreconditionFailed*: int
    PayloadTooLarge*: int
    URITooLong*: int
    UnsupportedMediaType*: int
    RangeNotSatisfiable*: int
    ExpectationFailed*: int
    ImATeapot*: int
    MisdirectedRequest*: int
    UnprocessableEntity*: int
    Locked*: int
    FailedDependency*: int
    TooEarly*: int
    UpgradeRequired*: int
    PreconditionRequired*: int
    TooManyRequests*: int
    HeaderFieldsTooLarge*: int
    LegalReasons*: int
    InternalServerError*: int
    NotImplemented*: int
    BadGateway*: int
    ServiceUnavailable*: int
    GatewayTimeout*: int
    HTTPVersionNotSupported*: int
    VariantAlsoNegotiates*: int
    InsufficientStorage*: int
    LoopDetected*: int
    NotExtended*: int
    NetworkAuthRequired*: int

var status* = HttpStatus(
  Continue: 100,
  SwitchingProtocols: 101,
  Processing: 102,
  EarlyHints: 103,
  OK: 200,
  Created: 201,
  Accepted: 202,
  NonAuthoritativeInfo: 203,
  NoContent: 204,
  ResetContent: 205,
  PartialContent: 206,
  MultiStatus: 207,
  AlreadyReported: 208,
  IMUsed: 226,
  MultipleChoices: 300,
  MovedPermanently: 301,
  Found: 302,
  SeeOther: 303,
  NotModified: 304,
  UseProxy: 305,
  TemporaryRedirect: 307,
  PermanentRedirect: 308,
  BadRequest: 400,
  Unauthorized: 401,
  PaymentRequired: 402,
  Forbidden: 403,
  NotFound: 404,
  MethodNotAllowed: 405,
  NotAcceptable: 406,
  ProxyAuthRequired: 407,
  RequestTimeout: 408,
  Conflict: 409,
  Gone: 410,
  LengthRequired: 411,
  PreconditionFailed: 412,
  PayloadTooLarge: 413,
  URITooLong: 414,
  UnsupportedMediaType: 415,
  RangeNotSatisfiable: 416,
  ExpectationFailed: 417,
  ImATeapot: 418,
  MisdirectedRequest: 421,
  UnprocessableEntity: 422,
  Locked: 423,
  FailedDependency: 424,
  TooEarly: 425,
  UpgradeRequired: 426,
  PreconditionRequired: 428,
  TooManyRequests: 429,
  HeaderFieldsTooLarge: 431,
  LegalReasons: 451,
  InternalServerError: 500,
  NotImplemented: 501,
  BadGateway: 502,
  ServiceUnavailable: 503,
  GatewayTimeout: 504,
  HTTPVersionNotSupported: 505,
  VariantAlsoNegotiates: 506,
  InsufficientStorage: 507,
  LoopDetected: 508,
  NotExtended: 510,
  NetworkAuthRequired: 511
)

var statusMessage*: Table[int,string] = {
  100: "Continue",
  101: "Switching Protocols",
  102: "Processing",
  103: "Early Hints",
  200: "OK",
  201: "Created",
  202: "Accepted",
  203: "Non-Authoritative Information",
  204: "No Content",
  205: "Reset Content",
  206: "Partial Content",
  207: "Multi-Status",
  208: "Already Reported",
  226: "IM Used",
  300: "Multiple Choices",
  301: "Moved Permanently",
  302: "Found",
  303: "See Other",
  304: "Not Modified",
  305: "Use Proxy",
  307: "Temporary Redirect",
  308: "Permanent Redirect",
  400: "Bad Request",
  401: "Unauthorized",
  402: "Payment Required",
  403: "Forbidden",
  404: "Not Found",
  405: "Method Not Allowed",
  406: "Not Acceptable",
  407: "Proxy Authentication Required",
  408: "Request Timeout",
  409: "Conflict",
  410: "Gone",
  411: "Length Required",
  412: "Precondition Failed",
  413: "Payload Too Large",
  414: "URI Too Long",
  415: "Unsupported Media Type",
  416: "Range Not Satisfiable",
  417: "Expectation Failed",
  418: "I'm a teapot",
  421: "Misdirected Request",
  422: "Unprocessable Entity",
  423: "Locked",
  424: "Failed Dependency",
  425: "Too Early",
  426: "Upgrade Required",
  428: "Precondition Required",
  429: "Too Many Requests",
  431: "Request Header Fields Too Large",
  451: "Unavailable For Legal Reasons",
  500: "Internal Server Error",
  501: "Not Implemented",
  502: "Bad Gateway",
  503: "Service Unavailable",
  504: "Gateway Timeout",
  505: "HTTP Version Not Supported",
  506: "Variant Also Negotiates",
  507: "Insufficient Storage",
  508: "Loop Detected",
  510: "Not Extended",
  511: "Network Authentication Required"
}.toTable

proc get*(table: Table[int, string],status: int): string = 
  return statusMessage[status]