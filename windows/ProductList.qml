import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    property alias model: listView.model
    signal productSelected(string name, real price)

    Label {
        text: "商品列表"
        font.bold: true
        font.pixelSize: 18
        Layout.alignment: Qt.AlignHCenter
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            id: listView
            clip: true
            delegate: Rectangle {
                width: ListView.view.width - 20
                height: 60
                color: "#FFEBCD"
                radius: 8
                border.color: "#333"
                Column {
                    Text { text: name; font.pixelSize: 16; color: "red" }
                    Text { text: "$" + price; font.pixelSize: 14; color: "#4CAF50" }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: productSelected(name, price)
                }
            }
        }
    }
}
