src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/CommonConfig.sh
logfile=/tmp/roboshop.config
funcEnableService()
{
  # shellcheck disable=SC2154
  printHeader "Enable and start ${component} Service"
  systemctl enable "${component}" &>>$logfile
  systemctl start "${component}" &>>$logfile
}
printHeader() {
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<\e[0m" &>>${logfile}
}
# shellcheck disable=SC1009
statusCheck() {
  if [ $1 -eq 0 ]
  then
    echo -e "\e[35m SUCCESS!!!!\e[0m"
    echo -e "\e[35m SUCCESS!!!!\e[0m" &>>${logfile}
  else
    echo -e "\e[32m FAILURE!!!!\e[0m"
    echo -e "\e[32m FAILURE!!!!\e[0m" &>>${logfile}
    exit
  fi
}
setupSchema() {
  if [ "$schema_setup" == "mongo" ]; then
    printHeader "Copy MongoDB repo"
    cp "${src_path}"/mongo.repo /etc/yum.repos.d/mongo.repo &>>${logfile}
    statusCheck $?

    printHeader "Install MongoDB Client"
    yum install mongodb-org-shell -y &>>${logfile}
    statusCheck $?

    printHeader "Load Schema"
    mongo --host "${mongod_url}" </app/schema/${component}.js &>>${logfile}
    statusCheck $?
  elif [ "${schema_setup}" == "mysql" ]; then
    printHeader "Install MySQL Client"
    yum install mysql -y &>>${logfile}
    statusCheck $?

    printHeader "Load Schema"
    mysql -h "${mysql_url}" -u"${mysql_user}" -p"${mysql_pwd}" < /app/schema/"${component}".sql &>>${logfile}
    statusCheck $?
  fi
}
func_app_prereq() {
  printHeader "Create Application User"
  id ${app_user} &>>/tmp/roboshop.log
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>/tmp/roboshop.log
  fi
  statusCheck $?

  printHeader "Create Application Directory"
  rm -rf /app &>>$logfile
  mkdir /app &>>$logfile
  statusCheck $?

  printHeader "Download Application Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$logfile
  statusCheck $?

  printHeader "Extract Application Content"
  cd /app
  unzip /tmp/${component}.zip &>>$logfile
  statusCheck $?
}
setupNodejs() {

  printHeader "Downloading NodeJS RPM"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$logfile
  statusCheck $?
  printHeader "Install NodeJS"
  yum install nodejs -y &>>$logfile
  statusCheck $?
  func_app_prereq
  npm install
  cp "${src_path}"/"${component}".service /etc/systemd/system/ &>>$logfile
  systemctl daemon-reload &>>$logfile
  funcEnableService
  setupSchema
}

setupJava() {

printHeader "Install Maven"
yum install maven -y &>>$logfile
statusCheck $?
func_app_prereq
printHeader "Download Maven Dependencies"
mvn clean package &>>$logfile
mv target/"${component}"-1.0.jar "${component}".jar &>>$logfile
setupSchema
cp "$src_path"/"${component}".service /etc/systemd/system/
systemctl daemon-reload
funcEnableService
}
setupPython(){

  printHeader "Install Python"
  yum install python36 gcc python3-devel -y &>>$logfile
  statusCheck $?
  func_app_prereq
  printHeader "Install Python Dependencies"
  pip3.6 install -r requirements.txt &>>$logfile
  statusCheck $?
  cp "${src_path}"/"${component}".service /etc/systemd/system/ &>>$logfile
  systemctl daemon-reload
  funcEnableService
}
setupGolang(){
  cp "${component}".service /etc/systemd/system/
  printHeader "Install Golang"
  yum install golang -y &>>$logfile
  statusCheck $?
  func_app_prereq
  printHeader"Install App Dependencies"
  go mod init "${component}" &>>$logfile
  statusCheck $?
  go get &>>$logfile
  statusCheck $?
  go build  &>>$logfile
  statusCheck $?
  cp "${component}".service /etc/systemd/system/ &>>$logfile
  systemctl daemon-reload
  funcEnableService
}