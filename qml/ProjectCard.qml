import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Item {


    signal cancel()

    property color bg: "#96c3c4"
    property int cardID: 0

    function load(i = -1){
        if (i === -1){
            cardID = 0
            project_name.text = ""
            project_name.focus = true
            bg = "#ffffff"
            card_col.text = 8
            card_row.text = 8
            card_height.text = 85 * 8
            card_width.text = 76 * 8
        } else {
            cardID = Number(modelProject.get(i, "id"))
            project_name.text = modelProject.get(i, "name")
            card_col.text = Number(modelProject.get(i, "columns"))
            card_row.text = Number(modelProject.get(i, "rows"))
            card_width.text = Number(modelProject.get(i, "width"))
            card_height.text = Number(modelProject.get(i, "height"))
            bg = modelProject.get(i, "bg")
        }

    }

    QtObject {
        id: internal

        function save(){
            var r = true
            var err = ""
            if (project_name.text === ""){
                r = false
                err = "Укажите название проекта"
            } else {
                if (Number(card_col.text) === 0){
                    r = false
                    err = "Укажите количество столбцов"
                } else {
                    if (Number(card_row.text) === 0){
                        r = false
                        err = "Укажите количество строк"
                    }
                }
            }

            if (r) {
                let card = {
                    id: cardID,
                    name: project_name.text,
                    width: card_width.text,
                    height: card_height.text,
                    rows: card_row.text,
                    columns: card_col.text,
                    bg: bg
                }

                var res = modelProject.save(card)
                if (res){
                    cancel()
                }
            } else {
                showMessage(err)
            }
        }

        function showMessage(message){
            messa.text = "Ошибка - " + message
            messageBox.visible = true
            timer.start()
        }

    }

    Connections {
        target: modelProject
        function onError(error){
            internal.showMessage(error)
        }
    }

    Pane {
        id: add_pane
        anchors.centerIn: parent

        width: parent.width * 0.5
        height: parent.height * 0.5


        ColumnLayout{
            anchors.fill: parent
            spacing: 10

            TextField {
                id: project_name

                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                placeholderText: "Название"
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                spacing: 10
                Label {
                    Layout.leftMargin: 100
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    text: "Строки: "
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                }
                TextField {
                    id: card_row
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100

                    validator: RegularExpressionValidator{
                        regularExpression: /^[1-9]\d{0,1}$/
                    }
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter

                    onFocusChanged: {
                        if (focus){
                            selectAll()
                        }
                    }

                    onTextChanged:{
                        card_height.text = Number(text) * 85
                    }

                    onEditingFinished: {
                        card_height.text = Number(text) * 85
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                spacing: 10

                Label {
                    Layout.leftMargin: 100
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    text: "Столбцы: "
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                }
                TextField {
                    id: card_col
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100

                    validator: RegularExpressionValidator{
                        regularExpression: /^[1-9]\d{0,1}$/
                    }
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter

                    onFocusChanged: {
                        if (focus){
                            selectAll()
                        }
                    }

                    onTextChanged: {
                        card_width.text = Number(text) * 76
                    }

                    onEditingFinished: {
                        card_width.text = Number(text) * 76
                    }

                }
                Item {
                    Layout.fillWidth: true
                }

            }

            RowLayout {
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                spacing: 10
                Label {
                    Layout.leftMargin: 100
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    text: "Ширина: "
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                }

                TextField {
                    id: card_width
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100

                    validator: RegularExpressionValidator{
                        regularExpression: /^[1-9]\d{0,3}$/
                    }
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter

                    readOnly: true

                }

                Item {
                    Layout.fillWidth: true
                }

            }
            RowLayout {
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                spacing: 10
                Label {
                    Layout.leftMargin: 100
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    text: "Высота: "
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                }
                TextField {
                    id: card_height
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100

                    readOnly: true

                    validator: RegularExpressionValidator{
                        regularExpression: /^[1-9]\d{0,3}$/
                    }
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter

                }
                Item {
                    Layout.fillWidth: true
                }

            }
            RowLayout {
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                spacing: 10
                Label {
                    Layout.leftMargin: 100
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    text: "Фон: "
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                }
                Rectangle {
                    Layout.minimumHeight: 40
                    Layout.maximumHeight: 40
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100

                    color: bg
                    radius: 5

                    MouseArea {
                        anchors.fill: parent

                        onClicked: colorDialog.open()
                    }

                }
                Item {
                    Layout.fillWidth: true
                }

            }

            Item {
                Layout.fillHeight: true
            }

            Pane {
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    Item {
                        Layout.fillWidth: true
                    }

                    Button{
                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        text: "Сохранить"

                        Material.background: clr_ORANGE
                        Material.foreground: clr_DARK
                        Material.roundedScale: Material.ExtraSmallScale

                        onClicked: internal.save()
                    }

                    Button{
                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        text: "Отмена"

                        Material.background: clr_ORANGE
                                            Material.foreground: clr_DARK
                                            Material.roundedScale: Material.ExtraSmallScale

                        onClicked: cancel()
                    }
                }
            }
        }
    }

    Rectangle {
        id: messageBox
        visible: false

        height: 55
        width: parent.width * 0.7

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        color: "#C91738"

        radius: 5

        Label {
            id: messa
            anchors.fill: parent
            anchors.leftMargin: 20

            font.pointSize: 13
            color: "#FFFFFF"

            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
        }
    }

    Timer {
        id: timer
        interval: 6000
        repeat: false
        running: false

        onTriggered: {
            messageBox.visible = false
        }
    }



    ColorDialog {
        id: colorDialog
        selectedColor: bg
        onAccepted: bg = selectedColor
    }
}
