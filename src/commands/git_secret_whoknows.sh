#!/usr/bin/env bash


function whoknows {
  OPTIND=1

  local long_display=0
  while getopts "hl?" opt; do
    case "$opt" in
      h) _show_manual_for "whoknows";;

      l) long_display=1;;   # like ls -l

      *) _invalid_option_for "whoknows";;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = "--" ] && shift

  # Validating, that we have a user:
  _user_required

  local users
  local group

  # Getting the users from gpg:
  users=$(_get_users_in_gitsecret_keyring)
  for user in $users; do
      #
      echo -n "$user"

      if [[ "$long_display" -eq 1 ]]; then
        local expiration
        expiration=$(_get_user_key_expiry "$user")
        if [[ -n "$expiration"  ]]; then
          local expiration_date
          expiration_date=$($SECRETS_EPOCH_TO_DATE "$expiration")
          echo -n " (expires: $expiration_date)"
        else
          echo -n " (expires: never)"
        fi
	if [ "$(_get_mode)" = "$SECRETS_MODE_SOPS" ]; then
          # find the user group
          group=$(_get_id_group "$SECRETS_SOPS_PGP" "$user")
	  echo -n " - group: $group"
	fi
      fi

      echo
  done
}
