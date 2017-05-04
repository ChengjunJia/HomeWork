#include "homemainwindow.h"
#include "logindialog.h"
#include "registerdialog.h"
#include "databasesinfo.h"

#include <QApplication>
#include <QTextCodec>
#include <QTranslator>
#include <QtSql>
#include <QtWidgets>
#include <QStyle>
#include <QtGui>

int main(int argc, char *argv[])
{

    //waiting picture
    QApplication a(argc, argv);
    a.addLibraryPath("./plugins");
    QSettings *temp=new QSettings(info,QSettings::IniFormat);
    if((temp->value(keyname_translated)==keyvalue_yes)  ||
       ( (temp->value(keyname_translated)==keyvalue_nosure)  &&
        (QMessageBox::warning(0,"Use the Chinese?",
         "If you want your programme uses Chinese,Please click Yes",
                              QMessageBox::Yes,QMessageBox::No)==QMessageBox::Yes)  ) )
    {
        QTranslator *qtTranslator=new QTranslator;
        qtTranslator->load("xxx");
        a.installTranslator(qtTranslator);
    }

    CreateAccountConnection();
    LoginDialog d;
    d.show();
    //login windows

    return a.exec();
}
