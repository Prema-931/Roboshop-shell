#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.daws76s.tech

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R FAILED $N"
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi    
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else    
     echo "You are root user"
fi  # fi means reverse of if, indicating condition end 

dnf module disable nodejs -y  

VALIDATE $? "Disabling current NodeJS"  &>> $LOGFILE

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling NodeJS:18"  &>> $LOGFILE

dnf install nodejs -y

VALIDATE $? "Installing NodeJS"  &>> $LOGFILE

useradd roboshop

VALIDATE $? "Creating roboshop user"  &>> $LOGFILE

mkdir /app

VALIDATE $? "Creating app directory"  &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading catalogue application"  &>> $LOGFILE

cd /app 

unzip /tmp/catalogue.zip

VALIDATE $? "Unzipping catalogue"  &>> $LOGFILE

npm install 

VALIDATE $? "Installing dependencies"  &>> $LOGFILE

# use absolute path, because catalogue.serviceexists there.
cp /home/centos/Roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copying catalogue service file"  &>> $LOGFILE

systemctl daemon-reload

VALIDATE $? "Catalogue daemon-reload"  &>> $LOGFILE

systemctl enable catalogue

VALIDATE $? "Enabling catalogue"  &>> $LOGFILE

systemctl start catalogue

VALIDATE $? "Starting catalogue"  &>> $LOGFILE

cp /home/centos/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copying mongodb repo"  &>> $LOGFILE

dnf install mongodb-org-shell -y

VALIDATE $? "Installing mongodb client"  &>> $LOGFILE

mongo --host $MONGODB_HOST </app/schema/catalogue.js

VALIDATE $? "Loading catalogue data into mongodb"    &>> $LOGFILE

