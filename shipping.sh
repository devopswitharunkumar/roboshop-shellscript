#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR :: you are not a root user..pls get access $N"
else
    echo -e "$G You are a root user.. pls proceed $N"
fi

$R="\e[31m"
$G="\e[32m"
$Y="\e[33m"
$N="\e[0m"

MYSQL_HOST=mysql.devopswitharun.online

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

exec &>> $LOG_FILE

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R Failed $N"
    else
        echo -e "$2 ... $G Success $N"
    fi
}

dnf install maven -y

validate $? "Installing maven for java"

id roboshop
if [ $? -ne 0 ]
then 
    echo -e "$Y User doesn't exist pls Create $N"
    useradd roboshop
    validate $? "Creating user"
else
    echo -e "$Y User already exists ... Skipping $N"
fi

mkdir /app

validate $? "Creating Directory"

curl -L -o /tmp/shipping.zip https://my-roboshop-files.s3.us-east-1.amazonaws.com/shipping.zip

validate $? "Downloading shpping module"

cd /app

unzip -o /tmp/shippin.zip

validate $? "Unzipping zip files"

mvn clean package

validate $? "Installing java dependencies"

mv target/shipping-1.0.jar shipping.jar

validate $? "Renaming the jar file"

cp /home/centos/roboshop-shellscript/shipping.service /etc/systemd/system/shipping.service

validate $? "Copying Service file"

systemctl daemon-reload

validate $? "Daemon-reload"

systemctl enable shipping 

validate $? "Enabling shipping"

systemctl start shipping 

validate $? "Starting shipping"

dnf install mysql -y

validate $? "Installing mysql client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/schema/shipping.sql 

validate $? "Loading shipping data into mysql"

systemctl restart shipping

validate $? "restarting Shipping module"