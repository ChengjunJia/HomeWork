#include "finddialog.h"
#include "ui_finddialog.h"
#include "databasesinfo.h"
#include <QSqlRelationalTableModel>
#include <QTableView>
#include <QSqlRelationalDelegate>
#include <QMessageBox>
#include <QtSql>
FindDialog::FindDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::FindDialog)
{
    ui->setupUi(this);
    CommodityInfoModel=new QSqlRelationalTableModel;
    connect(ui->lineEdit,SIGNAL(textChanged(QString)),this,SLOT(enabledfind()));
    connect(ui->find,SIGNAL(clicked()),this,SLOT(findclicked()));
    connect(ui->close,SIGNAL(clicked()),this,SLOT(close()));
}

FindDialog::~FindDialog()
{
    delete ui;
}

void FindDialog::enabledfind()
{
    ui->find->setEnabled(true);
}

void FindDialog::findclicked()
{
    QTableView *CommodityInfoView=new QTableView;
    CommodityInfoModel->setTable("commodity");
    CommodityInfoModel->setRelation(Commodity_sellerid, QSqlRelation("account","id","name"));
   if(ui->comboBox->currentIndex()==0){
     QString kind=ui->lineEdit->text();
     CommodityInfoModel->setFilter(tr("commodity.kind = '%1'").arg(kind));
     CommodityInfoModel->select();
     CommodityInfoModel->setSort(Commodity_Name,Qt::AscendingOrder);
    }
    else if(ui->comboBox->currentIndex()==1){
        QString name=ui->lineEdit->text();
        CommodityInfoModel->setFilter(tr("commodity.name = '%1'").arg(name));
        CommodityInfoModel->setSort(Commodity_Kind,Qt::AscendingOrder);
    }
    CommodityInfoModel->setHeaderData(Commodity_Name,Qt::Horizontal,tr("Name"));
    CommodityInfoModel->setHeaderData(Commodity_Price,Qt::Horizontal,tr("Price"));
    CommodityInfoModel->setHeaderData(Commodity_Kind,Qt::Horizontal,tr("Kind"));
    CommodityInfoModel->setHeaderData(Commodity_Description,Qt::Horizontal,tr("Describe"));
    CommodityInfoModel->setHeaderData(Commodity_sellerid,Qt::Horizontal,tr("seller"));
    CommodityInfoModel->select();

    /*QTableView *temp=new QTableView;
    temp->setModel(CommodityInfoModel);
    temp->show();*/
    CommodityInfoView->setModel(CommodityInfoModel);
    CommodityInfoView->setItemDelegate(new QSqlRelationalDelegate(this));
    CommodityInfoView->setSelectionMode(QAbstractItemView::SingleSelection );
    CommodityInfoView->setSelectionBehavior(QAbstractItemView::SelectRows);
    CommodityInfoView->setColumnHidden(Commodity_Id,true);
    CommodityInfoView->resizeColumnsToContents();
    CommodityInfoView->horizontalHeader()->setStretchLastSection(true);
    CommodityInfoView->verticalHeader()->setStretchLastSection(true);
    CommodityInfoView->show();
}

void FindDialog::on_lineEdit_editingFinished()
{
    if(!ui->lineEdit->text().isEmpty())
        enabledfind();
}
