import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    id: file_selector


    signal add()



    function onSaved(){
        internal.load()
        info_selected.text = modelEmptyFile.getSelectedCount()
    }

    QtObject{
        id: internal

        function setFolder(selectedFolder){
            modelEmptyFile.setFolderUrl(selectedFolder)
            load()
        }

        function load(){
            modelEmptyFile.loadModel()
            dir_name.text = modelEmptyFile.getFolderName()
            info_all.text = modelEmptyFile.rowCount()
            info_selected.text = modelEmptyFile.getSelectedCount()
        }

        function makeCheckIndex(i, check){
            var scrollPosition = scrollTable.position

            modelEmptyFile.selectItem(i, check)
            scrollTable.position = scrollPosition
            grid_files.currentIndex = i
            info_selected.text = modelEmptyFile.getSelectedCount()
        }

        function selectAll(){
            modelEmptyFile.selectAll()
            info_selected.text = modelEmptyFile.getSelectedCount()
        }

        function unselectAll(){
            modelEmptyFile.unselectAll()
            info_selected.text = modelEmptyFile.getSelectedCount()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Pane {
            id: form_directory

            Layout.fillWidth: true
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Label {
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true
                    text: "Директория: "
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }

                TextField {
                    id: dir_name
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }

                Button {
                    id: but_dir_save

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "..."

                    onClicked: folderDialog.open()
                }
            }
        }


        GridView {
            id: grid_files
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.rightMargin: 10
            Layout.leftMargin: 10

            cellWidth: 76 + 20 + 20
            cellHeight: 85 + 20 + 20

            clip: true

            model: modelEmptyFile

            delegate: Rectangle{

                width: grid_files.cellWidth - 20
                height: grid_files.cellHeight - 20

                radius: 5

                required property string file_name
                required property bool selected
                required property bool saved
                required property int index

                color:
                    if (saved) {
                        "#F3ECA5"
                    } else {
                        "transparent"
                    }
                opacity:
                    if (saved) {
                        0.9
                    } else {
                        1
                    }

                border.width: 6
                border.color:
                    if (selected) {
                        "#406684"
                    } else {
                        "transparent"
                    }

                Image {

                    anchors.centerIn: parent
                    width: 76
                    height: 85
                    source: file_name
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        internal.makeCheckIndex(index, !selected)

                    }
                    onContainsMouseChanged: {
                        if (containsMouse){
                            parent.border.color = "#793690"
                        } else {
                            if (selected) {
                                parent.border.color = "#406684"
                            } else {
                                parent.border.color = "transparent"
                            }
                        }
                    }

                }

            }

            // highlight: Rectangle {
            //     border.color: "#406684";
            //     border.width: 6
            //     radius: 5
            // }
            highlightMoveDuration: 0
            focus: true
            ScrollBar.vertical: ScrollBar { id:scrollTable }

        }


        Pane {
            id: info

            Layout.fillWidth: true
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth

                    text: "Всего:"
                    font.pointSize: 13
                }
                Label {
                    id: info_all
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    text: ""
                    font.pointSize: 13
                }
                Label {
                    Layout.leftMargin: 20
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth

                    text: "Выбрано: "
                    font.pointSize: 13
                }

                Label {
                    id: info_selected
                    Layout.fillHeight: true
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
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5
                Button {
                    id: but_dir_selectAll

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "Выбрать все"

                    onClicked: internal.selectAll()

                }

                Button {
                    id: but_dir_unselectAll

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "Снять выбор"
                    onClicked: internal.unselectAll()

                }
                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: but_dir_add

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "Добавить"

                    onClicked: add()
                }
            }
        }
    }

    FolderDialog {
        id: folderDialog
        onAccepted: {
            internal.setFolder(selectedFolder)
        }
    }
}
