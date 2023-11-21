# powershellmarks

A port of [bashmarks](https://github.com/huyng/bashmarks) to `PowerShell`.

# Commands

    s <bookmark_name> - Saves the current directory as "bookmark_name"
    g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"
    p <bookmark_name> - Prints the directory associated with "bookmark_name"
    d <bookmark_name> - Deletes the bookmark
    l                 - Lists all available bookmarks

# Usage

    $ cd /var/www/
    $ s webfolder
    $ cd /usr/local/lib/
    $ s locallib
    $ l
    $ g web<tab>
    $ g webfolder

# Installation

1.  Clone powershellmarks

``` powershell
$ git clone http://github.com/donniebreve/powershellmarks.git
```

2. Edit your PowerShell profile `$PROFILE`
``` powershell
$ notepad $PROFILE
```

3. Add this line and save the file
```
Import-Module C:/path/to/powershellmarks.psm1
```

The module will be auto loaded when opening new PowerShell windows.