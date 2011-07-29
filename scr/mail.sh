#!/bin/bash

PROGDIR=$(dirname $(readlink -f $0))

. $PROGDIR/../bin/lua_path

export LUA_PATH=$LUA_PATH

lua $PROGDIR/mail.lua $1 # parametro deve ser o id de uma aplicacao válida
