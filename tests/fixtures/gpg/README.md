== public/private key pairs for test keys

* user1 and user2 are normal gpg key sets for user1@gitsecret.io and 
  user2@gitsecret.io. They have the passphrases 'user1pass' and 'user2pass', 
  respectively.
  user1 is not currently used.

* user3 was created by `gpg --quick-generate user3@gitsecret.io` 
  and therefore has only an email associated with it (no username).  
  It has the passphrase 'user3pass' as the tests expect.
  This user was created to fix https://github.com/sobolevn/git-secret/issues/227 ,
  "keys with no info but the email address not recognized by whoknows"

* user4 was created with `gpg --gen-key`, using the name 'user4'
  and the email address user4@gitsecret.io. As the tests expect,
  it has the passphrase 'user4pass'.  

  It is also set to expire on 2018-09-23. To make keys expire, I used the 
  `gpg --edit-key user@email` command's `expiry` function.

  The public and private key for user4 were exported with
    `gpg --export --armor user4 > tests/fixtures/gpg/user4/public.key`
  and
    `gpg --export-secret-keys --armor user4 > tests/fixtures/gpg/user4/private.key`

* user5 was created for issue #527 using `gpg --full-generate-key`.
  with name 'user5', no email address, the comment 'comment comment', and 
  the passphrase 'user5pass'.  Keys were exported as above.
  
* user6 was created for issue #509 using `gpg --full-generate-key'
  with the name 'user6', the email address 'user6@gitsecret.io',
  and the passphrase 'user6pass'. It was also uploaded to keys.opengpg.org
  as per `https://keys.openpgp.org/about/usage`. Since the key was not verified
  (by confirming an email sent to user6@gitsecret.io), it can only be found on
  keys.opengpg.org using its fingerprint 'FA536BC8867421437DF58F347E99A53E6A74F0FC'.
  Keys were also exported to tests/fixtures/gpg as above.
  See the tests using `SECRETS_TELL_GPG_OPTIONS` env var in <tests/test_tell.bats>
  for an example of fetching keys from keys.openpgp.org
