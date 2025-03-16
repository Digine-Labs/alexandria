In every new cairo release. The repository has to be updated to that new cairo version with all tests passing. The new release must be under a new branch following the semantic release. In every new cairo version, the Alexandria version increases the same.

2.9.x -> 0.3.x
2.10.x -> 0.4.x
2.11.x -> 0.5.x

In the past, we only updated Alexandria for major versions. But we need to release for all versions(Not priority; let's discuss this). At least we have to be sure minor changes on cairo didn't affect the library.

## Refactor
- RLP Encoding & decoding using ByteArray
- Remove unused macros on macros and macros_test package.
  
## Features
- Extensions for ByteArray
- New macros


## Fixes
- Macros CI was raising fmt error. It was removed on last version. Make it work with latest alexandria (0.5.0 now)
- 
