#ifndef FORGETPSDDIALOG_H
#define FORGETPSDDIALOG_H

#include <QDialog>
class QSqlTableModel;

namespace Ui {
class ForgetPsdDialog;
}

class ForgetPsdDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ForgetPsdDialog(QWidget *parent = 0);
    ~ForgetPsdDialog();

private slots:
    void on_pushButton_clicked();
    void ResetOK();
private:
    Ui::ForgetPsdDialog *ui;
    QSqlTableModel *currentmodel;
};

#endif // FORGETPSDDIALOG_H
