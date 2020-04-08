# dotfiles
Dotfiles


## Install

mkdir -p ${HOME}/dev/

cd ${HOME}/dev/

git clone https://github.com/diakitenicolas/dotfiles.git

./dotfiles/init


## Conf

Use the `PROCESS_DATA` to set tools to not install , tools installation version and others stuffs.

To remove tools from installation use `DISABLE_TOOLS_INSTALL` . 
Exemple : PGP from install process : 
```
DISABLE_TOOLS_INSTALL=BCRYPT
```

You can also disable all tools using the `ALL` value.
```
DISABLE_TOOLS_INSTALL=ALL
```

To set Java version to use : 
```
JDK_VERSION_TO_USE=1.8
```


To set GOLANG version to use : 
```
GO_VERSION_TO_INSTALL=1.14.1 
```
