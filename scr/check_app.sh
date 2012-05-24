#!/bin/bash
#
# check_app.sh é o check_command utilizado pelo nagios para verificar o status de uma aplicacao.
#

PROGDIR=$(dirname $(readlink -f $0))

. $PROGDIR/../bin/lua_path

export LUA_PATH=$LUA_PATH

lua $PROGDIR/check_app.lua $1 $2
