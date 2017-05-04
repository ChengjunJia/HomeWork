#ifndef REGISTERDIALOG_H
#define REGISTERDIALOG_H

#include <QDialog>

class QString;

namespace Ui {
class RegisterDialog;
}

class RegisterDialog : public QDialog
{
    Q_OBJECT

public:
    explicit RegisterDialog(QWidget *parent = 0);
    ~RegisterDialog();
signals:
    void emitAccount(QString n,QString p);

private slots:
    void on_pushButton_clicked();
                                    //return the account information

private:
    Ui::RegisterDialog *ui;
};

#endif // REGISTERDIALOG_H
