# http://ubuntuforums.org/showthread.php?t=1088651
export PATH=$PATH:~/bin:~/local/bin

alias suwe="sudo -u we"
alias madcd="cd /home/we/enc/projects/mad-lan"
mpl() {
    madcd
    sudo /opt/play/play $1 -Dbackend=true -DdebugUI=true -DuseCache=true -Ddemo=true -Dclojure=true -Dtranslation=true --%dev
}
chme() {
    sudo chown -R `whoami` $1
}
alias chp="chme ~/enc/projects"
mhashclean(){
    files=`find ~/enc/projects/mad-lan/app | grep '#'`
    echo 'removing:'
    rm $files
    echo $files
    echo done
}
alias build-all-madlan="/home/we/enc/projects/mad-lan/scripts/build-all-madlan.sh; chme ..; mhashclean;"
alias psj="ps -lef | grep java"
alias ecnw="emacsclient -c -nw"
alias delcache="sudo rm -Rf /var/tmp/cache/*"
pt3() {
    echo "killing pytyle3"
    killall pytyle3
    echo "running pytyle3"
    pytyle3 &
    echo "done"
}
pt2() { 
    echo "killing pytyle2"
    killall pytyle2
    echo "running pytyle2"
    pytyle2 &
    echo "done"
}

alias j6="sudo update-java-alternatives -s java-6-oracle"
alias j7="sudo update-java-alternatives -s java-7-oracle"
alias j8="sudo update-java-alternatives -s java-8-oracle"
