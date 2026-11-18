import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

ColumnLayout {
    id: printerSettings
    width: parent.width
    height: parent.height
    spacing: 15


    Label {
        text: "打印机设置"
        font.bold: true
        font.pixelSize: 24
        Layout.alignment: Qt.AlignHCenter
        Material.foreground: Material.primary
    }


    Rectangle {
        id: statusBar
        Layout.fillWidth: true
        height: 50
        radius: 8
        Material.background: printerManager.isConnected ? Material.Green : Material.Red
        Label {
            anchors.centerIn: parent
            text: printerManager.isConnected ? "已连接打印机" : "未连接打印机"
            font.bold: true
            color: "white"
        }
    }


    Label {
        text: "错误信息: " + printerManager.lastError
        color: printerManager.lastError ? "red" : "black"
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }


    GroupBox {
        title: "端口设置"
        Layout.fillWidth: true
        ColumnLayout {
            spacing: 10


            RowLayout {
                Label { text: "端口类型:"; width: 80 }
                RadioButton { 
                    id: comRadio
                    text: "COM端口"
                    checked: true
                    onCheckedChanged: if (checked) printerManager.portType = 1000
                }
                RadioButton { 
                    id: lptRadio
                    text: "LPT端口"
                    onCheckedChanged: if (checked) printerManager.portType = 1001
                }
                RadioButton { 
                    id: usbRadio
                    text: "USB端口"
                    onCheckedChanged: if (checked) printerManager.portType = 1002
                }
                RadioButton { 
                    id: netRadio
                    text: "网络端口"
                    onCheckedChanged: if (checked) printerManager.portType = 1003
                }
            }


            RowLayout {
                Label { text: "端口名称:"; width: 80 }
                TextField {
                    id: portNameInput
                    text: printerManager.portName
                    Layout.fillWidth: true
                    onEditingFinished: printerManager.portName = text
                }
            }
        }
    }


    RowLayout {
        spacing: 10
        Layout.fillWidth: true

        Button {
            text: "初始化"
            Layout.fillWidth: true
            onClicked: {
                let result = printerManager.initialize();
                if (result) {
                    statusText.text = "初始化成功";
                }
            }
        }

        Button {
            text: printerManager.isConnected ? "断开连接" : "连接打印机"
            Layout.fillWidth: true
            //enabled: printerManager.initialize()
            enabled: printerManager.portName.trim() !== ""
            onClicked: {
                if (printerManager.isConnected) {
                    printerManager.disconnectPrinter();
                    updateRadioButtons();
                } else {
                    printerManager.portName = portNameInput.text;
                    printerManager.connectPrinter();
                }
            }
        }
    }


 // ( GridView)
    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        spacing: 10

        Repeater {
            model: [
                {"text": "测试打印", "action": "printTestPage"},
                {"text": "切纸", "action": "cutPaper"},
                {"text": "打开钱箱", "action": "openCashDrawer"}
            ]

            Button {
                Layout.fillWidth: true

 // ( !)
                contentItem: Text {
                    text: modelData.text
                    font.bold: true
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }


                background: Rectangle {
                    color: Material.primary
                    radius: 4
                }

                onClicked: {
                    if (!printerManager.isConnected) {
                        statusText.text = "请先连接打印机";
                        return;
                    }

                    switch (modelData.action) {
                        case "printTestPage":
                            printerManager.printTestPage();
                            break;
                        case "cutPaper":
                            printerManager.cutPaper();
                            break;
                        case "openCashDrawer":
                            printerManager.openCashDrawer();
                            break;
                    }
                }
            }
        }
    }


    Label {
        id: statusText
        text: "就绪"
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
    }


    function updateRadioButtons() {
        switch (printerManager.portType) {
            case 0: comRadio.checked = true; break;
            case 1: lptRadio.checked = true; break;
            case 2: usbRadio.checked = true; break;
            case 3: netRadio.checked = true; break;
        }
    }


    Connections {
        target: printerManager
        onPortTypeChanged: updateRadioButtons()
    }
}
