#!/bin/bash

PROGDIR=$(dirname $(readlink -f $0))

. $PROGDIR/../bin/lua_path

export LUA_PATH=$LUA_PATH

lua $PROGDIR/externals.lua $1 $2 $3 # Admite no maximo 3 parametros. Pode ser aumentado.
