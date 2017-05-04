#include <QString>
#include <QtSql>
#include <QMessageBox>

#include "logindialog.h"
#include "ui_logindialog.h"
#include "registerdialog.h"
#include "databasesinfo.h"
#include "forgetpsddialog.h"
#include "mainwindow.h"

LoginDialog::LoginDialog(QWidget *parent):
    QDialog(parent),
    ui(new Ui::LoginDialog)
{
    ui->setupUi(this);
    ui->lineEdit->setFocus();
    QSettings *setting=new QSettings(info,QSettings::IniFormat);
    if(setting->value(keyname_keep)==keyvalue_yes)
    {
        ui->lineEdit->setText(setting->value(keyname_accountname).toString());
    }
    delete setting;
}

LoginDialog::~LoginDialog()
{
    delete ui;
}

void LoginDialog::on_pushButton_clicked()
{
    if(judge()==true){
        MainWindow *temp=new MainWindow(account->value(Account_Id).toInt());
        temp->show();
        this->close();                              //login success and close the loginwindow!
    }
    else{
            ui->lineEdit->setFocus();               //鼠标回到用户名栏
    }
}
//Login

bool LoginDialog::judge()
{
    const QString name=ui->lineEdit->text();
    const QString password=ui->lineEdit_2->text();
    QSqlTableModel modeltemp;
    modeltemp.setTable("account");
    modeltemp.setFilter(QObject::tr("name = '%1'").arg(name));
    modeltemp.select();
    if(0==modeltemp.rowCount()){
        QMessageBox::warning(this,tr("ERROR!"),tr("The username does not exist!"),QMessageBox::Yes);
        return false;
    }
    else if(password==modeltemp.record(0).value(Account_Password)){
        account=new QSqlRecord(modeltemp.record(0));
        QSettings *setting=new QSettings(info,QSettings::IniFormat);
        if(setting->value(keyname_keep)==keyvalue_yes)
             setting->setValue(keyname_accountname,name);
        delete setting;
        return true;
    }
    else{
        QMessageBox::warning(this,tr("ERROR!"),tr("The password is not correct!"),QMessageBox::Yes);
        return false;
    }
}
//judge the username and password is correct?

void LoginDialog::SetAccount(QString n,QString p)
{
    ui->lineEdit->setText(n);
    ui->lineEdit_2->setText(p);
    ui->pushButton->setFocus();
}
//put the register information in the dialog and focus on "loginin" pushbutton

void LoginDialog::on_pushButton_3_clicked()
{
    ForgetPsdDialog *temp=new ForgetPsdDialog;
    temp->show();
}
//forget the password

void LoginDialog::on_pushButton_4_clicked()
{
    RegisterDialog *a=new RegisterDialog();
    connect(a,SIGNAL(emitAccount(QString,QString)),this,SLOT(SetAccount(QString,QString)));
    a->show();
    a->exec();
}
//No Account, turn to register
