import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    property alias model: cartView.model
    property real total: 0.0

    Label {
        text: "购物车 (合计: $" + total + ")"
        font.bold: true
        font.pixelSize: 16
        color: "black"
        Layout.alignment: Qt.AlignHCenter
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            id: cartView
            clip: true
            delegate: RowLayout {
                width: ListView.view.width
                height: 40
                spacing: 10

                Text { text: name; color: "purple"; Layout.fillWidth: true }
                Text { text: "x" + quantity; color: "#aaa" }
                Text { text: "¥" + total; color: "#FFC107" }

                Button {
                    text: "×"
                    onClicked: cartView.model.remove(index)
                    Layout.preferredWidth: 30
                }
            }
        }
    }

    Button {
        text: "结算"
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 10
        highlighted: true
        onClicked: {
            if (model.count > 0) {
                console.log("结算成功！总金额: ¥" + total);
                model.clear();
            }
        }
    }
}
