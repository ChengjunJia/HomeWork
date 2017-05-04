#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "finddialog.h"
#include <QMainWindow>

class QString;
class QSqlRelationalTableModel;
class QSqlRecord;
class QSqlTableModel;
class QTableView;
class QLabel;
class QVBoxLayout;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(int accountid,QWidget *parent = 0);
    ~MainWindow();

private slots:
    void advance();
    void actionadd();
    void actiondelete();
    void find();
    void help();
    void allshow();
    void Logout();
    void changepsd();
    void actiondeletecommodity();
    void actioninfo();

private:
    Ui::MainWindow *ui;
    bool maybesave();
    bool savefile(const QString &filename);
    QSqlRecord *accountinfo;
    QSqlRelationalTableModel *CommodityInfoModel;
    QSqlRelationalTableModel *OrderInfoModel;
    QSqlTableModel *temp;
    int accountkind;
    QTableView *CommodityInfoView;
    QTableView *OrderInfoView;
    QLabel *CommodityInfoLabel;
    QLabel *OrderInfoLabel;
    QVBoxLayout *layout;
    QPushButton *addButton;
    QPushButton *deleteButton;
    QStatusBar *statusbar;
};

#endif // MAINWINDOW_H
