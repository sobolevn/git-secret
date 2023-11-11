wget -qO - 'https://gitsecret.jfrog.io/artifactory/api/gpg/key/public' | gpg --dearmor | sudo tee /usr/share/keyrings/git-secret.gpg > /dev/null
sudo apt-get install apt-transport-https  ca-certificates --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/git-secret.gpg] https://gitsecret.jfrog.io/artifactory/git-secret-deb git-secret main" | sudo tee /etc/apt/sources.list.d/git-secret.list
sudo apt-get update && sudo apt-get install -y git-secret


# Testing, that it worked:
git secret --version
