#!/usr/bin/env bash


function whoknows {
  _user_required

  local keys=$(_get_users_in_keyring)
  echo "$keys"
}
