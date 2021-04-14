@echo off

set BASE=%~dp0

java -Duser.language=en -cp "%BASE%\jsch-0.1.55.jar";"%BASE%\hmcScanner.jar";"%BASE%\jxl.jar" hmcScanner.Loader %*
