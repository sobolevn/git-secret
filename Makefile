all: myscript

myscript: includes/* body/*
    cat $^ > "$@" || (rm -f "$@"; exit 1)