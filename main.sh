#!/usr/bin/env bash

#*********************************************************************************************
# A configuration management tool for deploying simple php application to Debian Linux server
#*********************************************************************************************

logFile="${PWD}/system.log"
uninstallFile="${PWD}/packages/uninstall.lst"
installFile="${PWD}/packages/install.lst"
configFile="${PWD}/config.txt"
appLocation="/var/www/html"
appFile="/var/www/html/index.html"


envOS=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
echo $envOS
echo "Runing Configuration Management tool"
echo "LogFile located at: - $logFile"
echo "Install File located at: - $installFile"
echo "Uninstall File located at: - $uninstallFile"
echo "Config File located at: - $configFile"


initialize() {
    echo "$(date): Starting Configuration Management Tool ********************************"
    sudo touch "${logFile}" >&/dev/null
}

bootstrapServer(){
  echo "$(date): Bootstraping server ********************************"
  /${PWD}/bootstrap.sh
}


removePackages(){
    if [ -s $uninstallFile ];

      then
          declare -a removal_list
          echo "$(date): Reading $uninstallFile"
          while IFS='\n' read -r value; do
              removal_list+=( "${value}" )
          done < "$uninstallFile"

          echo "$(date): Uninstalling packages ********************************"
          for pkg in "${removal_list[@]}"
          do

            if dpkg -l | grep -i "${pkg}"; then
              sudo apt-get -y remove "${pkg}"
              sudo apt-get -y autoremove
              sudo apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}')
              sudo apt-get -y clean
            fi
          done


      else
          echo "$(date): Uninstall package list is missing entry ********************************";

    fi

}

installPackages(){

  if [ -s $installFile ];

    then
        declare -a install_list
        echo "$(date): Reading $installFile ********************************"
        while IFS='\n' read -r value; do
            install_list+=( "${value}" )
        done < "$installFile"

        ## remove local repo dependency, already exit in deployment server
        ##echo "$(date): Adding SURY PHP PPA repository ********************************"
        ##sudo apt-get -y install lsb-release apt-transport-https ca-certificates wget
        ##sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
        ##echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.

        ## remove server repo dependency
        ##echo "$(date): Adding PHP repository ********************************"
        ##sudo apt-get update
        ##sudo apt -y install software-properties-common
        ##sudo add-apt-repository ppa:ondrej/php
        ##sudo apt-get update

        echo "$(date): Installing packages ********************************"
        for pkg in "${install_list[@]}"
        do

          if ! dpkg -l | grep "${pkg}"; then
            sudo apt-get install -y "${pkg}"
          fi
        done

    else
        echo "$(date): Install package list is missing entry ********************************";

  fi


}


deployApp(){
  if [ -s $appFile ]; then
    sudo rm -rf $appFile
  fi
  echo "$(date): Deploying index.php to $appLocation ********************************";
  cp ${PWD}/index.php $appLocation

}


configureApp(){
  if [ -s $configFile ]; then
    declare -A content
    echo "$(date): Reading $configFile ********************************"
    while IFS== read -r key value; do
      content[$key]=$value
    done < "$configFile"
    echo "$(date): Configuring application folder ********************************"
    sudo chmod "${content[permissions]}" "${content[file]}"
    sudo chown "${content[owner]}" "${content[file]}"
    sudo chgrp "${content[group]}" "${content[file]}"

  fi

}

startApp(){
  echo "$(date): Starting web application ********************************"
  sudo service apache2 restart
}


sanityTest(){
  echo "$(date): Running curl command  ********************************"
  host="`hostname`"
  curlCommand= "`curl -sv http://$host`";
	echo "$curlCommand " || exit 0 ;
}



# Main
initialize >> "${logFile}" 2>&1
bootstrapServer >> "${logFile}" 2>&1
removePackages >> "${logFile}" 2>&1
installPackages >> "${logFile}" 2>&1
deployApp >> "${logFile}" 2>&1
configureApp >> "${logFile}" 2>&1
startApp >> "${logFile}" 2>&1
sanityTest >> "${logFile}" 2>&1
