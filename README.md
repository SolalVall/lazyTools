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
sudo ./setup.sh
```

## Basic Usage

- Install a package: ``` lt [-i|--install] foo```

  Example:

  ```bash
  sudo lt --install git
  sudo lt -i vagrant
  ```

- Install multiple packages: ```lt [-i|--install] foo bar```

  Example:

  ```bash
  sudo lt --install git vagrant
  ```

- Create your own package: ```lt [-c|--create] foo```

- List package available: ``` lt [-l|--list]```

- Check script version: ``` lt [-v|--version]```

- Display help: ``` lt [-h|--help]```

## Pipeline

### Test it locally with Vagrant

In order to test lazyTools locally run the following commands:

```bash
cd pipeline && ./pipeline.sh
```

To write some custom tests please update the ```test_lt``` function in ```pipeline/pipeline.sh``` script.

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
  - Move packages to tools/ folder

v0.1:
  - Add possibility for user to create their own package in ~/lazytools.d (```lt -c my_package```)
  - Add ability to list packages from user home and default lazyTools location
  - User can now add a config.sh to a package (via their own ~/lazytools.d folder). Acts like a custom configuration for their package

v0.1.1
  - Enable possibility to install multiple packages at the same time
  - Modify command output

v0.2:
  - Create a local Pipeline in order to test lazyTools installations and some commands via Vagrant (available into the pipeline folder)
