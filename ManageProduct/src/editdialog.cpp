#include "editdialog.h"
#include "ui_editdialog.h"
#include <QSettings>
#include <QMessageBox>
#include "databasesinfo.h"

EditDialog::EditDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::EditDialog)
{
    ui->setupUi(this);
}

EditDialog::~EditDialog()
{
    delete ui;
}

void EditDialog::on_addButton_clicked()
{
    QSettings *a=new QSettings(info,QSettings::IniFormat);
    if(ui->comboBox_Account->currentIndex()==0)
        a->setValue(keyname_keep,keyvalue_yes);
    if(ui->comboBox_Account->currentIndex()==1)
        a->setValue(keyname_keep,keyvalue_no);
    if(ui->comboBox_Language->currentIndex()==0)
        a->setValue(keyname_translated,keyvalue_yes);
    if(ui->comboBox_Language->currentIndex()==1)
        a->setValue(keyname_translated,keyvalue_no);
    QMessageBox::warning(this,tr("Correct!"),tr("The setting is finished!"),QMessageBox::Yes);
    this->close();
}
