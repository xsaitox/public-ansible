#!/bin/ksh

#BASE=$HOME/hmcScanner
BASE=$(dirname $0)
PATH=/usr/java6_64/bin:/usr/java6_64/jre/bin:/usr/java6/bin:/usr/java6/jre/bin:$PATH

java -Xmx1024m -Duser.language=en -cp $BASE/jsch-0.1.55.jar:$BASE/hmcScanner.jar:$BASE/jxl.jar hmcScanner.Loader $*
