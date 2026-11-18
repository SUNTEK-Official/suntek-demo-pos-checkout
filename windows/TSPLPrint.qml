import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

ColumnLayout {
    id: tsplPrint
    width: parent.width
    height: parent.height
    spacing: 15


    Label {
        text: "TSPL打印指令集"
        font.bold: true
        font.pixelSize: 24
        Layout.alignment: Qt.AlignHCenter
        Material.foreground: Material.primary
    }


    GroupBox {
        title: "打印机设置"
        Layout.fillWidth: true
        ColumnLayout {
            spacing: 10
            RowLayout {
                Label { text: "打印机类型:"; width: 100 }
                ComboBox {
                    id: printerType
                    Layout.fillWidth: true
                    model: ["TSPL打印机", "TSC TTP-244", "TSC TTP-342", "其他型号"]
                    currentIndex: 0
                }
            }
            RowLayout {
                Label { text: "页面尺寸:"; width: 100 }
                ComboBox {
                    id: pageSize
                    Layout.fillWidth: true
                    model: ["80mm x 80mm", "80mm x 60mm", "58mm x 58mm", "自定义"]
                    currentIndex: 0
                }
            }
        }
    }


    GroupBox {
        title: "图像打印"
        Layout.fillWidth: true
        ColumnLayout {
            spacing: 10
            RowLayout {
                Label { text: "图像路径:"; width: 100 }
                TextField {
                    id: imagePath
                    text: "D:\\test.bmp"
                    Layout.fillWidth: true
                }
                Button {
                    text: "浏览"
                    onClicked: {

                        console.log("打开文件选择器");
                    }
                }
            }
            RowLayout {
                Label { text: "打印方向:"; width: 100 }
                RadioButton { 
                    id: normalRadio
                    text: "正常"
                    checked: true
                }
                RadioButton { 
                    id: rotateRadio
                    text: "旋转"
                }
            }
            Button {
                text: "打印图像"
                Layout.alignment: Qt.AlignCenter
                onClicked: {
                    if (printerManager.isConnected) {
                        printerManager.printBitmap(imagePath.text);
                    } else {
                        printerManager.lastError = "请先连接打印机";
                    }
                }
            }
        }
    }


    Rectangle {
        id: previewArea
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        color: "#f0f0f0"
        radius: 8
        border.width: 1
        border.color: Material.primary
        Label {
            anchors.centerIn: parent
            text: "图像预览区域"
            color: "#999"
        }
    }


    RowLayout {
        spacing: 10
        Layout.fillWidth: true
        Button {
            text: "加载图像"
            Layout.fillWidth: true
            onClicked: {
                console.log("加载图像:", imagePath.text);

            }
        }
        Button {
            text: "打印测试"
            Layout.fillWidth: true
            onClicked: {
                if (printerManager.isConnected) {
                    printerManager.printTestPage();
                } else {
                    printerManager.lastError = "请先连接打印机";
                }
            }
        }
    }


    Label {
        text: "状态: " + printerManager.lastError
        color: printerManager.lastError ? "red" : "black"
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}