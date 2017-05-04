#include <QSqlTableModel>
#include <QSqlDatabase>
#include <QtSql>
#include <QFile>
#include <QMessageBox>
#include <QProgressDialog>
#include <cstdlib>
#include <QSettings>
#include <QtWidgets>

#include "databasesinfo.h"

bool CreateAccountConnection()
{
    bool existingData = QFile::exists(data);
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(data);
    if (!db.open()) {
        QMessageBox::warning(0, QObject::tr("Database Error"),
                             db.lastError().text());
        return false;
    }
    if (!existingData){
    CreateDataBases();
    QSettings *setting=new QSettings(info,QSettings::IniFormat);
    setting->setValue(keyname_translated,keyvalue_nosure);
    setting->setValue(keyname_keep,keyvalue_yes);
    setting->setValue(keyname_accountname,keyvalue_nosure);
    delete setting;
    }

    return true;
}

void CreateDataBases()
{
       QProgressDialog progress;
       progress.setWindowModality(Qt::WindowModal);
       progress.setWindowTitle(QObject::tr("DataBase Manager"));
       progress.setLabelText(QObject::tr("Creating database..."));
       progress.setMinimum(0);
       progress.setMaximum(8);

       progress.setValue(1);
       qApp->processEvents();
       QSqlQuery query;
       query.exec("DROP TABLE account");
       query.exec("DROP TABLE commodity");
       query.exec("DROP TABLE order_record");

       progress.setValue(2);
       qApp->processEvents();
       query.exec("CREATE TABLE account ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "name VARCHAR(40) NOT NULL, "
                  "password VARCHAR(20) NOT NULL, "
                  "ppassword VARCHAR(40) NOT NULL, "
                  "kind INTEGER NOT NULL, "
                  "description VARCHAR(40))");
       //kind----0~supereditor;1~seller;2~purchasor

       progress.setValue(3);
       qApp->processEvents();
       query.exec("CREATE TABLE commodity ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "name VARCHAR(40) NOT NULL, "
                  "price VARCHAR(20) NOT NULL, "
                  "description VARCHAR(150), "
                  "kind VARCHAR(40) NOT NULL, "
                  "sellerid INTEGER NOT NULL, "
                  "FOREIGN KEY (sellerid) REFERENCES account)");

       progress.setValue(4);
       qApp->processEvents();
       query.exec("CREATE TABLE order_record ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "startdate DATE NOT NULL, "
                  "state VARCHAR(20) NOT NULL, "
                  "commodityid INTEGER NOT NULL, "
                  "buyerid INTEGER NOT NULL, "
                  "FOREIGN KEY (commodityid) REFERENCES commodity, "
                  "FOREIGN KEY (buyerid) REFERENCES account)");
       //state----1~backlog by the buyer,2~finished,3~deleted by the seller

       progress.setValue(5);
       qApp->processEvents();
       {
       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'jcjwjk','wjkjcj','jcjwjkwjkjcj',0)");

       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'seller','iwanttosell','sellsellsell',1)");
       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'Lenovo','iwanttosell','sellsellsell',1)");
       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'Amazon','iwanttosell','sellsellsell',1)");
       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'Tmall','iwanttosell','sellsellsell',1)");

       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'buyer01','iwanttobuy','buybuybuy',2)");
       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'buyer02','iwanttobuy','buybuybuy',2)");
       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'buyer03','iwanttobuy','buybuybuy',2)");
       query.exec("INSERT INTO account (name,password,ppassword,kind) VALUES ("
                  "'buyer04','iwanttobuy','buybuybuy',2)");

       }

       progress.setValue(6);
       qApp->processEvents();
       QStringList foodgood,drinkgood,sportgood,othergood;
       foodgood<<"Apple"<<"Bread"<<"Pie"<<"Chicken"<<"Egg"<<"Surprise";
       drinkgood<<"Coke"<<"Juice"<<"Water"<<"Milk"<<"Coco"<<"Surprise";
       sportgood<<"Basketball"<<"Football"<<"Table Tennis"<<"Baseball"<<"Surprise";
       othergood<<"Book"<<"Clothes";

       query.prepare("INSERT INTO commodity (name,price,description,kind,sellerid) "
                             "VALUES (:name,:price, :description, :kind, :sellerid)");
       foreach (QString name, foodgood) {
                   query.bindValue(":name", name);
                   query.bindValue(":price",1+std::rand()%30);
                   query.bindValue(":description", "I am lazy and do not want to describe it!");
                   query.bindValue(":kind", "Food");
                   query.bindValue(":sellerid", 2+std::rand()%4);
                   query.exec();
               }
       foreach (QString name, drinkgood) {
                   query.bindValue(":name", name);
                   query.bindValue(":price",1+std::rand()%10);
                   query.bindValue(":description", "I am lazy and do not want to describe it!");
                   query.bindValue(":kind", "Drink");
                   query.bindValue(":sellerid", 2+std::rand()%4);
                   query.exec();
               }
       foreach (QString name, sportgood) {
                   query.bindValue(":name", name);
                   query.bindValue(":price",50+std::rand()%100);
                   query.bindValue(":description", "I am lazy and do not want to describe it!");
                   query.bindValue(":kind", "Sport");
                   query.bindValue(":sellerid", 2+std::rand()%4);
                   query.exec();
               }
       foreach (QString name, othergood) {
                   query.bindValue(":name", name);
                   query.bindValue(":price",1+std::rand()%50);
                   query.bindValue(":description", "I am lazy and do not want to describe it!");
                   query.bindValue(":kind", "Other");
                   query.bindValue(":sellerid", 2+std::rand()%4);
                   query.exec();
               }

       query.prepare("INSERT INTO order_record (startdate,state,commodityid,buyerid)"
                     "VALUES (:startdate, :state, :commodityid, :buyerid)");
          for(int i=0;i<100;i++)
          {
              query.bindValue(":startdate",QDate::currentDate().addDays(-(std::rand() % 800)));
              switch(1+std::rand()%3)
              {
               case 1:query.bindValue(":state","Finished");break;
               case 2:query.bindValue(":state","Deleted-buyer");break;
               case 3:query.bindValue(":state","New");break;
              default:break;
              }

              query.bindValue(":commodityid",1+std::rand()%19);
              query.bindValue(":buyerid",6+std::rand()%4);
              query.exec();
          }

       /*QTableView *a=new QTableView;
       QTableView *b=new QTableView;
       QTableView *c=new QTableView;
       QSqlTableModel *a0=new QSqlTableModel;
       a0->setTable("account");
       a0->select();
       a->setModel(a0);
       a->show();
       QSqlTableModel *c0=new QSqlTableModel;
       c0->setTable("commodity_type");
       c0->select();
       c->setModel(c0);
       c->show();

       QSqlTableModel *b0=new QSqlTableModel;
       b0->setTable("order_record");
       b0->select();
       b->setModel(b0);
       b->show();*/


       progress.setValue(progress.maximum());
       qApp->processEvents();
}
