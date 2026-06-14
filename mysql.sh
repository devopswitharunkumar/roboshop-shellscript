#!bin/bash

ID=$(id -u)

$R="\e[31m"
$G="\e[32m"
$Y="\e[33m"
$N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

if [ $ID -ne 0 ]
then 
    echo -e "$R You are not a root userpls take access $N"
else 
    echo -e "$G You are a root user $N"
fi

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R Failed $N"
    else
        echo -e "$2 ... $G Success $N"
    fi
}


dnf module disable mysql -y

validate $? "Disabling default version"

cp mysql.repo /etc/yum.repos.d/mysql.repo

validate $? "Copying mysql repo"

dnf install mysql-community-server -y

validate $? "Installing mysql community server"

systemctl enable mysqld

validate $? "Enabling mysql module"

systemctl start mysqld

validate $? "Starting mysql module"

mysql_secure_installation --set-root-pass RoboShop@1

validate $? "Setting mysql root password"

#mysql -uroot -pRoboShop@1 --> with this command it will login sql terminal where we can perform sql commands
