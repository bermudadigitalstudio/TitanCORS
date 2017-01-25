import TitanCore

public let AllowAllOriginsHeader: Header = ("access-control-allow-origin", "*")
public let AllowAllOrigins: Function = { req, res in
  var respHeaders = res.headers
  guard (respHeaders.contains { header in
    return header.0.lowercased() == "access-control-allow-origin"
    } != true) else {
      return (req, res)
  }
  respHeaders.append(AllowAllOriginsHeader)
  return (req, Response(res.code, res.body, headers: respHeaders))
}

public let ApprovedPreflightHeaders = [
  ("access-control-allow-headers", "*"),
  ("access-control-allow-method", "*"),
]

public let RespondToPreflight: Function = { req, res in
  guard req.method.uppercased() == "OPTIONS" else {
    return (req, res)
  }
  guard let requestedMethods = (req.headers.first(where: { (key, _) -> Bool in
    return key.lowercased() == "access-control-request-method"
  }).map { (header: Header) -> String in
    return header.1
  }) else {
    return (req, res)
  }
  var headers = ApprovedPreflightHeaders
  headers.append(("access-control-allow-methods", requestedMethods))
  if let requestedHeaders = (req.headers.first(where: { (key, _) -> Bool in
    return key.lowercased() == "access-control-request-headers"
  }).map { (header: Header) -> String in
    return header.1
  }) {
    headers.append(("access-control-allow-headers", requestedHeaders))
  }
  return (req, Response(200, "", headers: headers))
}
