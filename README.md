# lazyTools

## Description

This project as for goal to easily setup/configure/maintains packages on some linux distributions (Debian/RedHat)... 

You could choose to install the default packages provided by lazyTools and custom them or you could also dynamically create and custom your own package. Basically we could say lazyTools acts like your own and custom cli package manager !

## Requirements

- Root access
- Debian or Redhat based distribution (For now)

## Installation

In order to install it, just open a terminal and copy/paste the following commands:

```bash
git clone https://github.com/SolalVall/lazyTools.git && \
cd lazyTools && \
sudo ./install.sh
```

## Basic Usage

- Install a package: ``` lt --package_name ```

  Example:

  ```bash
  sudo lt --install git
  sudo lt -i vagrant
  ```

- List package available: ``` lt [-l|--list]```

- Check script version: ``` lt [-v|--version]```

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

v0.0.2:
  - Create a small installer
  - Main script able to retrieve package from default and user custom
  - Move packagages to tools/ folder
  - Readme
