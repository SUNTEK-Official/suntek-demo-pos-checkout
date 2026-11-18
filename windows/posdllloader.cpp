#include "posdllloader.h"
#include <QDebug>

 // DLL
const char* POSDllLoader::DLL_PATH = "POS_SDK.dll";

POSDllLoader::POSDllLoader() : m_hInstance(nullptr)
{
 // nullptr
    POS_Port_OpenA = nullptr;
    POS_Port_OpenW = nullptr;
    POS_Output_PrintStringA = nullptr;
    POS_Output_PrintStringW = nullptr;
    POS_Output_PrintData = nullptr;
    POS_Port_Close = nullptr;
    POS_Control_CutPaper = nullptr;
    POS_Control_CashDraw = nullptr;
    POS_Status_QueryStatus = nullptr;
    POS_Output_PrintBmpDirectA = nullptr;
    POS_Output_PrintBarcodeA = nullptr;
    POS_Control_PrintTestpage = nullptr;
}

POSDllLoader::~POSDllLoader()
{
 // DLL
    freeLibrary();
}

bool POSDllLoader::loadLibrary()
{

    if (m_hInstance != nullptr) {
        return true;
    }

 // DLL - LoadLibraryA ANSI
    m_hInstance = LoadLibraryA(DLL_PATH);
    if (m_hInstance == nullptr) {
        qDebug() << "Failed to load POS_SDK.dll";
        return false;
    }

 // API
    POS_Port_OpenA = (POS_Port_OpenAFun)GetProcAddress(m_hInstance, "POS_Port_OpenA");
    if (POS_Port_OpenA == nullptr) {
        qDebug() << "Failed to get POS_Port_OpenA";
        goto ERR_END;
    }

    POS_Port_OpenW = (POS_Port_OpenWFun)GetProcAddress(m_hInstance, "POS_Port_OpenW");
    if (POS_Port_OpenW == nullptr) {
        qDebug() << "Failed to get POS_Port_OpenW";
        goto ERR_END;
    }

    POS_Output_PrintStringA = (POS_Output_PrintStringAFun)GetProcAddress(m_hInstance, "POS_Output_PrintStringA");
    if (POS_Output_PrintStringA == nullptr) {
        qDebug() << "Failed to get POS_Output_PrintStringA";
        goto ERR_END;
    }

    POS_Output_PrintStringW = (POS_Output_PrintStringWFun)GetProcAddress(m_hInstance, "POS_Output_PrintStringW");
    if (POS_Output_PrintStringW == nullptr) {
        qDebug() << "Failed to get POS_Output_PrintStringW";
        goto ERR_END;
    }

    POS_Output_PrintData = (POS_Output_PrintDataFun)GetProcAddress(m_hInstance, "POS_Output_PrintData");
    if (POS_Output_PrintData == nullptr) {
        qDebug() << "Failed to get POS_Output_PrintData";
        goto ERR_END;
    }

    POS_Port_Close = (POS_Port_CloseFun)GetProcAddress(m_hInstance, "POS_Port_Close");
    if (POS_Port_Close == nullptr) {
        qDebug() << "Failed to get POS_Port_Close";
        goto ERR_END;
    }

    POS_Control_CutPaper = (POS_Control_CutPaperFun)GetProcAddress(m_hInstance, "POS_Control_CutPaper");
    if (POS_Control_CutPaper == nullptr) {
        qDebug() << "Failed to get POS_Control_CutPaper";
        goto ERR_END;
    }

    POS_Control_CashDraw = (POS_Control_CashDrawFun)GetProcAddress(m_hInstance, "POS_Control_CashDraw");
    if (POS_Control_CashDraw == nullptr) {
        qDebug() << "Failed to get POS_Control_CashDraw";
        goto ERR_END;
    }

    POS_Status_QueryStatus = (POS_Status_QueryStatusFun)GetProcAddress(m_hInstance, "POS_Status_QueryStatus");
    if (POS_Status_QueryStatus == nullptr) {
        qDebug() << "Failed to get POS_Status_QueryStatus";
        goto ERR_END;
    }

    POS_Output_PrintBmpDirectA = (POS_Output_PrintBmpDirectAFun)GetProcAddress(m_hInstance, "POS_Output_PrintBmpDirectA");
    if (POS_Output_PrintBmpDirectA == nullptr) {
        qDebug() << "Failed to get POS_Output_PrintBmpDirectA";
        goto ERR_END;
    }

    POS_Output_PrintBarcodeA = (POS_Output_PrintBarcodeAFun)GetProcAddress(m_hInstance, "POS_Output_PrintBarcodeA");
    if (POS_Output_PrintBarcodeA == nullptr) {
        qDebug() << "Failed to get POS_Output_PrintBarcodeA";
        goto ERR_END;
    }

    POS_Control_PrintTestpage = (POS_Control_PrintTestpageFun)GetProcAddress(m_hInstance, "POS_Control_PrintTestpage");
    if (POS_Control_PrintTestpage == nullptr) {
        qDebug() << "Failed to get POS_Control_PrintTestpage";
        goto ERR_END;
    }

    qDebug() << "POS SDK loaded successfully";
    return true;

ERR_END:

    FreeLibrary(m_hInstance);
    m_hInstance = nullptr;
    return false;
}

void POSDllLoader::freeLibrary()
{
    if (m_hInstance != nullptr) {
        FreeLibrary(m_hInstance);
        m_hInstance = nullptr;
        

        POS_Port_OpenA = nullptr;
        POS_Port_OpenW = nullptr;
        POS_Output_PrintStringA = nullptr;
        POS_Output_PrintStringW = nullptr;
        POS_Output_PrintData = nullptr;
        POS_Port_Close = nullptr;
        POS_Control_CutPaper = nullptr;
        POS_Control_CashDraw = nullptr;
        POS_Status_QueryStatus = nullptr;
        POS_Output_PrintBmpDirectA = nullptr;
        POS_Output_PrintBarcodeA = nullptr;
        POS_Control_PrintTestpage = nullptr;
        
        qDebug() << "POS SDK unloaded";
    }
}