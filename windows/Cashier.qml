import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Window 2.15

ColumnLayout {
    id: cashierMain

    width: parent.width
    height: parent.height
    spacing: 0

    property color brandPrimary: "#1D3557"
    property color brandAccent: "#2D9CDB"
    property string searchText: ""
    property string selectedCategory: ""
    property string currentTime: Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm")

    function matchesFilter(product) {
        if (!product) {
            return true;
        }

        var text = searchText ? searchText.toLowerCase() : "";
        var matchesSearch = text === "" ||
                            (product.name && product.name.toLowerCase().indexOf(text) !== -1) ||
                            (product.barcode && product.barcode.indexOf(searchText) !== -1);
        var matchesCategory = selectedCategory === "" ||
                              product.category === selectedCategory;
        return matchesSearch && matchesCategory;
    }

    Timer {
        interval: 60000
        repeat: true
        running: true
        onTriggered: currentTime = Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm")
    }


    Rectangle {
        id: header
        Layout.fillWidth: true
        height: 110
        color: brandPrimary
        radius: 0
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1b2a49" }
            GradientStop { position: 1.0; color: "#274C77" }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 24

            ColumnLayout {
                spacing: 6
                Label {
                    text: "Suntek Supermarket"
                    font.bold: true
                    font.pixelSize: 30
                    color: "white"
                }
                Label {
                    text: "Intelligent checkout and printing integrated solution"
                    font.pixelSize: 16
                    color: "#d6e4ff"
                }
            }

            Item {
                Layout.fillWidth: true
            }

            ColumnLayout {
                spacing: 4
                Label {
                    text: "current time"
                    font.pixelSize: 14
                    color: "#bcd0ff"
                }
                Label {
                    text: currentTime
                    font.pixelSize: 20
                    color: "white"
                    font.bold: true
                }
            }
        }
    }


    Rectangle {
        id: contentArea
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "#eef2f6"
        radius: 0

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: 18
            spacing: 16

            Rectangle {
                id: controlPanel
                Layout.fillWidth: true
                height: 110
                radius: 16
                color: "white"
                border.color: "#e3e8ef"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    ColumnLayout {
                        spacing: 4
                        Label {
                            text: "Welcome back，Suntek"
                            font.pixelSize: 22
                            font.bold: true
                            color: brandPrimary
                        }
                        Label {
                            text: "Quickly retrieve products, filter categories, and monitor real-time sales data"
                            font.pixelSize: 14
                            color: "#6b7280"
                        }
                    }

                    Item { Layout.fillWidth: true }

                    TextField {
                        id: searchField
                        Layout.preferredWidth: 280
                        Layout.alignment: Qt.AlignVCenter
                        placeholderText: "Search for product name or scan barcode"
                        text: searchText
                        onTextChanged: searchText = text
                        Material.background: "#f0f4ff"
                        leftPadding: 14
                        rightPadding: 14
                    }

                    ComboBox {
                        id: categoryBox
                        Layout.preferredWidth: 170
                        Layout.alignment: Qt.AlignVCenter
                        model: ["All Categories", "Food", "Beverages", "Stationery", "Daily Necessities"]
                        currentIndex: 0
                        onCurrentTextChanged: selectedCategory = currentText === "All Categories" ? "" : currentText
                    }

                    Button {
                        text: "Reset filter"
                        Layout.preferredWidth: 120
                        Layout.alignment: Qt.AlignVCenter
                        onClicked: {
                            searchText = "";
                            selectedCategory = "";
                            searchField.text = "";
                            categoryBox.currentIndex = 0;
                        }
                    }
                }
            }

            RowLayout {
                id: summaryRow
                Layout.fillWidth: true
                spacing: 16

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 90
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#2D9CDB" }
                        GradientStop { position: 1.0; color: "#1B7FCC" }
                    }
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 4
                        Label {
                            text: "Product Category"
                            color: "#e7f3ff"
                            font.pixelSize: 14
                        }
                        Label {
                            text: productsModel.count
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                        }
                        Label {
                            text: "Register products for sale"
                            color: "#d0e7ff"
                            font.pixelSize: 12
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 90
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#9B51E0" }
                        GradientStop { position: 1.0; color: "#6C63FF" }
                    }
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 4
                        Label {
                            text: "Shopping cart products"
                            color: "#f5e8ff"
                            font.pixelSize: 14
                        }
                        Label {
                            text: totalQuantity + " piece"
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                        }
                        Label {
                            text: "Real time pending settlement quantity"
                            color: "#e5d9ff"
                            font.pixelSize: 12
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 90
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#F2994A" }
                        GradientStop { position: 1.0; color: "#EB5757" }
                    }
                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 4
                        Label {
                            text: "Amount Payable"
                            color: "#ffe9db"
                            font.pixelSize: 14
                        }
                        Label {
                            text: "$" + subtotal.toFixed(2)
                            font.pixelSize: 28
                            font.bold: true
                            color: "white"
                        }
                        Label {
                            text: "Including instant discounts"
                            color: "#ffddcf"
                            font.pixelSize: 12
                        }
                    }
                }
            }

            RowLayout {
                id: mainContentRow
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 16


                Rectangle {
                    id: productArea
                    Layout.fillWidth: true
                    Layout.preferredWidth: 620
                    Layout.fillHeight: true
                    radius: 16
                    color: "white"
                    border.color: "#e4e9f2"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        ScrollView {
                            id: productScroll
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            GridLayout {
                                id: productGrid
                                columns: 4
                                columnSpacing: 24
                                rowSpacing: 32
                                anchors.margins: 8

                                Repeater {
                                    id: productRepeater
                                    model: productsModel

                                    Rectangle {
                                        id: productItem
                                        Layout.preferredWidth: 190
                                        height: 250
                                        radius: 14
                                        color: "#fdfdfd"
                                        border.width: 1
                                        border.color: "#edf1f7"
                                        opacity: matchesFilter(model) ? 1 : 0
                                        visible: matchesFilter(model)
                                        Behavior on opacity { NumberAnimation { duration: 150 } }

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 12
                                            spacing: 8

                                            Rectangle {
                                                id: productImage
                                                Layout.fillWidth: true
                                                height: 130
                                                radius: 12
                                                color: "#f1f5f9"

                                                Image {
                                                    id: productImageContent
                                                    anchors.fill: parent
                                                    anchors.margins: 10
                                                    source: (model.image.endsWith(".jpg") || model.image.endsWith(".png") || model.image.startsWith("http")) ? model.image : ""
                                                    fillMode: Image.PreserveAspectFit
                                                    visible: (source !== "") && (status !== Image.Error)
                                                    onStatusChanged: visible = (status !== Image.Error) && source !== ""
                                                }

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: model.name.charAt(0)
                                                    font.pixelSize: 40
                                                    color: brandAccent
                                                    visible: !productImageContent.visible
                                                }

                                                Rectangle {
                                                    anchors.right: parent.right
                                                    anchors.top: parent.top
                                                    anchors.margins: 8
                                                    radius: 12
                                                    color: "#ffffffcc"
                                                    border.color: "#e0e7ff"
                                                    border.width: 1
                                                    Label {
                                                        anchors.fill: parent
                                                        anchors.margins: 6
                                                        horizontalAlignment: Qt.AlignHCenter
                                                        verticalAlignment: Qt.AlignVCenter
                                                        text: model.category
                                                        font.pixelSize: 12
                                                        color: brandPrimary
                                                    }
                                                }
                                            }

                                            Label {
                                                text: model.name
                                                font.bold: true
                                                font.pixelSize: 16
                                                Layout.fillWidth: true
                                                wrapMode: Text.WrapAnywhere
                                                color: brandPrimary
                                            }

                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: 8

                                                Label {
                                                    text: "$" + model.price.toFixed(2)
                                                    font.bold: true
                                                    font.pixelSize: 20
                                                    color: "#f15a29"
                                                }

                                                Item { Layout.fillWidth: true }

                                                Button {
                                                    text: "+"
                                                    Layout.preferredWidth: 70
                                                    onClicked: addToCart(model)
                                                }
                                            }
                                        }

                                        TapHandler {
                                            target: productItem
                                            gesturePolicy: TapHandler.DragThreshold
                                            onTapped: addToCart(model)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }


                Rectangle {
                    id: cartArea
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.32
                    radius: 16
                    border.width: 1
                    border.color: "#e4e9f2"
                    color: "#ffffff"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 12

                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "shopping cart"
                                font.bold: true
                                font.pixelSize: 22
                                color: brandPrimary
                            }
                            Item { Layout.fillWidth: true }
                            Label {
                                text: totalQuantity + " piece"
                                font.pixelSize: 16
                                color: "#64748b"
                            }
                        }

                        ScrollView {
                            id: cartScroll
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ListView {
                                id: cartList
                                model: cartModel
                                clip: true

                                delegate: Rectangle {
                                    width: cartList.width - 8
                                    x: 4
                                    height: 88
                                    radius: 12
                                    color: "#f7f9fc"
                                    border.color: "#e0e7ff"
                                    border.width: 1
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 12

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 4
                                            Label {
                                                text: model.name
                                                font.pixelSize: 16
                                                font.bold: true
                                                color: brandPrimary
                                            }
                                            Label {
                                                text: "unit price $" + model.price.toFixed(2)
                                                font.pixelSize: 12
                                                color: "#7c8db5"
                                            }
                                        }

                                        RowLayout {
                                            spacing: 6
                                            Button {
                                                text: "-"
                                                width: 30
                                                height: 30
                                                onClicked: decreaseQuantity(model)
                                            }
                                            Label {
                                                text: model.quantity.toString()
                                                width: 30
                                                horizontalAlignment: Qt.AlignHCenter
                                            }
                                            Button {
                                                text: "+"
                                                width: 30
                                                height: 30
                                                onClicked: increaseQuantity(model)
                                            }
                                        }

                                        Label {
                                            Layout.preferredWidth: 90
                                            text: "$" + (model.price * model.quantity).toFixed(2)
                                            font.bold: true
                                            color: "#f15a29"
                                            horizontalAlignment: Qt.AlignRight
                                        }

                                        ToolButton {
                                            text: "remove"
                                            onClicked: removeFromCart(model)
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: checkoutInfo
                            Layout.fillWidth: true
                            radius: 14
                            color: "#f8fafc"
                            border.color: "#e2e8f0"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12

                                RowLayout {
                                    Layout.fillWidth: true
                                    Label {
                                        text: "商品数量"
                                        font.pixelSize: 16
                                        color: "#475569"
                                    }
                                    Label {
                                        Layout.fillWidth: true
                                        text: totalQuantity + " 件"
                                        font.bold: true
                                        font.pixelSize: 16
                                        horizontalAlignment: Qt.AlignRight
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Label {
                                        text: "小计"
                                        font.pixelSize: 16
                                        color: "#475569"
                                    }
                                    Label {
                                        Layout.fillWidth: true
                                        text: "$" + subtotal.toFixed(2)
                                        font.bold: true
                                        font.pixelSize: 16
                                        horizontalAlignment: Qt.AlignRight
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Label {
                                        text: "应付金额"
                                        font.bold: true
                                        font.pixelSize: 20
                                        color: "#f15a29"
                                    }
                                    Label {
                                        Layout.fillWidth: true
                                        text: "$" + subtotal.toFixed(2)
                                        font.bold: true
                                        font.pixelSize: 24
                                        color: "#f15a29"
                                        horizontalAlignment: Qt.AlignRight
                                    }
                                }
                            }
                        }

                        Button {
                            text: "Checkout Now"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 56
                            font.pixelSize: 20
                            Material.background: Material.accent
                            onClicked: checkout()
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            Button {
                                text: "Clear shopping cart"
                                Layout.fillWidth: true
                                onClicked: clearCart()
                            }
                            Button {
                                text: "Pop up the cash box"
                                Layout.fillWidth: true
                                onClicked: popcashbox()
                            }
                        }
                    }
                }
            }
        }
    }


 // image emoji

 // "images/apple.png" ( )
 // "C:/images/apple.png"
 // URL: "https://example.com/images/apple.png"
    ListModel {
        id: productsModel
        ListElement {
            name: "Apple"
            price: 5.99
            category: "Food"
            barcode: "6901234567890"
            image: "images/apple.png"
        }
        ListElement {
            name: "Banana"
            price: 3.50
            category: "Food"
            barcode: "6901234567891"
            image: "images/banana.png"
        }
        ListElement {

            name: "Coca-Cola"
            price: 2.50
            category: "Beverages"
            barcode: "6907878050110"
            image: "images/kele.png"
        }
        ListElement {

            name: "Mineral Water "
            price: 1.50
            category: "Beverages"
            barcode: "6901234567893"
            image: "images/water.png"
        }
        ListElement {

            name: "Cigarette"
            price: 10.00
            category: "Stationery"
            barcode: "48511322"
            image: "images/cigarette.png"
        }
        ListElement {

            name: "Milk"
            price: 0.50
            category: "Beverages"
            barcode: "6901234567895"
            image: "images/milk.png"
        }

        ListElement {

            name: "Tissue"
            price: 5.00
            category: "Daily Necessities"
            barcode: "6901234567897"
            image: "images/Tissue.png"
        }
        ListElement {

            name: "Bread"
            price: 4.50
            category: "Food"
            barcode: "6901234567898"
            image: "images/bread.png"
        }
    }

    ListModel {
        id: cartModel
    }


    property int totalQuantity: 0
    property double subtotal: 0.0


    function calculateTotal() {
        totalQuantity = 0;
        subtotal = 0.0;
        
        for (var i = 0; i < cartModel.count; i++) {
            var item = cartModel.get(i);
            totalQuantity += item.quantity;
            subtotal += item.price * item.quantity;
        }
    }


    function addToCart(product) {

        for (var i = 0; i < cartModel.count; i++) {
            if (cartModel.get(i).barcode === product.barcode) {

                var quantity = cartModel.get(i).quantity + 1;
                cartModel.setProperty(i, "quantity", quantity);
                calculateTotal();
                return;
            }
        }
        

        cartModel.append({
            name: product.name,
            price: product.price,
            quantity: 1,
            barcode: product.barcode
        });
        
        calculateTotal();
    }


    function addProductByBarcode(barcode) {
        console.log("Cashier.addProductByBarcode被调用，条形码:", barcode);


        for (var i = 0; i < productsModel.count; i++) {
            console.log("比较商品", i, "条形码:", productsModel.get(i).barcode);
            if (productsModel.get(i).barcode === barcode) {
                console.log("找到商品:", productsModel.get(i).name);
                addToCart(productsModel.get(i));
                return;
            }
        }
        

        console.log("商品未找到:", barcode);
        printerManager.lastError = "商品未找到: " + barcode;
    }


    function increaseQuantity(item) {
        for (var i = 0; i < cartModel.count; i++) {
            if (cartModel.get(i).barcode === item.barcode) {
                var quantity = cartModel.get(i).quantity + 1;
                cartModel.setProperty(i, "quantity", quantity);
                calculateTotal();
                return;
            }
        }
    }


    function decreaseQuantity(item) {
        for (var i = 0; i < cartModel.count; i++) {
            if (cartModel.get(i).barcode === item.barcode) {
                var quantity = cartModel.get(i).quantity - 1;
                if (quantity <= 0) {
                    cartModel.remove(i);
                } else {
                    cartModel.setProperty(i, "quantity", quantity);
                }
                calculateTotal();
                return;
            }
        }
    }


    function removeFromCart(item) {
        for (var i = 0; i < cartModel.count; i++) {
            if (cartModel.get(i).barcode === item.barcode) {
                cartModel.remove(i);
                calculateTotal();
                return;
            }
        }
    }


    function clearCart() {
        cartModel.clear();
        calculateTotal();
    }


    function filterProductsByCategory(category) {
        selectedCategory = category === "全部分类" ? "" : (category || "");
        if (categoryBox) {
            var target = selectedCategory === "" ? "全部分类" : selectedCategory;
            var index = categoryBox.model.indexOf(target);
            if (index >= 0) {
                categoryBox.currentIndex = index;
            }
        }
    }


    function checkout() {
        if (cartModel.count === 0) {
            printerManager.lastError = "购物车为空，无法结算";
            return;
        }
        

        var receipt = "\n";
        receipt += "*******************************************\n";
        receipt += "    Suntek  Supermarket      \n";
        receipt += "    Address: Shunde, Foshan, Guangdong  \n";
        receipt += "    TEL：12345678901    \n";
        receipt += "*******************************************\n";
        receipt += "Product Name    Number    Unit Price   Amount \n";
        receipt += "-------------------------------------------\n";
        
        for (var i = 0; i < cartModel.count; i++) {
            var item = cartModel.get(i);
            var itemTotal = item.price * item.quantity;
            receipt += item.name.padEnd(8, " ") + "    " + 
                       item.quantity.toString().padStart(2, " ") + "    " + 
                       "$" + item.price.toFixed(2).padStart(6, " ") + " " +
                       "$" + itemTotal.toFixed(2).padStart(6, " ") + "\n";
        }
        
        receipt += "-------------------------------------------\n";
        receipt += "Total：" + subtotal.toFixed(2) + "  Dollar\n";
        receipt += "Payment：" + subtotal.toFixed(2) + "  Doller\n";
        receipt += "Change：0.00  Doller\n";
        receipt += "*********************************************\n";
        receipt += "      Looking forward to your next visit！    \n";
        receipt += "*********************************************\n\n";
        

        if (printerManager.isConnected) {
            printerManager.printText(receipt);
            printerManager.cutPaper();
            //printerManager.openCashDrawer();
        } else {
            printerManager.lastError = "打印机未连接，无法打印小票";
        }
        

        clearCart();
        

        showCheckoutSuccess();
    }

    function popcashbox(){
        printerManager.openCashDrawer();
    }


    function showCheckoutSuccess() {
 // Toast
        var toast = Qt.createQmlObject(
            'import QtQuick 2.15; import QtQuick.Controls 2.15; 
            Rectangle { 
                width: 200; height: 50; 
                color: "#323232"; 
                opacity: 0.9; 
                radius: 10; 
                anchors.centerIn: parent; 
                Label { 
                    text: "结算成功！"; 
                    color: "white"; 
                    font.pixelSize: 16; 
                    anchors.centerIn: parent;

                } 
                Component.onCompleted: {

                    Qt.callLater(function() {
                        destroy();
                    }, 3000);
                }
            }',
            parent
        );
    }
}
