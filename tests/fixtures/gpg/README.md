== public/private key pairs for test keys

* user1 and user2 are normal gpg key sets for user1@gitsecret.io and 
  user2@gitsecret.io. They have the passwords 'user1pass' and 'user2pass', 
  respectively.

* user3 was created by `gpg --quick-generate user3@gitsecret.io` 
  and therefore has only an email associated with it (no username).  
  It has the password 'user3pass' as the tests expect.
  This user was created to fix https://github.com/sobolevn/git-secret/issues/227 ,
  "keys with no info but the email address not recognized by whoknows"
