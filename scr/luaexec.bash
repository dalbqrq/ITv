#!/bin/bash

PROGDIR=$(dirname $(readlink -f $0))
SCRIPT=$(basename $(readlink -f $0))

. $PROGDIR/../bin/lua_path

export LUA_PATH=$LUA_PATH

echo $PROGDIR
lua $PROGDIR/update_entity.lua
