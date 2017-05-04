#include <QSqlRecord>
#include <QTableView>
#include <QSqlTableModel>
#include <QTableView>
#include <QMessageBox>
#include <QDebug>

#include "resetpassworddialog.h"
#include "ui_resetpassworddialog.h"
#include "databasesinfo.h"

ResetPasswordDialog::ResetPasswordDialog(QString temp,QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ResetPasswordDialog)
{
    ui->setupUi(this);
    ui->lineEdit->setFocus();
    model=new QSqlTableModel;
    model->setTable("account");
    model->setFilter(tr("id='%1'").arg(temp));
    model->select();
    /*QTableView *b=new QTableView;
    b->setModel(model);
    b->show();*/
}

ResetPasswordDialog::~ResetPasswordDialog()
{
    delete ui;
}

void ResetPasswordDialog::on_pushButton_clicked()
{
    if(ui->lineEdit->text()==ui->lineEdit_2->text()){
        QString temp = ui->lineEdit->text();
        QSqlRecord record=model->record(0);
        record.setValue(Account_Password,temp);
        model->setRecord(0,record);
        model->submitAll();

        /*QTableView *b=new QTableView;
        b->setModel(model);
        b->show();
        QMessageBox::warning(this,"",model->record(0).value("password").toString(),QMessageBox::Yes);*/

        emit ResetFinish();
        this->close();
    }
    else{
        ui->label_3->setText(tr("The password and the password again are not the same!"));
    }

}
