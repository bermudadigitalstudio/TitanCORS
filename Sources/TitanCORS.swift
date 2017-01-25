import TitanCore

/// Allow this app to be accessed with total violation of Same Origin Policy.
/// This adds the `AllowAllOrigins` and `RespondToPreflightAllowingAllMethods` functions.
public func addInsecureCORSSupport(_ titan: Titan) {
  titan.addFunction(RespondToPreflightAllowingAllMethods)
  titan.addFunction(AllowAllOrigins)
}

/// A header that allows all origins. You probably want to use the `AllowAllOrigins` Function instead
public let AllowAllOriginsHeader: Header = ("access-control-allow-origin", "*")

/// If one isn't present, insert a wildcard CORS allowed origin header
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

/// Respond to a CORS preflight request, allowing all methods requested in the preflight.
public let RespondToPreflightAllowingAllMethods: Function = { req, res in
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
  var headers: [Header] = []
  headers.append(("access-control-allow-methods", requestedMethods))
  if let requestedHeaders = (req.headers.first(where: { (key, _) -> Bool in
    return key.lowercased() == "access-control-request-headers"
  }).map { (header: Header) -> String in
    return header.1
  }) {
    headers.append(("access-control-allow-headers", requestedHeaders))
  } else {
    headers.append(("access-control-allow-headers", "*"))
  }
  return (req, Response(200, "", headers: headers))
}
