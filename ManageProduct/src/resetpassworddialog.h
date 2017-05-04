#ifndef RESETPASSWORDDIALOG_H
#define RESETPASSWORDDIALOG_H

#include <QDialog>
class QSqlRecord;
class QSqlTableModel;
namespace Ui {
class ResetPasswordDialog;
}

class ResetPasswordDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ResetPasswordDialog(QString temp,QWidget *parent = 0);
    ~ResetPasswordDialog();

signals:
    void ResetFinish();
private slots:
    void on_pushButton_clicked();

private:
    QSqlTableModel *model;
    QSqlRecord* account;
    Ui::ResetPasswordDialog *ui;
};

#endif // RESETPASSWORDDIALOG_H
