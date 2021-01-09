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

- Execute custom user config script: ```sudo lt [-e|--exec] foo```

- Create your own package: ```lt [-c|--create] foo```

- List package available: ``` lt [-l|--list]```

- Check script version: ``` lt [-v|--version]```

- Display help: ``` lt [-h|--help]```

## Pipeline

### Test it locally with Vagrant

In order to test lazyTools locally run the following commands:

```bash
# Run default tests
cd pipeline && ./pipeline.sh
```

You can also specify via CLI args some packages to test:

```bash
# Test 'foo' & 'bar' packages installation
./pipeline.sh foo bar
```

To write some custom tests please update the ```test_lt``` function in ```pipeline/pipeline.sh``` script.

## Releases infos

Please find below the historic of the different lazyTools releases:

https://github.com/SolalVall/lazyTools/releases
