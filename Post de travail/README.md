
# Installation de WSL 2
## Source
https://docs.microsoft.com/fr-fr/windows/wsl/install-win10

# Version windows
```Shell
  winver
```

# Type d'OS (PowerShell)
```Shell
  systeminfo | find "System Type"
```

# Register OS
wsl --import Ubuntu2004 C:\Users\nzkc9106\Documents\Mission\wslDistroStorage\Ubuntu2004 C:\Users\nzkc9106\Documents\Mission\wslDistroStorage\Ubuntu2004\focal-server-cloudimg-amd64-wsl.rootfs.tar.gz --version 2

# Unregister OS
wsl --unregister Ubuntu2004

https://github.com/microsoft/WSL/issues/5336
resolv.conf.ko:nameserver 172.17.206.209
resolv.conf.new:nameserver 10.160.88.89
resolv.conf.new:nameserver 10.114.80.34
https://gist.github.com/coltenkrauter/608cfe02319ce60facd76373249b8ca6
