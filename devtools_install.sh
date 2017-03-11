#!/bin/bash

#######################################################################
# Bash script for dev tools installation on Debin/Ubuntu based systems.
# run ./devtools_install.sh
#######################################################################


#colors
green='\e[0;32m'
red='\e[0;31m'
endColor='\e[0m'

# links
TEMP_DIR="temp_install_data"
if [ `uname -p` = "x86_64" ]; then
  #echo -e "${green} Preparing software for 64bit system ... ${endColor}"
  MONGODB="https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.2.6.tgz"
  SUBLIME_TEXT2="https://download.sublimetext.com/sublime_text_3_build_3114_x64.tar.bz2"
  JDK="http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz"
  ECLIPSE="http://ftp.fau.de/eclipse/technology/epp/downloads/release/mars/2/eclipse-java-mars-2-linux-gtk-x86_64.tar.gz"
else
  #echo -e "${green} Preparing software for 32bit system ... ${endColor}"
  MONGODB="https://fastdl.mongodb.org/linux/mongodb-linux-i686-3.2.6.tgz"
  SUBLIME_TEXT2="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.tar.bz2"
  JDK="http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-i586.tar.gz"
  ECLIPSE="https://eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/mars/2/eclipse-java-mars-2-linux-gtk.tar.gz"
fi
GEMSET="cia"
MAVEN3="http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
SCALA="http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz"
RUBY_RAILS_DOC="http://railsapi.com/doc/rails-v3.2.6_ruby-v1.9.2/rdoc.zip"

###################
# install functions
###################

# create initial dirs for apps and data
create_dirs() {
  echo -e "${green} Creating initial directories... ${endColor}"
  mkdir ~/apps
  mkdir ~/data
  mkdir ~/workspace
  mkdir ~/$TEMP_DIR
}

remove_temp() {
  echo -e "${green} Removing temp data ... ${endColor}"
  rm -rf ~/$TEMP_DIR
}

basic_apps() {
  echo -e "${green} Installing basic apps... ${endColor}"
  sudo apt-get install -y curl
}

git() {
  echo -e "${green} Installing git ... ${endColor}"
  sudo apt-get install -y git gitk git-gui git-extras
}

sublime_text() {
  echo -e "${green} Installing Sublime Text 2... ${endColor}"
  cd  ~/$TEMP_DIR
  wget $SUBLIME_TEXT2
  tar -xvf Sublime*
  mv Sublime\ Text\ 2 /opt/
  ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
}

#not up to date
ruby_rails() {
  echo -e "${green} Installing Ruby and Rails... ${endColor}"
  curl -L get.rvm.io | bash -s stable
  source $HOME/.bash_profile
  rvm requirements
  rvm install 1.9.3
  rvm use --default 1.9.3
  rvm gemset create $GEMSET # create a gemset
  rvm gemset use $GEMSET # use a gemset in this ruby
}

ruby_rails_docs() {
  echo -e "${green} Installing Ruby and Rails docs ... ${endColor}"
  cd ~/$TEMP_DIR
  wget $RUBY_RAILS_DOC
  unzip rdoc.zip -d rdoc
  mv rdoc ~/apps/rdoc
  rm rdoc.zip
}

oracle_jdk() {
  echo -e "${green} Installing Oracle JDK... ${endColor}"export JAVA_HOME=/usr/lib/jvm/java-8-oracle
  cd ~/$TEMP_DIR
  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK
  tar -xvf jdk-*
  sudo mkdir -p /usr/lib/jvm
  sudo mv jdk1.8.0_91* /usr/lib/jvm/jdk1.8.91
  sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.91/bin/java" 1
  sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.91/bin/javac" 1
  sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.91/bin/javaws" 1
  sudo chmod a+x /usr/bin/java
  sudo chmod a+x /usr/bin/javac
  sudo chmod a+x /usr/bin/javaws
  sudo chown -R root:root /usr/lib/jvm/jdk1.8.91
  #sudo update-alternatives --config java
  rm jdk-*
}

postgresql() {
  echo -e "${green} Installing PostgreSQL... ${endColor}"
  sudo apt-get install -y postgresql-9.5 postgresql-client pgadmin3 libpq-dev
#  sudo -u postgres psql
#  ALTER USER postgres PASSWORD 'newPasswrod';
}

heroku_toolbelt() {
  echo -e "${green} Installing Heroku toolbelt ... ${endColor}"
  wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
}

mongodb() {
  echo -e "${green} Installing MongoDB ... ${endColor}"
  cd $HOME/$TEMP_DIR
  wget $MONGODB
  tar -xvf mongodb*
  rm mongo*.tgz
  mv mongodb* $HOME/apps
}

scala() {
  echo -e "${green} Installing Scala ... ${endColor}"
  cd $HOME/$TEMP_DIR
  wget $SCALA
  tar -xvf scala*
  sudo mv scala-2.11.8 /opt
  sudo ln -s /opt/scala-2.11.8/bin/scala /usr/bin/scala
  sudo ln -s /opt/scala-2.11.8/bin/scalac /usr/bin/scalac
  sudo ln -s /opt/scala-2.11.8/bin/fsc /usr/bin/fsc
  sudo ln -s /opt/scala-2.11.8/bin/sbaz /usr/bin/sbaz
  sudo ln -s /opt/scala-2.11.8/bin/sbaz-setup /usr/bin/sbaz-setup
  sudo ln -s /opt/scala-2.11.8/bin/scaladoc /usr/bin/scaladoc
  sudo ln -s /opt/scala-2.11.8/bin/scalap /usr/bin/scalap
  rm scala*
# remove
# rm -rf /opt/scala /usr/bin/scala /usr/bin/scalac /usr/bin/fsc /usr/bin/sbaz /usr/bin/sbaz-setup /usr/bin/scaladoc /usr/bin/scalap
}

maven() {
  echo -e "${green} Installing Maven3 ... ${endColor}"
  cd $HOME/$TEMP_DIR
  wget $MAVEN3
  tar -xvf apache-maven*
  rm apache-maven*.tar.gz
  sudo mv apache-maven* /opt
  sudo ln -s /opt/apache-maven-3.3.9/bin/mvn /usr/bin/mvn
}

eclipse() {
  echo -e "${green} Installing Eclipse IDE ... ${endColor}"
  cd $HOME/$TEMP_DIR
  wget $ECLIPSE
  tar -xvf eclipse-java*
  mv eclipse ~/apps/
  mv ~/apps/eclipse ~/apps/eclipse-java
  rm eclipse-java*.tar.gz
}

# selection of tools

tools=("git" "sublime_text" "ruby_rails" "ruby_rails_docs" "oracle_jdk" "postgresql" "heroku_toolbelt" "mongodb" "scala" "maven" "eclipse" "Quit")

menuitems() {
    echo "Avaliable tools:"
    for i in ${!tools[@]}; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${tools[i]}"
    done
    [[ "$msg" ]] && echo "$msg"; :
}

prompt="Enter an option (enter again to uncheck, press RETURN when done to start installation process): "
while menuitems && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#tools[@]} )) || {
        msg="Invalid option: $num"; continue
    }
    if [ $num == ${#tools[@]} ];then
      exit
    fi
    ((num--)); msg="${tools[num]} was ${choices[num]:+un-}selected"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
done

#printf "You selected"; msg=" nothing"
# preparation steps
sudo apt-get update
create_dirs
basic_apps
# install selected apps
for i in ${!tools[@]}; do
    [[ "${choices[i]}" ]] && { eval "${tools[i]}" msg=""; }
done
#cleaning step
remove_temp
