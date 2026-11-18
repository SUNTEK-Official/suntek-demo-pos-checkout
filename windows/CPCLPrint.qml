import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

ColumnLayout {
    id: cpclPrint
    width: parent.width
    height: parent.height
    spacing: 15


    Label {
        text: "CPCL打印指令集"
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
                    model: ["CPCL打印机", "Zebra QLn220", "Zebra QLn320", "其他型号"]
                    currentIndex: 0
                }
            }
            RowLayout {
                Label { text: "页面尺寸:"; width: 100 }
                ComboBox {
                    id: pageSize
                    Layout.fillWidth: true
                    model: ["80mm x 80mm", "80mm x 100mm", "58mm x 80mm", "自定义"]
                    currentIndex: 0
                }
            }
            RowLayout {
                Label { text: "打印浓度:"; width: 100 }
                Slider {
                    id: densitySlider
                    from: 0
                    to: 10
                    value: 5
                    Layout.fillWidth: true
                    stepSize: 1
                }
                Label {
                    text: densitySlider.value.toString()
                    width: 30
                    horizontalAlignment: Text.AlignHCenter
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
                Label { text: "位置X:"; width: 80 }
                TextField {
                    id: posX
                    text: "10"
                    Layout.fillWidth: true
                }
                Label { text: "位置Y:"; width: 80 }
                TextField {
                    id: posY
                    text: "10"
                    Layout.fillWidth: true
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
            text: "CPCL图像预览区域"
            color: "#999"
        }
    }


    GridLayout {
        Layout.fillWidth: true
        columns: 3
        rowSpacing: 10
        columnSpacing: 10
        Button {
            text: "加载图像"
            Layout.fillWidth: true
            onClicked: {
                console.log("加载图像:", imagePath.text);

            }
        }
        Button {
            text: "打印图像"
            Layout.fillWidth: true
            onClicked: {
                if (printerManager.isConnected) {
                    printerManager.printBitmap(imagePath.text);
                } else {
                    printerManager.lastError = "请先连接打印机";
                }
            }
        }
        Button {
            text: "重置设置"
            Layout.fillWidth: true
            onClicked: {
                posX.text = "10";
                posY.text = "10";
                densitySlider.value = 5;
                printerType.currentIndex = 0;
                pageSize.currentIndex = 0;
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