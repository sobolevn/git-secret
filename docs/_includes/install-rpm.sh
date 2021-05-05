wget https://raw.githubusercontent.com/sobolevn/git-secret/master/utils/rpm/git-secret.repo -O git-secret-rpm.repo
# Inspect what's inside! You can also enable `gpg` check on repo level.
sudo mv git-secret-rpm.repo /etc/yum.repos.d/
sudo yum install -y git-secret
