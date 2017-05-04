#ifndef DATABASESINFO_H
#define DATABASESINFO_H
#include <QString>
bool CreateAccountConnection();
void CreateDataBases();

const QString data="database.dat";
const QString info="setting.ini";
const QString keyname_translated="start/translate";
const QString keyname_keep="start/keep";
const QString keyname_accountname="start/name";
const QString keyvalue_yes="yes";
const QString keyvalue_no="no";
const QString keyvalue_nosure="nosure";

enum{
    Commodity_Id=0,
    Commodity_Name=1,
    Commodity_Price=2,
    Commodity_Description=3,
    Commodity_Kind=4,
    Commodity_sellerid=5
};
enum{
    Account_Id=0,
    Account_Name=1,
    Account_Password=2,
    Account_Ppassword=3,
    Account_Kind=4,
    Account_Descripton=5
};
enum{
    Order_Id=0,
    Order_Startdate=1,
    Order_State=2,
    Order_Commodityid=3,
    Order_buyerid=4
};
enum AccountKind{
    Adimistor=0,
    seller=1,
    buyer=2
};

#endif // ACCOUNTINFO

