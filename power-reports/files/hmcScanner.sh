#!/bin/sh

#BASE=$HOME/hmcScanner
BASE=$(dirname $0)
PATH=/opt/jre8/bin:$PATH

java -Xmx1024m -Duser.language=en -cp $BASE/jsch-0.1.55.jar:$BASE/hmcScanner.jar:$BASE/jxl.jar hmcScanner.Loader $*
