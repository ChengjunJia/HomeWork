#ifndef HOMEMAINWINDOW_H
#define HOMEMAINWINDOW_H

#include <QMainWindow>

class QAction;
class QLabel;
class Spreadsheet;
class QSqlRecord;
class QSqlTableModel;
namespace Ui {
class HomeMainWindow;
}

class HomeMainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit HomeMainWindow(QString accountid,QWidget *parent = 0);
    ~HomeMainWindow();

private:
    Ui::HomeMainWindow *ui;
    QSqlRecord *account;
    QSqlTableModel *model;

private slots:
    void Accountinformation();
    void Accountsetting();
    void Accountquit();
    void Editfind();
    void Editsort();
};

#endif // HOMEMAINWINDOW_H
