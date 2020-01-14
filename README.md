# lazyTools

## Description

This project as for goal to easily setup some packages for some linux distributions (Debian/RedHat)... 

Basically we could say that's it is act like your own and custom cli package manager !

## Requirements

- Root access
- Debian or Redhat based distribution (For now)

## Installation

In order to install it, just open a terminal and copy/paste the following commands:

```
git clone https://github.com/SolalVall/lazyTools.git ~/.lazyTools.d 
sudo cp ~/lazyTools.sh /usr/local/bin/lt
```

To verify that lazyTools (```lt```) was correctly setup execute:

```
lt --version
```

## Usage

- Install a package: ``` lt --package_name ```

  Example:

  ```
  lt --install git
  lt -i vagrant
  ```

- Check script version: ``` lt [-v|--version]```

- List package available: ``` lt [-l|--list]```

- Display help: ``` lt [-h|--help]```

## Releases infos
  
Please find below the historic of the different lazyTools releases:
 
v0.0.1:
  - Func for assigning the correct package manager.
  - Default Functions for verifying a package and install it.
  - Install tools via a dedicated script (default install.sh)
  - Works with Debian for now.
  - Readme.
  - Options added: --version, --help, --list
  - Tools added: git, vagrant, virtualbox
