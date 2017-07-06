#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with nssm](#setup)
    * [What nssm affects](#what-nssm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nssm](#beginning-with-nssm)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Module to install and manage use of the nssm (http://nssm.cc/)

## Module Description

Installs nssm (the Non-Sucking Service Manager)


## Setup

### What nssm affects

* Installs into NSSM into program files (files only)

### Beginning with nssm

Install with defaults:

```puppet
  include nssm
```

Install from custom url:

```puppet
  class { 'nssm':
    install_url = 'http://nssm.cc/release/nssm-2.23.zip',
    install_dir = 'C:\Program Files\nssm',
    version     = '2.23'
  }
```

## Usage

### Classes and Defined Types

#### Class: `nssm`
One of the primary classes of the nssm module. This class will install the nssm binaries

**Parameters within `nssm`:**
##### `install_url`
The url to download the nssm package from

##### `install_dir`
The directory to install the package to

##### `version`
The version of nssm to install

### Creating a windows_service using puppet

```puppet
  windows_service { 'service name':
    command    => 'c:/dos/run',
    start_in   => 'c:/doc/run',
    parameters => ['-are','optional']
  }
```

## Reference

### Classes
#### Pulic Classes
* [`nssm`](#class-nssm): Guides the install of the nssm files from zip file

### Types
* [`windows_service`](#type-nssm): Type to create windows services

## Limitations

This module is tested on the following platforms:

* Windows 2012 R2

It is tested with the OSS version of Puppet only.

## Development

### Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
