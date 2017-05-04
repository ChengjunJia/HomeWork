#include "registerdialog.h"
#include "ui_registerdialog.h"
#include "databasesinfo.h"
#include <QMessageBox>
#include <QtSql>
#include <QTableView>

RegisterDialog::RegisterDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::RegisterDialog)
{
    ui->setupUi(this);
    ui->Name->setFocus();
}

RegisterDialog::~RegisterDialog()
{
    delete ui;
}

void RegisterDialog::on_pushButton_clicked()
{
    QString Name=ui->Name->text();
    QString Psd=ui->Pwd->text();
    QString Psd2=ui->Pwd2->text();
    QString PPsd=ui->PPwd->text();
    int thiskind=ui->comboBox->currentIndex()+1;
    QSqlTableModel model;
    model.setTable("account");
    model.setFilter(QObject::tr("name = '%1'").arg(Name));
    model.select();

    /*QTableView *view=new QTableView;
    view->setModel(&model);
    view->show();*/

    if(Psd!=Psd2){
        QMessageBox::warning(this,tr("ERROR!"),
                             tr("The passwords you entered are not same!Please input again!"),
                             QMessageBox::Yes);
        return;
    }
    else if(Psd.size()<6){
        QMessageBox::warning(this,tr("ERROR!"),
                             tr("The password is too simple!Please change it!"),
                             QMessageBox::Yes);
        return;
    }
    else if(1<=model.rowCount()){
        //read the document and judge if it is included?
        QMessageBox::warning(this,tr("ERROR!"),
                             tr("The Account has been registered!"),
                             QMessageBox::Yes);
        emit emitAccount("","");
        return;
    }
    else{
        QSqlTableModel model;
        model.setTable("account");
        QSqlRecord record = model.record();
        record.setValue(Account_Name,Name);
        record.setValue(Account_Password,Psd);
        record.setValue(Account_Ppassword,PPsd);
        record.setValue(Account_Kind,thiskind);
        //???thiskind number not sure?
        model.insertRecord(model.rowCount(),record);
        model.submitAll();
        emit emitAccount(Name,Psd);//保存账号
        QMessageBox::warning(this,tr("CORRECT!"),
                             tr("The Account is registered!"),
                             QMessageBox::Yes);
        //显示对话框——注册成功！
        this->close();
        //Close the window
    }
}
