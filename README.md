# Configuration Management Tool

A rudimentary configuration management tool to configure two servers for production service of a simple PHP web application to Debian/Ubuntu Linux server environment. CMtool is implemented similarly to Puppet, Chef, Fabric and Ansible. This tool was developed using bash / shell scripting language.

## Abstractions:

1.  Add bootstrap.sh program to resolve dependencies
2.  Allows specifying a file's content and metadata (owner, group, mode)
3.  Allows installing and removing Debian packages
4.  Provide some mechanism for restarting a service when relevant files or packages are updated
5.  Re-useable => Apply your configuration over and over again

## How to Configure:

- To install a package, add the package name to install.lst in the packages directory. Each package name should contain is own line without any trailing whitespace. See details below.

```bash

apache2
php7.4-mysql
php7.4
php7.4-cli
php7.4-common
php7.4-json
php7.4-opcache
php7.4-zip
php7.4-fpm
php7.4-mbstring
php7.4-curl

```

- To uninstall a package involves doing the same thing as install package but this time one should add package names to the uninstall.lst file in the packages directory.

- To allow specifying file content and metadata, add key value pairs to config.txt file. Each entry must be separated by "=" and have it's own line. Please make sure to remove trailing whitespace.

## How to use (Tested locally on Debian Linux server 11)

Before running any of the following command check whether the user is ROOT or NON ROOT user. If the user is root, then run command
without putting sudo in front and if the user is non root then run command putting sudo in front.

- Move files to remote servers via scp or ftp:

  ```bash
  scp -r CMTool.tar.gz username@IP_ADDRESS/opt
  ```

- Change directory to where CMTool tar file is located on the remoter server and untar file CMTool.tar.gz :

  ```bash
  cd /opt
  tar -xvzf CMTool.tar.gz

  ```

- Give permissions to all files in the folder directory:

  ```bash
  chmod -R 755 CMTool
  ```

- Run CLI CMTool
  ```bash
  cd CMTool
  ./main.sh
  ```

## transfer files using script from target server to remote server. Please install sshpass on target server - apt-get install sshpass

```bash
./transfer.sh 10.XX.XX.XX 10.XX.XX.XX root YOUR_PASSWORD CMTool.tar.gz /opt
```
