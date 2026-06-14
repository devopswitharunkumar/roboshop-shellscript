#!/bin/bash

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


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

validate $? "Downloading script of rabbitmq"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

validate $? "Downloading Enlarge script"

dnf install rabbitmq-server -y 

validate $? "Installing rabbitmq server"

systemctl enable rabbitmq-server

validate $? "Enabling rabbitmq server"

systemctl start rabbitmq-server

validate $? "Starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123

validate $? "Creating rabbitmq user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

validate $? "Setting permissions for that user"