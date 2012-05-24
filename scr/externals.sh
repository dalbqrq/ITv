#!/bin/bash
#
# externals[.sh,.lua] é o wrapper para que o glpi realize chamadas no itvision.
#

PROGDIR=$(dirname $(readlink -f $0))

. $PROGDIR/../bin/lua_path

export LUA_PATH=$LUA_PATH

lua $PROGDIR/externals.lua $1 $2 $3 # Admite no maximo 3 parametros. Pode ser aumentado.
