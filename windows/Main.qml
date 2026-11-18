import QtQuick 2.15
import QtQuick.Controls 2.15
import printer 1.0
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    title: qsTr("Suntek products")
    Material.theme: Material.Light
    Material.accent: Material.Blue
    Keys.enabled: true
    
 // Qt Quick C++ , QML icon


    property string barcodeBuffer: ""

    Timer {
        id: barcodeTimer
        interval: 100
        repeat: false
        onTriggered: {
            console.log("扫码定时器触发，buffer内容:", barcodeBuffer);
            console.log("当前页面索引:", tabBar.currentIndex);
            console.log("pageLoader.item:", pageLoader.item);
            console.log("pageLoader.item.addProductByBarcode:", pageLoader.item ? pageLoader.item.addProductByBarcode : "不存在");
            if (barcodeBuffer.length >= 6 && tabBar.currentIndex === 0) {
                if (pageLoader.item && pageLoader.item.addProductByBarcode) {
                    pageLoader.item.addProductByBarcode(barcodeBuffer);
                    console.log("调用了addProductByBarcode方法");
                } else {
                    console.log("无法调用addProductByBarcode方法");
                }
            }
            barcodeBuffer = "";
            console.log("清空barcodeBuffer");
        }
    }

    PageIndicator {
        id: pageIndicator
        currentIndex: tabBar.currentIndex
        count: tabBar.count
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
    }


    header: TabBar {
        id: tabBar
        anchors.horizontalCenter: parent.horizontalCenter
        TabButton {
            text: "Cash register System"
        }
        TabButton {
            text: "Printer Settings"
        }
        TabButton {
            text: "ESPOS Print"
        }
        TabButton {
            text: "TSPL Print"
        }
        TabButton {
            text: "CPCL Print"
        }
    }
    
 // Loader
    Rectangle {
        id: contentArea
        anchors.fill: parent
        color: "#f5f5f5"
        focus: true
        
        Keys.onPressed: {
            console.log("按键事件: key=", event.key, "text=", event.text);
            console.log("当前焦点组件:", activeFocusItem);
            if ((event.key >= Qt.Key_0 && event.key <= Qt.Key_9) ||
                (event.key >= Qt.Key_Keypad0 && event.key <= Qt.Key_Keypad9)) {
                barcodeBuffer += event.text;
                console.log("添加字符到buffer，当前buffer:", barcodeBuffer);
                barcodeTimer.restart();
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {

                console.log("回车键事件，buffer内容:", barcodeBuffer);
                if (barcodeBuffer.length >= 6 && tabBar.currentIndex === 0) {
                    if (pageLoader.item && pageLoader.item.addProductByBarcode) {
                        pageLoader.item.addProductByBarcode(barcodeBuffer);
                        console.log("调用了addProductByBarcode方法");
                    } else {
                        console.log("无法调用addProductByBarcode方法");
                    }
                }
                barcodeBuffer = "";
                console.log("清空barcodeBuffer");
                event.accepted = true;
            }
        }
        
        Loader {
            id: pageLoader
            anchors.fill: parent
            anchors.margins: 20
            sourceComponent: {
                switch(tabBar.currentIndex) {
                    case 0: return cashierComponent;
                    case 1: return printerSettingsComponent;
                    case 2: return esposPrintComponent;
                    case 3: return tsplPrintComponent;
                    case 4: return cpclPrintComponent;
                    default: return cashierComponent;
                }
            }
        }
        

        Component {
            id: cashierComponent
            Cashier {}
        }
        
        Component {
            id: printerSettingsComponent
            PrinterSettings {}
        }
        
        Component {
            id: esposPrintComponent
            ESPOSPrint {}
        }
        
        Component {
            id: tsplPrintComponent
            TSPLPrint {}
        }
        
        Component {
            id: cpclPrintComponent
            CPCLPrint {}
        }
    }


    Component.onCompleted: {
 // DLL
        let initResult = printerManager.initialize();
        console.log("初始化结果:", initResult);
    }
}
