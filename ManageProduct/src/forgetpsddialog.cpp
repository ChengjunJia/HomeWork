#include <QSqlTableModel>
#include <QSqlRecord>
#include <QMessageBox>

#include "forgetpsddialog.h"
#include "ui_forgetpsddialog.h"
#include "resetpassworddialog.h"
#include "databasesinfo.h"

ForgetPsdDialog::ForgetPsdDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ForgetPsdDialog)
{
    ui->setupUi(this);
    ui->Name->setFocus();
}

ForgetPsdDialog::~ForgetPsdDialog()
{
    delete ui;
    delete currentmodel;
}

void ForgetPsdDialog::on_pushButton_clicked()
{
    const QString name=ui->Name->text();
    const QString ppassword=ui->PPassword->text();
    currentmodel=new QSqlTableModel;
    currentmodel->setTable("account");
    currentmodel->setFilter(QObject::tr("name = '%1'").arg(name));
    currentmodel->select();
   if(1 == currentmodel->rowCount() && ppassword == currentmodel->record(0).value(Account_Ppassword).toString()){
       ResetPasswordDialog* temp=new ResetPasswordDialog(currentmodel->record(0).value(Account_Id).toString());
       connect(temp,SIGNAL(ResetFinish()),this,SLOT(ResetOK()));
       temp->show();
   }
   else{
       QMessageBox::warning(this,tr("ERROR!"),tr("The inforamtion is not correct!"),QMessageBox::Yes);
   }
}

void ForgetPsdDialog::ResetOK(){
    this->close();
}
