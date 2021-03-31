# Coleta Fortaleza iOS
### iOS Application for garbage collection in Fortaleza city.

![Bitrise](https://img.shields.io/bitrise/611d80c3e4426016/develop?token=NLTcVrzsempHwsc2iyNriw)

## Features

- Display and notify notification schedule for each neighborhood.
- Display map with categorized collection points in the City.
- Report rubbish in public spaces.
- Opt in for notification with tips for proper garbage disposal.

## How to run

First, you should run `pod install` in the project's root folder.

The App uses two Xcode configuration (.xcconfig) files to store API keys and urls, one for Development and one for Production. The actual files are not commited to github, which means you have to come up with your own.
The following is a template of configuration file:

```
#include "Pods/Target Support Files/Pods-garbageCollection/Pods-garbageCollection.debug.xcconfig"
#include "Pods/Target Support Files/Pods-garbageCollection/Pods-garbageCollection.adhoc.xcconfig"

// App's display name
APP_NAME = Coleta β

PARSE_APP_ID = <APP ID/API KEY>
PARSE_SERVER_URL = <URL TO PARSE SERVER>

SERVER_BASE_URL = <API BASE URL>
```

