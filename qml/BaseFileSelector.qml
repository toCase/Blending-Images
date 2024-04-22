import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    id: file_selector




    QtObject{
        id: internal

        function load(selectedFolder){

            modelEmptyFile.loadModel(selectedFolder)
            dir_name.text = modelEmptyFile.getFolderName()
            info_all.text = modelEmptyFile.rowCount()
            info_selected.text = modelEmptyFile.getSelectedCount()

        }

        function makeCheckIndex(i, check){
            var scrollPosition = scrollTable.position

            modelEmptyFile.selectItem(i, check)

            scrollTable.position = scrollPosition
            grid_files.currentIndex = i

            // console.log(modelEmptyFile.getSelectedCount())
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

        function add(){

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
            cellHeight: 85 + 20

            clip: true

            model: modelEmptyFile

            delegate: Rectangle{

                width: grid_files.cellWidth
                height: grid_files.cellHeight

                // radius: 5

                required property string file_name
                required property bool selected
                required property int index

                CheckBox {
                    id: file_select
                    anchors.left:  parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    width: 20
                    height: 20
                    checked: selected
                }

                Image {
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    width: 76
                    height: 85
                    source: file_name
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        var check = !file_select.checked
                        internal.makeCheckIndex(index, check)

                    }
                    onContainsMouseChanged: {
                        if (containsMouse){
                            parent.color = "lightsteelblue"
                        } else {
                            parent.color = "transparent"
                        }
                    }

                }

            }

            highlight: Rectangle {
                color: "lightsteelblue";
                // radius: 5
            }
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
                }
            }
        }
    }

    FolderDialog {
        id: folderDialog
        currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        onAccepted: {
            internal.load(selectedFolder)
        }
    }
}
