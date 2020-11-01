# Premiers pas GIT
* Source get started

  https://git-scm.com/book/en/v2

* Credential dans C:\Users\"username" .gitconfig (sauvegarde permanante en file système)
```
[credential "https://github.com"]
username = lambert.eworking@free.fr
[credential]
helper = store
```
* Commandes
```
git config --global user.email lambert.eworking@free.fr
git config --global user.name dlambert-eworking
git config credential.helper 'store'
```
