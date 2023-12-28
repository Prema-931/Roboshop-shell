#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R FAILED $N"
        exit 1
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

dnf install golang -y

id roboshop   # if roboshop user does not exists, then it is failure
if [ $? -ne 0 ]
then 
   useradd roboshop             
   VALIDATE $? "roboshop user creation  "  
else 
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi    


mkdir /app 

VALIDATE $? "Creating app directory"

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip

VALIDATE $? "Creating app directory"
cd /app 

unzip /tmp/dispatch.zip

VALIDATE $? "Creating app directory"

go mod init dispatch

VALIDATE $? "Creating app directory"

go get

VALIDATE $? "Creating app directory"

go build
VALIDATE $? "Creating app directory"

vim /etc/systemd/system/dispatch.service

VALIDATE $? "Creating app directory"

systemctl daemon-reload

VALIDATE $? "Creating app directory"

systemctl enable dispatch 

VALIDATE $? "Creating app directory"

systemctl start dispatch

VALIDATE $? "Creating app directory"