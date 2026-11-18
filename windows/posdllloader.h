#ifndef POSDLLLOADER_H
#define POSDLLLOADER_H

#include <QString>
#include <Windows.h>

 // SDK
enum POS_PORT_TYPE {
    POS_PT_COM = 1000,
    POS_PT_LPT = 1001,
    POS_PT_USB = 1002,
    POS_PT_NET = 1003
};


#define POS_ES_SUCCESS       0
#define POS_ES_INVALIDPARA   1
#define POS_ES_WRITEFAIL     2
#define POS_ES_OVERTIME      3
#define POS_ES_OTHERERRORS   4


typedef LONG (WINAPI *POS_Port_OpenAFun)(LPSTR szName, INT iPort, BOOL bFile, LPSTR szFilePath);
typedef LONG (WINAPI *POS_Port_OpenWFun)(LPWSTR szName, INT iPort, BOOL bFile, LPWSTR szFilePath);
typedef LONG (WINAPI *POS_Output_PrintStringAFun)(LONG iPrinterID, LPCSTR lpBuffer);
typedef LONG (WINAPI *POS_Output_PrintStringWFun)(LONG iPrinterID, LPCWSTR lpBuffer);
typedef LONG (WINAPI *POS_Output_PrintDataFun)(LONG iPrinterID, LPCSTR lpBuffer, INT iLen);
typedef LONG (WINAPI *POS_Port_CloseFun)(LONG iPrinterID);
typedef LONG (WINAPI *POS_Control_CutPaperFun)(LONG iPrinterID, LONG iType, LONG iLines);
typedef LONG (WINAPI *POS_Control_CashDrawFun)(LONG iPrinterID, LONG iPort, LONG iTime1, LONG iTime2);
typedef LONG (WINAPI *POS_Status_QueryStatusFun)(LONG iPrinterID);
typedef LONG (WINAPI *POS_Output_PrintBmpDirectAFun)(LONG iPrinterID, LPCSTR lpFilePath);
typedef LONG (WINAPI *POS_Output_PrintBarcodeAFun)(LONG iPrinterID, INT iType, INT iWidth, INT iHeight, INT hri, LPCSTR lpString);
typedef LONG (WINAPI *POS_Control_PrintTestpageFun)(LONG iPrinterID);

class POSDllLoader
{
public:
    POSDllLoader();
    ~POSDllLoader();

 // SDK
    bool loadLibrary();
    
 // SDK
    void freeLibrary();
    
 // API
    POS_Port_OpenAFun POS_Port_OpenA;
    POS_Port_OpenWFun POS_Port_OpenW;
    POS_Output_PrintStringAFun POS_Output_PrintStringA;
    POS_Output_PrintStringWFun POS_Output_PrintStringW;
    POS_Output_PrintDataFun POS_Output_PrintData;
    POS_Port_CloseFun POS_Port_Close;
    POS_Control_CutPaperFun POS_Control_CutPaper;
    POS_Control_CashDrawFun POS_Control_CashDraw;
    POS_Status_QueryStatusFun POS_Status_QueryStatus;
    POS_Output_PrintBmpDirectAFun POS_Output_PrintBmpDirectA;
    POS_Output_PrintBarcodeAFun POS_Output_PrintBarcodeA;
    POS_Control_PrintTestpageFun POS_Control_PrintTestpage;
    

    bool isLoaded() const { return m_hInstance != nullptr; }
    
private:
    HINSTANCE m_hInstance; // DLL
    static const char* DLL_PATH; // DLL
};

#endif // POSDLLLOADER_H