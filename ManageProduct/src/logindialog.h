#ifndef LOGINDIALOG_H
#define LOGINDIALOG_H

#include <QDialog>

class QString;
class QSqlRecord;

namespace Ui {
class LoginDialog;
}

class LoginDialog : public QDialog
{
    Q_OBJECT

public:
    explicit LoginDialog(QWidget *parent = 0);
    ~LoginDialog();
    //return the account information

private slots:
    void SetAccount(QString n,QString p);
    void on_pushButton_clicked();           //login pushbutton
    void on_pushButton_3_clicked();         //register pushbutton
    void on_pushButton_4_clicked();

private:
    Ui::LoginDialog *ui;
    bool judge();                               //需要调用一个数据库，用于检验数据内容
    QSqlRecord *account;
};

#endif // LOGINDIALOG_H
