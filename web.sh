#!?bin/bash

ID=$(id -u)

$R="\e[31m"
$G="\e[32m"
$Y="\e[33m"
$N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

exec &>> $LOG_FILE

if [ $? -ne 0 ]
then 
    echo -e "$R ERROR :: You are not a root user..pls take access $N"
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

dnf install nginx -y

validate $? "Installing nginx"

dnf enable nginx 

validate $? "Enabling nginx"

dnf start nginx 

validate $? "Starting nginx"

rm -rf /usr/sher/nginx/html/*

validate $? "removing default nginx web content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

validate $? "Downloading web module"

cd /usr/share/nginx/html/

unzip -o /tmp/web.zip 

validate $? "Unzipping web module"

cp /home/centos/roboshop-shellscript/roboshop.conf /etc/nginx/default.d/roboshop.conf

validate $? "Copying Roboshop configuration file"

systemctl restart nginx 

validate $? "Restarting nginx"