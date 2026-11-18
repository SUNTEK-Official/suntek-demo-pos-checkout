#ifndef PRINTERMANAGER_H
#define PRINTERMANAGER_H

#include <QObject>
#include <QString>
#include "posdllloader.h"

class PrinterManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString portName READ portName WRITE setPortName NOTIFY portNameChanged)
    Q_PROPERTY(int portType READ portType WRITE setPortType NOTIFY portTypeChanged)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionStatusChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)

public:
    explicit PrinterManager(QObject *parent = nullptr);
    ~PrinterManager();


    QString portName() const { return m_portName; }
    void setPortName(const QString &portName);
    
    int portType() const { return m_portType; }
    void setPortType(int portType);
    
    bool isConnected() const { return m_hPrinter > 0; }
    
    QString lastError() const { return m_lastError; }


    Q_INVOKABLE bool initialize();
    Q_INVOKABLE bool connectPrinter();
    Q_INVOKABLE bool disconnectPrinter();
    Q_INVOKABLE bool printTestPage();
    Q_INVOKABLE bool printText(const QString &text);
    Q_INVOKABLE bool printBitmap(const QString &filePath);
    Q_INVOKABLE bool cutPaper(int type = 0, int lines = 3);
    Q_INVOKABLE bool openCashDrawer(int port = 1, int time1 = 100, int time2 = 100);
    Q_INVOKABLE int queryStatus();

signals:
    void portNameChanged();
    void portTypeChanged();
    void connectionStatusChanged();
    void lastErrorChanged();

private:

    POSDllLoader *m_dllLoader; // DLL
    LONG m_hPrinter;
    QString m_portName;
    int m_portType;
    QString m_lastError;
    

    void setLastError(const QString &error);
    

    QString errorCodeToString(int errorCode);
};

#endif // PRINTERMANAGER_H
