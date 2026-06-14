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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOG_FILE

validate $? "Installing remi repo from web"

dnf module enable redis:remi-6.2 -y &>> $LOG_FILE

validate $? "Enable redis remi module"

dnf install redis -y &>> $LOG_FILE

validate $? "Installing redis package"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOG_FILE

validate $? "Allowing remote access to server"

systemctl enable redis &>> $LOG_FILE

validate $? "Enable redis module"

systemctl restart redis &>> $LOG_FILE

validate $? "Restarting the redis"