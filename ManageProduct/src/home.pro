QT       += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = home
TEMPLATE = app
QT       += sql
TRANSLATIONS += xxx.ts
SOURCES += main.cpp\
    logindialog.cpp \
    registerdialog.cpp \
    databasesinfo.cpp \
    forgetpsddialog.cpp \
    resetpassworddialog.cpp \
    mainwindow.cpp \
    finddialog.cpp \
    editdialog.cpp

HEADERS  += \
    logindialog.h \
    registerdialog.h \
    databasesinfo.h \
    forgetpsddialog.h \
    resetpassworddialog.h \
    mainwindow.h\
 finddialog.h \
    editdialog.h

FORMS    += \
    logindialog.ui \
    registerdialog.ui \
    forgetpsddialog.ui \
    resetpassworddialog.ui \
    mainwindow.ui\
finddialog.ui \
    editdialog.ui


RESOURCES += \
    images.qrc

DISTFILES += \
    qthome.rc
RC_FILE = \
    qthome.rc
