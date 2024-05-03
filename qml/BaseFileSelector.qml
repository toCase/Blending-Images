import QtQuick
import QtQuick.Controls
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
            if (modelEmptyFile.getFolderName()){
                dir_name.text = modelEmptyFile.getFolderName()
                info_all.text = modelEmptyFile.rowCount()
                info_selected.text = modelEmptyFile.getSelectedCount()
            }
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

        function makeFilter(f){
            if (f.lenght > 0){
                modelEmptyFile.setFilter()
            } else {
                modelEmptyFile.setFilter(f)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Pane {
            id: form_directory

            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Label {
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    text: "Директория: "
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }

                TextField {
                    id: dir_name

                    Layout.fillWidth: true
                    Layout.minimumHeight: parent.height - 10
                    Layout.maximumHeight: parent.height - 10

                    readOnly: true

                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }

                Button {
                    id: but_dir_save

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "..."

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: folderDialog.open()
                }
            }
        }

        // RowLayout {
        //     Layout.fillWidth: true
        //     Layout.minimumHeight: implicitHeight
        //     Layout.maximumHeight: implicitHeight
        //     spacing: 5

        //     Label {
        //         Layout.minimumWidth: implicitWidth
        //         Layout.maximumWidth: implicitWidth
        //         Layout.minimumHeight: implicitHeight
        //         Layout.maximumHeight: implicitHeight
        //         text: "Поиск: "
        //         horizontalAlignment: Qt.AlignHCenter
        //         verticalAlignment: Qt.AlignVCenter
        //     }

        //     TextField {
        //         id: dir_filter

        //         Layout.fillWidth: true
        //         Layout.minimumHeight: but_clear.height - 10
        //         Layout.maximumHeight: but_clear.height - 10

        //         horizontalAlignment: Qt.AlignHCenter
        //         verticalAlignment: Qt.AlignVCenter

        //         onTextEdited: internal.makeFilter(text)
        //     }

        //     Button {
        //         id: but_clear

        //         Layout.minimumWidth: implicitWidth
        //         Layout.maximumWidth: implicitWidth
        //         Layout.minimumHeight: implicitHeight
        //         Layout.maximumHeight: implicitHeight

        //         text: "<X"

        //         Material.background: clr_ORANGE
        //         Material.foreground: clr_DARK
        //         Material.roundedScale: Material.ExtraSmallScale

        //         onClicked: dir_filter.clear()
        //     }
        // }


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
                        clr_GREEN
                    } else {
                        clr_WHITE
                    }

                border.width: 4
                border.color:
                    if (selected) {
                        clr_ORANGE
                    } else {
                        if (saved) {
                            clr_GREEN
                        } else {
                            clr_WHITE
                        }
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
                            parent.border.color = clr_DARK
                        } else {
                            if (selected) {
                                parent.border.color = clr_ORANGE
                            } else {
                                if (saved) {
                                    parent.border.color = clr_GREEN
                                } else {
                                    parent.border.color = clr_WHITE
                                }
                            }
                        }
                    }
                }
            }
            highlightMoveDuration: 0
            focus: true
            ScrollBar.vertical: ScrollBar { id:scrollTable }

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

                Button {
                    id: but_dir_add

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "Добавить"

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

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
