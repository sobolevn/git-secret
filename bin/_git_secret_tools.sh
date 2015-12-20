#!/bin/bash

function _function_exists {
  declare -f -F $1 > /dev/null
  echo $?
}
