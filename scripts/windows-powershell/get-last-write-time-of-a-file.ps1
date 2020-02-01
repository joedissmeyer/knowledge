# Gets the datetime of the last write time of a folder.

﻿Get-ChildItem "\\myserverhostname\E$" | WHERE {$_.LastWriteTime -gt (Get-Date).AddMinutes(-30)} | SELECT LastWriteTime
