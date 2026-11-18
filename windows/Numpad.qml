import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    signal codeEntered(string code)

    property string currentCode: ""

    Label {
        text: "扫码/输入编码: " + (currentCode || "（点击数字）")
        color: "black"
        Layout.alignment: Qt.AlignHCenter
    }

    Grid {
        columns: 3
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 5

        Repeater {
            model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "DEL", "0", "OK"]
            Button {
                text: model
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    if (text === "DEL") {
                        currentCode = currentCode.slice(0, -1);
                    } else if (text === "OK") {
                        if (currentCode) {
                            codeEntered(currentCode);
                            currentCode = "";
                        }
                    } else {
                        currentCode += text;
                    }
                }
            }
        }
    }
}
