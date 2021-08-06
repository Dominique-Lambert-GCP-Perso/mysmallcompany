
# Installation de WSL 2
## Source
https://docs.microsoft.com/fr-fr/windows/wsl/install-win10

https://wiki.ubuntu.com/WSL?_ga=2.226910361.520029537.1628252665-392281212.1627897250

# Version windows
```Shell
  winver
```

# Type d'OS (PowerShell)
```Shell
  systeminfo | find "System Type"
```

# Import OS
wsl --import Ubuntu2004 C:\Users\nzkc9106\Documents\Mission\wslDistroStorage\Ubuntu2004 C:\Users\nzkc9106\Documents\Mission\wslDistroStorage\Ubuntu2004\focal-server-cloudimg-amd64-wsl.rootfs.tar.gz --version 2

# Unregister OS
wsl --unregister Ubuntu2004

# ISSUE WSL 2 : Probably do not work with Cisco AnyConnect version 4.10.00093
Symthomes : 

ping 8.8.8.8 OK

ping www.google.fr : KO

- Dignostic intéressants : https://github.com/microsoft/WSL/issues/4246#issuecomment-745463949 (script testé dns-sync.sh : https://gist.github.com/matthiassb/9c8162d2564777a70e3ae3cbee7d2e95)

- AnyConnect 4.10.01075 New Features: https://github.com/microsoft/WSL/issues/4277#issuecomment-561649724


# Utilisation de WSL 1 (en attendant la correction sur WSL 2)
```Shell
  
PS C:\Users\nzkc9106> wsl --list -v
  NAME                STATE           VERSION
* Ubuntu2004          Stopped         2
  Ubuntu2004-novpn    Stopped         2
PS C:\Users\nzkc9106> wsl --set-version Ubuntu2004 1
La conversion est en cours. Cette opération peut prendre quelques minutes...
La conversion est terminée.

```
