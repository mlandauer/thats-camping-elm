-- Find out whether the current app is running "standalone"


module Standalone exposing (standalone)

import Task exposing (Task)
import Native.Standalone


standalone : Task x Bool
standalone =
    Native.Standalone.standalone
