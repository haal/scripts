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
  MONGODB="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.3.tgz"
  SUBLIME_TEXT2="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1%20x64.tar.bz2"
  JDK="http://download.oracle.com/otn-pub/java/jdk/7u21-b11/jdk-7u21-linux-x64.tar.gz"
  GEMSET="cia"
  SCALA="http://www.scala-lang.org/downloads/distrib/files/scala-2.10.1.tgz"
  MAVEN3="http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz"
  ECLIPSE="http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/juno/SR2/eclipse-java-juno-SR2-linux-gtk-x86_64.tar.gz"
else
  #echo -e "${green} Preparing software for 32bit system ... ${endColor}"
  MONGODB="http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.4.3.tgz"
  SUBLIME_TEXT2="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.tar.bz2"
  JDK="http://download.oracle.com/otn-pub/java/jdk/7u21-b11/jdk-7u21-linux-i586.tar.gz"
  GEMSET="cia"
  SCALA="http://www.scala-lang.org/downloads/distrib/files/scala-2.10.1.tgz"
  MAVEN3="http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz"
  ECLIPSE="ftp://mirror.selfnet.de/eclipse/technology/epp/downloads/release/juno/SR2/eclipse-java-juno-SR2-linux-gtk.tar.gz"
fi
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
  echo -e "${green} Installing Oracle JDK... ${endColor}"
  cd ~/$TEMP_DIR
  wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" $JDK
  tar -xvf jdk-*
  sudo mkdir -p /usr/lib/jvm
  sudo mv jdk1.7.0_* /usr/lib/jvm/jdk1.7.0
  sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.7.0/bin/java" 1
  sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.7.0/bin/javac" 1
  sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.7.0/bin/javaws" 1
  sudo chmod a+x /usr/bin/java
  sudo chmod a+x /usr/bin/javac
  sudo chmod a+x /usr/bin/javaws
  sudo chown -R root:root /usr/lib/jvm/jdk1.7.0
  #sudo update-alternatives --config java
  rm jdk-*
}

postgresql() {
  echo -e "${green} Installing PostgreSQL... ${endColor}"
  sudo apt-get install -y postgresql-9.1 postgresql-client pgadmin3 libpq-dev
#  sudo -u postgres psql
#  ALTER USER postgres PASSWORD 'newPassword';
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
  mv scala-2.10.1 /opt
  ln -s /opt/scala-2.10.1/bin/scala /usr/bin/scala
  ln -s /opt/scala-2.10.1/bin/scalac /usr/bin/scalac
  ln -s /opt/scala-2.10.1/bin/fsc /usr/bin/fsc
  ln -s /opt/scala-2.10.1/bin/sbaz /usr/bin/sbaz
  ln -s /opt/scala-2.10.1/bin/sbaz-setup /usr/bin/sbaz-setup
  ln -s /opt/scala-2.10.1/bin/scaladoc /usr/bin/scaladoc
  ln -s /opt/scala-2.10.1/bin/scalap /usr/bin/scalap
  rm scala*
# remove
# rm -rf /opt/scala /usr/bin/scala /usr/bin/scalac /usr/bin/fsc /usr/bin/sbaz /usr/bin/sbaz-setup /usr/bin/scaladoc /usr/bin/scalap
}

maven() {
  echo -e "${green} Installing Maven3 ... ${endColor}"
  cd $HOME/$TEMP_DIR
  wget $MAVEN3
  tar -xvf apache-*
  rm apache-maven*.tar.gz
  mv apache-maven* /opt
  ln -s /opt/apache-maven-3.0.5/bin/mvn /usr/bin/mvn
}

eclipse() {
  echo -e "${green} Installing Eclipse IDE ... ${endColor}"
  cd $HOME/$TEMP_DIR
  wget $ECLIPSE
  tar -xvf eclipse-java*
  mv eclipse ~/apps/
  rm eclipse-juno*.tar.gz
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
# install selected apps
for i in ${!tools[@]}; do
    [[ "${choices[i]}" ]] && { eval "${tools[i]}" msg=""; }
done
#cleaning step
remove_temp
