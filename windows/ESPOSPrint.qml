import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

ColumnLayout {
    id: esposPrint
    width: parent.width
    height: parent.height
    spacing: 15


    Label {
        text: "ESPOS Printing Instruction Set"
        font.bold: true
        font.pixelSize: 24
        Layout.alignment: Qt.AlignHCenter
        Material.foreground: Material.primary
    }


    GroupBox {
        title: "Text printing"
        Layout.fillWidth: true
        height: 200
        ColumnLayout {
            spacing: 10
            TextArea {
                id: textToPrint
                text: "这是ESPOS指令集测试打印内容"
                Layout.fillWidth: true
                Layout.fillHeight: true
                wrapMode: TextEdit.WordWrap
            }
            Button {
                text: "Print Text"
                onClicked: {
                    if (printerManager.isConnected) {
                        printerManager.printText(textToPrint.text);
                    } else {
                        printerManager.lastError = "Please connect the printer first";
                    }
                }
            }
        }
    }


    GroupBox {
        title: "drawings printing"
        Layout.fillWidth: true
        ColumnLayout {
            spacing: 10
            RowLayout {
                Label { text: "image path:"; width: 80 }
                TextField {
                    id: imagePath
                    text: "D:\\test.bmp"
                    Layout.fillWidth: true
                }
                Button {
                    text: "browse"
                    onClicked: {

                        console.log("打开文件选择器");
                    }
                }
            }
            Button {
                text: "drawings printing"
                onClicked: {
                    if (printerManager.isConnected) {
                        printerManager.printBitmap(imagePath.text);
                    } else {
                        printerManager.lastError = "Please connect the printer first";
                    }
                }
            }
        }
    }


    GridLayout {
        Layout.fillWidth: true
        columns: 3
        rowSpacing: 10
        columnSpacing: 10
        Button {
            text: "Print test page"
            Layout.fillWidth: true
            onClicked: {
                if (printerManager.isConnected) {
                    printerManager.printTestPage();
                } else {
                    printerManager.lastError = "Please connect the printer first";
                }
            }
        }
        Button {
            text: "paper cutting"
            Layout.fillWidth: true
            onClicked: {
                if (printerManager.isConnected) {
                    printerManager.cutPaper();
                } else {
                    printerManager.lastError = "Please connect the printer first";
                }
            }
        }
        Button {
            text: "Open the cash box"
            Layout.fillWidth: true
            onClicked: {
                if (printerManager.isConnected) {
                    printerManager.openCashDrawer();
                } else {
                    printerManager.lastError = "Please connect the printer first";
                }
            }
        }
    }


    Label {
        text: "status: " + printerManager.lastError
        color: printerManager.lastError ? "red" : "black"
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}
