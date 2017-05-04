#ifndef FINDDIALOG_H
#define FINDDIALOG_H

#include <QDialog>

class QSqlRelationalTableModel;
namespace Ui {
class FindDialog;
}

class FindDialog : public QDialog
{
    Q_OBJECT

public:
    explicit FindDialog(QWidget *parent = 0);
    ~FindDialog();

private slots:
    void findclicked();
    void enabledfind();

    void on_lineEdit_editingFinished();

private:
    Ui::FindDialog *ui;
    QSqlRelationalTableModel *CommodityInfoModel;
};

#endif // FINDDIALOG_H
