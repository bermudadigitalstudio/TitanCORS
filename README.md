# TitanCORS

Helper functions to add CORS support to Titan apps.

## I don't know what CORS is and I don't care about security

```swift
let titanInstance = Titan()
TitanCORS.addCORSSupport(titanInstance)
```

## I know what CORS is and I'm not letting you mess with my app

Okay.

```swift
titanInstance.addFunction(AllowAllOrigins) // Add wildcard origin header to all responses
titanInstance.addFunction(RespondToPreflight) // Respond to a CORS preflight option request allowing all methods
```

## I know what CORS is and I want to customize it

Please open a PR! We need these methods, and they shouldn't be hard to implement:

```swift
func AllowSomeOrigins(_ origins: [String]) -> Function
func RespondToPreflight(allowingSpecificMethods methods: [String]) -> Function
```