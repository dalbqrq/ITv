#!/bin/bash

PROGDIR=$(dirname $(readlink -f $0))

. $PROGDIR/../bin/lua_path

export LUA_PATH=$LUA_PATH

lua $PROGDIR/remake_apps.lua
