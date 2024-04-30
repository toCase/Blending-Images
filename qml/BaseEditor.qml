import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: baseEditor

    QtObject{
        id: internal

        function save(){
            var l = modelEmptyFile.getSelectedList()
            var res = modelFile.save(l)
            if (res){
                file_selector.onSaved()
                info_all.text = modelFile.rowCount()
                info_selected.text = modelFile.getSelectedCount()
            }
        }

        function select(i, selected){
            var scrollPosition = scrollTable.position

            modelFile.selectItem(i, selected)

            scrollTable.position = scrollPosition
            grid_main.currentIndex = i

            info_selected.text = modelFile.getSelectedCount()
        }

        function selectAll(){
            modelFile.selectAll()
            info_selected.text = modelFile.getSelectedCount()
        }

        function unselectAll(){
            modelFile.unselectAll()
            info_selected.text = modelFile.getSelectedCount()
        }

        function changeDir(){
            var main_dir = modelDir.getCurrent()
            var selected_dir = combo_dir.currentValue

            if (main_dir !== selected_dir){
                var r = modelFile.changeDir(selected_dir)
                if (r){
                    info_all.text = modelFile.rowCount()
                    info_selected.text = modelFile.getSelectedCount()
                }
            }


        }

        function del(){
            var r = modelFile.delete()
            if (r){
                info_all.text = modelFile.rowCount()
                info_selected.text = modelFile.getSelectedCount()
                file_selector.onSaved()
            }


        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 3

        BaseFileSelector {
            id: file_selector
            Layout.fillHeight: true
            Layout.minimumWidth: parent.width / 3
            Layout.maximumWidth: parent.width / 3
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.minimumWidth: 3
            Layout.maximumWidth: 3
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            color: clr_DARK
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: 5


            BaseDirSelector{
                Layout.fillWidth: true
                Layout.minimumHeight: 120
                Layout.maximumHeight: 120
            }

            GridView {
                id: grid_main

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.rightMargin: 10
                Layout.leftMargin: 10

                cellWidth: 76 + 20 + 20
                cellHeight: 85 + 20 + 20

                clip: true

                model: modelFile

                delegate: Rectangle {
                    width: grid_main.cellWidth - 20
                    height: grid_main.cellHeight - 20

                    radius: 5

                    required property string file
                    required property bool selected
                    required property int index

                    border.width: 4
                    border.color:
                        if (selected) {
                            clr_ORANGE
                        } else {
                            clr_WHITE
                        }

                    Image {
                        anchors.centerIn: parent
                        width: 76
                        height: 85
                        source: file
                    }
                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {                            
                            internal.select(index, !selected)
                        }
                        onContainsMouseChanged: {
                            if (containsMouse){
                                parent.border.color = clr_DARK
                            } else {
                                if (selected) {
                                    parent.border.color = clr_ORANGE
                                } else {
                                    parent.border.color = clr_WHITE
                                }
                            }
                        }
                    }
                }
                highlightMoveDuration: 0
                focus: true
                ScrollBar.vertical: ScrollBar { id:scrollTable }

            }

            Rectangle {
                id: messageBox
                visible: false
                Layout.fillWidth: true
                Layout.minimumHeight: 55
                Layout.maximumHeight: 55

                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15

                radius: 5

                Label {
                    id: messa
                    anchors.fill: parent
                    anchors.leftMargin: 20

                    font.pointSize: 13
                    color: clr_WHITE

                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                }
            }

            Pane {
                id: info

                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight
                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth

                        text: "Всего:"
                        font.pointSize: 13
                    }
                    Label {
                        id: info_all
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight
                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        text: ""
                        font.pointSize: 13
                    }
                    Label {
                        Layout.leftMargin: 20
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight
                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth

                        text: "Выбрано: "
                        font.pointSize: 13
                    }

                    Label {
                        id: info_selected
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight
                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth

                        text: ""
                        font.pointSize: 13
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                }
            }

            Pane {
                id: menu_directory

                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight

                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    Button {
                        id: but_dir_selectAll

                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        text: "Выбрать все"

                        Material.background: clr_ORANGE
                        Material.foreground: clr_DARK
                        Material.roundedScale: Material.ExtraSmallScale

                        onClicked: internal.selectAll()

                    }

                    Button {
                        id: but_dir_unselectAll

                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        text: "Снять выбор"

                        Material.background: clr_ORANGE
                        Material.foreground: clr_DARK
                        Material.roundedScale: Material.ExtraSmallScale

                        onClicked: internal.unselectAll()

                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ComboBox {
                        id: combo_dir
                        Layout.minimumWidth: 200
                        Layout.maximumWidth: 200
                        Layout.minimumHeight: but_dir_unselectAll.height
                        Layout.maximumHeight: but_dir_unselectAll.height
                        model: modelDir
                        textRole: "dir"
                        valueRole: "id"
                    }
                    Button {
                        id: but_change_save

                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        text: "Перенести"

                        Material.background: clr_ORANGE
                        Material.foreground: clr_DARK
                        Material.roundedScale: Material.ExtraSmallScale

                        onClicked: internal.changeDir()
                    }


                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        id: but_del

                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        text: "Удалить"

                        Material.background: Material.Pink
                        Material.foreground: clr_WHITE
                        Material.roundedScale: Material.ExtraSmallScale

                        onClicked: internal.del()
                    }
                }
            }
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

    Connections{
        target: modelFile
        function onError(message){
            messa.text = "Ошибка - " + message
            messageBox.color = "#C91738"
            messageBox.visible = true
            timer.start()
        }
    }

    Connections{
        target: modelDir
        function onError(message){
            messa.text = "Ошибка - " + message
            messageBox.color = "#C91738"
            messageBox.visible = true
            timer.start()
        }

        function onCurrentChanged(current){
            modelFile.setCurrentDir(current)
            info_all.text = modelFile.rowCount()
            info_selected.text = modelFile.getSelectedCount()
        }
    }

    Connections {
        target: file_selector
        function onAdd(){
            internal.save()
        }
    }
}
