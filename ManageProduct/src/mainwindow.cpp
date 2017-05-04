#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "finddialog.h"
#include "editdialog.h"
#include "databasesinfo.h"
#include "logindialog.h"
#include "forgetpsddialog.h"

#include <QStatusBar>
#include <QMessageBox>
#include <QTextStream>
#include <QtSql>
#include <QLabel>
#include <QTableView>
#include <QLayout>
#include <QSplitter>
#include <QInputDialog>

MainWindow::MainWindow(int accountid,QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    temp=new QSqlTableModel;
    temp->setTable("account");
    temp->setFilter(tr("id='%1'").arg(accountid));
    temp->select();
    accountinfo=new QSqlRecord(temp->record(0));
    accountkind=accountinfo->value(Account_Kind).toInt();

    statusbar=ui->statusBar;
    statusbar->addAction(ui->actionAccount);
    statusbar->addAction(ui->actionDelete_Commodity);
    statusbar->addAction(ui->actionHelp);
    statusbar->addAction(ui->actionAdd);
    statusbar->addAction(ui->actionDelete);
    statusbar->addAction(ui->actionLogout);
    statusbar->addAction(ui->actionpsd);
    statusbar->addAction(ui->actionAdvance);

    ui->actionAdvance->setStatusTip(tr("Adance Setting"));
    connect(ui->actionAdvance,SIGNAL(triggered()),this,SLOT(advance()));

    ui->actionAccount->setStatusTip(tr("look at the account info"));
    connect(ui->actionAccount,SIGNAL(triggered()),this,SLOT(actioninfo()));

    ui->actionDelete_Commodity->setStatusTip(tr("delete the commodity----only used by a seller"));
    connect(ui->actionDelete_Commodity,SIGNAL(triggered()),this,SLOT(actiondeletecommodity()));

    ui->actionpsd->setStatusTip(tr("change the password"));
    connect(ui->actionpsd,SIGNAL(triggered()),this,SLOT(changepsd()));

    ui->actionFind->setStatusTip(tr("find what"));
    connect(ui->actionFind,SIGNAL(triggered()),this,SLOT(find()));

    if(AccountKind::buyer==accountkind)
        ui->actionAdd->setStatusTip(tr("select a commodity and then add an order"));
    else
        ui->actionAdd->setStatusTip(tr("add an commodity and edit it"));
    connect(ui->actionAdd,SIGNAL(triggered()),this,SLOT(actionadd()));

    ui->actionDelete->setStatusTip(tr("delete the order"));
    connect(ui->actionDelete,SIGNAL(triggered()),this,SLOT(actiondelete()));

    ui->actionHelp->setStatusTip(tr("look at the help information"));
    connect(ui->actionHelp,SIGNAL(triggered()),this,SLOT(help()));

    ui->actionClose->setStatusTip(tr("close the windows"));
    connect(ui->actionClose,SIGNAL(triggered()),this,SLOT(close()));

    ui->actionLogout->setStatusTip(tr("Logout and change the account"));
    connect(ui->actionLogout,SIGNAL(triggered()),this,SLOT(Logout()));

    CommodityInfoModel=new QSqlRelationalTableModel(this);
    CommodityInfoView=new QTableView(this);
    CommodityInfoLabel=new QLabel(tr("&Commodity"));
    CommodityInfoLabel->setBuddy(CommodityInfoView);
    CommodityInfoView->setModel(CommodityInfoModel);

    OrderInfoModel=new QSqlRelationalTableModel(this);
    OrderInfoView=new QTableView(this);
    OrderInfoLabel=new QLabel(tr("&order"));
    OrderInfoLabel->setBuddy(OrderInfoView);
    OrderInfoView->setModel(OrderInfoModel);

    allshow();

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::Logout()
{
    LoginDialog *a=new LoginDialog;
    a->show();
    this->close();
}

void MainWindow::changepsd()
{
    ForgetPsdDialog *a=new ForgetPsdDialog;
    a->show();
}

void MainWindow::actioninfo()
{
    QMessageBox::about(this, tr("Account Info"),
                       tr("Here we will show your information\n "
                          "The username is '%1',\n"
                          "the kind of your account is '%2'.").arg(accountinfo->value(Account_Name).toString(),
                          (accountinfo->value(Account_Kind)==(AccountKind::buyer))?"buyer":"seller"));
}

void MainWindow::actionadd()
{
    if(AccountKind::buyer==accountkind)
    {
       QModelIndex index=CommodityInfoView->currentIndex();
       if(!index.isValid()){
           QMessageBox::warning(this,
                             tr("ERROR!"),tr("Donot select commodity"),QMessageBox::Yes);
           return;
       }
       if(QMessageBox::Yes==QMessageBox::warning(this,
                  tr("Question"),tr("Use the selected commodity"),QMessageBox::Yes))
       {
           QSqlRecord record=CommodityInfoModel->record(index.row());
           int commodityid=record.value(Commodity_Id).toInt();
       QSqlQuery *query=new QSqlQuery;
       query->prepare("INSERT INTO order_record (startdate,state,commodityid,buyerid)"
                   "VALUES (:startdate, :state, :commodityid, :buyerid)");
       query->bindValue(":startdate",QDate::currentDate().currentDate());
       query->bindValue(":state","new");
       query->bindValue(":commodityid",commodityid);
       query->bindValue(":buyerid",accountinfo->value(Account_Id).toInt());
       query->exec();
       }
       allshow();
    }
    if(AccountKind::Adimistor==accountkind||AccountKind::seller==accountkind)
    {
        int row=CommodityInfoModel->rowCount();
        CommodityInfoModel->insertRow(row);
        if(AccountKind::seller==accountkind)
            {
            CommodityInfoModel->setData(CommodityInfoModel->index(row,Commodity_sellerid),
                                        accountinfo->value(Account_Id).toInt());
            }
        QModelIndex index=CommodityInfoModel->index(row,Commodity_Name);
        CommodityInfoView->setCurrentIndex(index);
        CommodityInfoView->edit(index);
    }

}

void MainWindow::actiondelete()
{
    if(QMessageBox::Yes != QMessageBox::warning(this,tr("Delete?"),
                            tr("Do you really want to delete it?"),QMessageBox::Yes))
        return;
    QModelIndex index=OrderInfoView->currentIndex();
    if(!index.isValid()&&AccountKind::buyer==accountkind){
        QMessageBox::warning(this,tr("ERROR!"),tr("You should choose an order"),QMessageBox::Yes);
         return;
    }
    else if(index.isValid())
    {
        QSqlRecord record=OrderInfoModel->record(index.row());
        int id=record.value(Order_Id).toInt();
        temp->setTable("order_record");
        temp->setFilter(tr("id=%1").arg(id));
        temp->select();
        /*QTableView *atempview=new QTableView;
        atempview->setModel(temp);
        atempview->show();*/

        if(temp->rowCount()<1){
            QMessageBox::warning(this,tr("ERROR!"),tr("No Find the order!"),QMessageBox::Yes);
            return;
        }
        else{
            QSqlRecord record=temp->record(0);
            if(AccountKind::buyer==accountkind){
            record.setValue(Order_State,"Deleted-buyer");
            }
            else if(AccountKind::seller==accountkind){
                record.setValue(Order_State,"Deleted-seller");
            }
            else if(AccountKind::Adimistor==accountkind){
                record.setValue(Order_State,"Deleted-adimistor");
            }
            temp->setRecord(0,record);
            bool resultjudge=temp->submitAll();
            allshow();
            if(!resultjudge)
                QMessageBox::warning(this,tr("ERROR!"),tr("Cannot delete!We donot know why!"),QMessageBox::Yes);

           /* QSqlTableModel *test=new QSqlTableModel;
            QTableView *testview=new QTableView;
            test->setTable("order_record");
            test->select();
            testview->setModel(test);
            testview->show();
            OrderInfoModel->setTable("order_record");
            OrderInfoModel->select();
            OrderInfoModel->submitAll();*/
        }
   }
}

void MainWindow::find()
{
    FindDialog *a=new FindDialog;
    a->show();
}

void MainWindow::advance()
{
    EditDialog *a=new EditDialog;
    a->show();
}

void MainWindow::actiondeletecommodity()
{
     //QMessageBox::warning(this,tr("ERROR!"),tr("remove the commodity1!"),QMessageBox::Yes);
    if(accountinfo->value(Account_Id)==AccountKind::buyer){
        QMessageBox::warning(this,tr("ERROR!"),tr("You can not do this!"),QMessageBox::Yes);
        return;
    }
    else{
        QModelIndex index=CommodityInfoView->currentIndex();
        if(!index.isValid()){
            QMessageBox::warning(this,tr("ERROR!"),tr("You should choose a commodity"),QMessageBox::Yes);
             return;
        }
        else
        {
            QMessageBox::warning(this,tr("ERROR!"),tr("remove the commodity2!"),QMessageBox::Yes);
            QSqlRecord record=CommodityInfoModel->record(index.row());
            int id=record.value(Commodity_Id).toInt();
            temp->setTable("commodity");
            temp->setFilter(tr("id=%1").arg(id));
            temp->select();
            if(temp->rowCount()<1){
                QMessageBox::warning(this,tr("ERROR!"),tr("No Find the commodity!"),QMessageBox::Yes);
                return;
            }
            else{
                temp->removeRow(0);
                bool resultjudge=temp->submitAll();
                allshow();
                if(!resultjudge)
                    QMessageBox::warning(this,tr("ERROR!"),tr("Cannot delete!We donot know why!"),QMessageBox::Yes);

               /*QSqlTableModel *test=new QSqlTableModel;
                QTableView *testview=new QTableView;
                test->setTable("commodity");
                test->select();
                testview->setModel(test);
                testview->show();
                QMessageBox::warning(this,tr("ERROR!"),tr("remove the commodity!"),QMessageBox::Yes);*/

            }
       }
    }
}

void MainWindow::allshow()
{
    CommodityInfoModel->setTable("commodity");
    if(AccountKind::seller==accountkind){
        CommodityInfoModel->setFilter(tr("commodity.sellerid='%1'").arg(accountinfo->value(Account_Id).toString()));
    }

    CommodityInfoModel->setRelation(Commodity_sellerid, QSqlRelation("account","id","name"));
    CommodityInfoModel->setSort(Commodity_Name,Qt::AscendingOrder);
    CommodityInfoModel->setHeaderData(Commodity_Name,Qt::Horizontal,tr("Name"));
    CommodityInfoModel->setHeaderData(Commodity_Price,Qt::Horizontal,tr("Price"));
    CommodityInfoModel->setHeaderData(Commodity_Kind,Qt::Horizontal,tr("Kind"));
    CommodityInfoModel->setHeaderData(Commodity_Description,Qt::Horizontal,tr("Describe"));
    CommodityInfoModel->setHeaderData(Commodity_sellerid,Qt::Horizontal,tr("seller"));
    CommodityInfoModel->select();

    CommodityInfoView->setItemDelegate(new QSqlRelationalDelegate(this));
    CommodityInfoView->setSelectionMode(QAbstractItemView::SingleSelection );
    CommodityInfoView->setSelectionBehavior(QAbstractItemView::SelectRows);
    CommodityInfoView->setColumnHidden(Commodity_Id,true);
    CommodityInfoView->resizeColumnsToContents();
    CommodityInfoView->horizontalHeader()->setStretchLastSection(true);
    CommodityInfoView->verticalHeader()->setStretchLastSection(true);

    if(AccountKind::buyer==accountkind){
        CommodityInfoView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    }
    if(AccountKind::seller==accountkind){
        CommodityInfoView->setColumnHidden(Commodity_sellerid,true);
    }
    CommodityInfoModel->submitAll();
    CommodityInfoView->show();

    OrderInfoModel->setTable("order_record");
    if(AccountKind::seller==accountkind){
        QString allcommodity;
        int CommodityId=CommodityInfoModel->record(0).indexOf("id");
        allcommodity=tr("order_record.commodityid='%1'").arg(CommodityInfoModel->record(0).value(CommodityId).toString());
        for(int i=1;i<(CommodityInfoModel->rowCount());i++)
            allcommodity +=tr("OR order_record.commodityid='%1'").arg(CommodityInfoModel->record(i).value(CommodityId).toString());
        OrderInfoModel->setFilter(allcommodity);
    }
    else if(AccountKind::buyer==accountkind){
        OrderInfoModel->setFilter(tr("order_record.buyerid='%1'").arg(accountinfo->value(Account_Id).toString()));
    }
    OrderInfoModel->setRelation(Order_Commodityid,QSqlRelation("commodity","id","name"));
    OrderInfoModel->setRelation(Order_buyerid,QSqlRelation("account","id","name"));
    OrderInfoModel->setSort(Order_Startdate,Qt::AscendingOrder);
    OrderInfoModel->setHeaderData(Order_Startdate,Qt::Horizontal,tr("Date"));
    OrderInfoModel->setHeaderData(Order_Commodityid,Qt::Horizontal,tr("Commodity"));
    OrderInfoModel->setHeaderData(Order_buyerid,Qt::Horizontal,tr("buyer"));
    OrderInfoModel->setHeaderData(Order_State,Qt::Horizontal,tr("State"));
    OrderInfoModel->select();

    OrderInfoView->setItemDelegate(new QSqlRelationalDelegate(this));
    OrderInfoView->setSelectionMode(QAbstractItemView::SingleSelection );
    OrderInfoView->setSelectionBehavior(QAbstractItemView::SelectRows);
    OrderInfoView->setColumnHidden(Order_Id,true);
    OrderInfoView->resizeColumnsToContents();
    OrderInfoView->horizontalHeader()->setStretchLastSection(true);
    OrderInfoView->verticalHeader()->setStretchLastSection(true);
    OrderInfoView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    OrderInfoModel->submitAll();
    OrderInfoView->show();

    ui->formLayout->addWidget(CommodityInfoLabel);
    ui->formLayout->addWidget(CommodityInfoView);
    ui->formLayout->addWidget(OrderInfoLabel);
    ui->formLayout->addWidget(OrderInfoView);
}

void MainWindow::help()
{
    QMessageBox::about(this, tr("About app"),
                       tr("Here we will show you how to "
                          "use this app.\n"
                          "The information about each button is showed at the end of the window."));
}
