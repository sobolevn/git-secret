== public/private key pairs for test keys

* git-secret test keys are named user1@gitsecret.io through 
  user5@gitsecret.io

* All test keysets have the passphrases 'userNpass' I.E., 'user3pass' 
  for user3@gitsecret.io.

* The public/private key sets were exported with (for example)
    `gpg --export --armor user4 > tests/fixtures/gpg/user4/public.key`
  and
    `gpg --export-secret-keys --armor user4 > tests/fixtures/gpg/user4/private.key`

* user1 and user2 are normal gpg key sets for user1@gitsecret.io and 
  user2@gitsecret.io, and have the passphrases 'user1pass' and 'user2pass'.

* user3 was created by `gpg --quick-generate user3@gitsecret.io` 
  and therefore has only an email associated with it (no username).  
  This user was created to fix 
  https://github.com/sobolevn/git-secret/issues/227,
  "keys with email address but no name not recognized by whoknows".
  The passphrase is 'user3pass'.

* user4 was created with `gpg --gen-key`, using the name 'user4'
  and the email address user4@gitsecret.io, and is also set to 
  expire on 2018-09-23. 
  To set the key's expiry, I used the 
 `gpg --edit-key user@email` command's `expiry` function. 
  The passphrase is 'user4pass'.

* user5 was created for issue #527, where keys were being rejected if they 
  didn't have an email address, and had whitespace in their 'comment'.
  using `gpg --full-generate-key` with name 'user5', no email address, 
  the comment 'comment comment', and the passphrase 'user5pass'.  
  
