#include "printermanager.h"
#include <QDebug>

PrinterManager::PrinterManager(QObject *parent) : 
    QObject(parent), 
    m_dllLoader(nullptr),
    m_hPrinter(0),
    m_portName("COM1:9600,N,8,1"),
    m_portType(POS_PT_COM) // POS_PT_COM
{
    m_dllLoader = new POSDllLoader();
}

PrinterManager::~PrinterManager()
{
    disconnectPrinter();
    delete m_dllLoader;
}

void PrinterManager::setPortName(const QString &portName)
{
    if (m_portName != portName) {
        m_portName = portName;
        emit portNameChanged();
    }
}

void PrinterManager::setPortType(int portType)
{
    if (m_portType != portType) {
        m_portType = portType;
        

        switch (portType) {
        case POS_PT_COM:
            setPortName("COM1:9600,N,8,1");
            break;
        case POS_PT_LPT:
            setPortName("LPT1:");
            break;
        case POS_PT_USB:
            setPortName("SP-USB1");
            break;
        case POS_PT_NET:
            setPortName("192.0.2.10:9100");
            break;
        default:
            break;
        }
        
        emit portTypeChanged();
    }
}

void PrinterManager::setLastError(const QString &error)
{
    if (m_lastError != error) {
        m_lastError = error;
        qDebug() << "Printer Error:" << error;
        emit lastErrorChanged();
    }
}

QString PrinterManager::errorCodeToString(int errorCode)
{
    switch (errorCode) {
    case POS_ES_SUCCESS:
        return "操作成功";
    case POS_ES_INVALIDPARA:
        return "参数错误";
    case POS_ES_WRITEFAIL:
        return "写入失败";
    case POS_ES_OVERTIME:
        return "超时";
    case POS_ES_OTHERERRORS:
        return "其他错误";
    default:
        return QString("未知错误: %1").arg(errorCode);
    }
}

bool PrinterManager::initialize()
{
    if (!m_dllLoader->loadLibrary()) {
        setLastError("加载POS SDK失败，请确保POS_SDK.dll存在");
        return false;
    }
    
    setLastError("初始化成功");
    return true;
}

bool PrinterManager::connectPrinter()
{
    if (m_hPrinter > 0) {
        setLastError("打印机已经连接");
        return true;
    }

    if (!m_dllLoader->isLoaded() && !initialize()) {
        return false;
    }

 // ✅ toLocal8Bit() toUtf8()
    QByteArray portNameBytes = m_portName.toLocal8Bit();

 // ✅ szFilePath nullptr
    m_hPrinter = m_dllLoader->POS_Port_OpenA(
        portNameBytes.data(),
        m_portType,
        FALSE,
        nullptr
        );

    if (m_hPrinter <= 0) { // <= 0
        setLastError(QString("连接失败，错误码: %1 (%2)")
                         .arg(m_hPrinter).arg(errorCodeToString(m_hPrinter)));
        m_hPrinter = 0;
        return false;
    }

    setLastError("连接成功");
    emit connectionStatusChanged();
    return true;
}

bool PrinterManager::disconnectPrinter()
{
    if (m_hPrinter <= 0) {
        setLastError("打印机未连接");
        return false;
    }
    
    LONG ret = m_dllLoader->POS_Port_Close(m_hPrinter);
    m_hPrinter = 0;
    
    if (ret != POS_ES_SUCCESS) {
        setLastError(errorCodeToString(ret));
        return false;
    }
    
    setLastError("打印机断开连接成功");
    emit connectionStatusChanged();
    return true;
}

bool PrinterManager::printTestPage()
{
    if (m_hPrinter <= 0) {
        setLastError("请先连接打印机");
        return false;
    }
    
    LONG ret = m_dllLoader->POS_Control_PrintTestpage(m_hPrinter);
    if (ret != POS_ES_SUCCESS) {
        setLastError(QString("打印测试页失败: %1").arg(errorCodeToString(ret)));
        return false;
    }
    
    setLastError("测试页打印成功");
    return true;
}

bool PrinterManager::printText(const QString &text)
{
    if (m_hPrinter <= 0) {
        setLastError("请先连接打印机");
        return false;
    }
    

    QString printText = text + "\r\n";
    
 // Unicode
    LONG ret = m_dllLoader->POS_Output_PrintStringW(m_hPrinter, (LPCWSTR)printText.utf16());
    if (ret != POS_ES_SUCCESS) {
        setLastError(QString("打印文本失败: %1").arg(errorCodeToString(ret)));
        return false;
    }
    
    setLastError("文本打印成功");
    return true;
}

bool PrinterManager::printBitmap(const QString &filePath)
{
    if (m_hPrinter <= 0) {
        setLastError("请先连接打印机");
        return false;
    }
    
    LONG ret = m_dllLoader->POS_Output_PrintBmpDirectA(m_hPrinter, filePath.toUtf8().constData());
    if (ret != POS_ES_SUCCESS) {
        setLastError(QString("打印图片失败: %1").arg(errorCodeToString(ret)));
        return false;
    }
    
    setLastError("图片打印成功");
    return true;
}

bool PrinterManager::cutPaper(int type, int lines)
{
    if (m_hPrinter <= 0) {
        setLastError("请先连接打印机");
        return false;
    }
    
    LONG ret = m_dllLoader->POS_Control_CutPaper(m_hPrinter, type, lines);
    if (ret != POS_ES_SUCCESS) {
        setLastError(QString("切纸失败: %1").arg(errorCodeToString(ret)));
        return false;
    }
    
    setLastError("切纸成功");
    return true;
}

bool PrinterManager::openCashDrawer(int port, int time1, int time2)
{
    if (m_hPrinter <= 0) {
        setLastError("请先连接打印机");
        return false;
    }
    
    LONG ret = m_dllLoader->POS_Control_CashDraw(m_hPrinter, port, time1, time2);
    if (ret != POS_ES_SUCCESS) {
        setLastError(QString("打开钱箱失败: %1").arg(errorCodeToString(ret)));
        return false;
    }
    
    setLastError("钱箱打开成功");
    return true;
}

int PrinterManager::queryStatus()
{
    if (m_hPrinter <= 0) {
        setLastError("打印机未连接");
        return -1;
    }
    
 // POS_Status_QueryStatus
    LONG status = m_dllLoader->POS_Status_QueryStatus(m_hPrinter);
    

    if (status == -1) {
        setLastError("查询打印机状态失败");
        return -1;
    }
    
    setLastError("查询打印机状态成功");
    return status;
}
