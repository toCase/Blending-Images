import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels

Item {

    signal back()
    signal preview()

    property int currentFile: 0

    function load(){
        combo_dir.currentIndex = 0
        modelDir.setCurrent(modelDir.get(0, 'id'))
    }

    QtObject {
        id: internal

        function selectFile(i, selected){
            var scrollposition = scrollTable.position
            currentFile = modelX.selectItemOne(i, selected)
            grid.currentIndex = i
            scrollTable.position = scrollposition
        }

        function setFilter(f){
            modelX.setFilterKey(f)
        }

        function makePreview(){
            modelCollage.saveImagePIL("preview", true)
            preview()
        }
    }

    Connections{
        target: modelDir
        function onCurrentChanged(current){
            modelX.setCurrentDir(current)
        }
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        // Pane {
        //     id: menu
        //     Layout.fillWidth: true
        //     Layout.minimumHeight: implicitHeight
        //     Layout.maximumHeight: implicitHeight

        //     RowLayout {
        //         anchors.fill: parent
        //         spacing: 10

        //         Button {
        //             Layout.minimumHeight: implicitHeight
        //             Layout.maximumHeight: implicitHeight
        //             Layout.minimumWidth: implicitWidth
        //             Layout.maximumWidth: implicitWidth

        //             text: "< Назад"

        //             Material.background: clr_ORANGE
        //             Material.foreground: clr_DARK
        //             Material.roundedScale: Material.ExtraSmallScale

        //             onClicked: back()
        //         }
        //         Button {
        //             Layout.minimumHeight: implicitHeight
        //             Layout.maximumHeight: implicitHeight
        //             Layout.minimumWidth: implicitWidth
        //             Layout.maximumWidth: implicitWidth

        //             text: "Подготовка"

        //             Material.background: clr_ORANGE
        //             Material.foreground: clr_DARK
        //             Material.roundedScale: Material.ExtraSmallScale

        //             onClicked: internal.makePreview()
        //         }

        //         Item {
        //             Layout.fillWidth: true
        //         }

        //         Label {
        //             Layout.minimumHeight: implicitHeight
        //             Layout.maximumHeight: implicitHeight
        //             Layout.minimumWidth: implicitWidth
        //             Layout.maximumWidth: implicitWidth
        //             text: "Удаление"
        //             horizontalAlignment: Qt.AlignRight
        //             verticalAlignment: Qt.AlignVCenter
        //             color: mode.checked ? clr_DARK : Material.color(Material.Pink)
        //             font.bold: !mode.checked
        //             font.pointSize: mode.checked ? 11 : 13

        //         }

        //         Switch {
        //             id: mode
        //             Layout.minimumHeight: implicitHeight
        //             Layout.maximumHeight: implicitHeight
        //             Layout.minimumWidth: implicitWidth
        //             Layout.maximumWidth: implicitWidth
        //             checked: true

        //         }
        //         Label {
        //             Layout.minimumHeight: implicitHeight
        //             Layout.maximumHeight: implicitHeight
        //             Layout.minimumWidth: implicitWidth
        //             Layout.maximumWidth: implicitWidth
        //             text: "Вставка"
        //             horizontalAlignment: Qt.AlignRight
        //             verticalAlignment: Qt.AlignVCenter
        //             color: mode.checked ? Material.color(Material.Green) : clr_DARK
        //             font.bold: mode.checked
        //             font.pointSize: mode.checked ? 13 : 11

        //         }
        //         Item {
        //             Layout.fillWidth: true
        //         }


        //     }
        // }

        Item {

            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                spacing: 10

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.minimumWidth: parent.width * 0.3
                    Layout.maximumWidth: parent.width * 0.3

                    spacing: 5

                    RowLayout {
                        anchors.fill: parent
                        spacing: 10

                        Button {
                            Layout.minimumHeight: implicitHeight
                            Layout.maximumHeight: implicitHeight
                            Layout.minimumWidth: implicitWidth
                            Layout.maximumWidth: implicitWidth

                            text: "< Назад"

                            Material.background: clr_ORANGE
                            Material.foreground: clr_DARK
                            Material.roundedScale: Material.ExtraSmallScale

                            onClicked: back()
                        }
                        Button {
                            Layout.minimumHeight: implicitHeight
                            Layout.maximumHeight: implicitHeight
                            Layout.minimumWidth: implicitWidth
                            Layout.maximumWidth: implicitWidth

                            text: "Подготовка"

                            Material.background: clr_ORANGE
                            Material.foreground: clr_DARK
                            Material.roundedScale: Material.ExtraSmallScale

                            onClicked: internal.makePreview()
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                    }

                    

                    ComboBox {
                        id: combo_dir

                        Layout.fillWidth: true
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        model: modelDir
                        textRole: "dir"
                        valueRole: "id"
                        onActivated: {
                            modelDir.setCurrent(currentValue)
                        }
                    }

                    TextField {
                        id: filter

                        Layout.fillWidth: true
                        Layout.minimumHeight: implicitHeight
                        Layout.maximumHeight: implicitHeight

                        placeholderText: "Поиск..."

                        onTextEdited: internal.setFilter(text)
                    }


                    GridView {
                        id: grid

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Layout.rightMargin: 10
                        Layout.leftMargin: 10

                        cellWidth: 76 + 20 + 20
                        cellHeight: 85 + 20 + 20

                        clip: true

                        model: modelX

                        delegate: Rectangle {
                            width: grid.cellWidth - 20
                            height: grid.cellHeight - 20

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
                                    internal.selectFile(index, !selected)
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

                }


                Rectangle {

                    Layout.fillHeight: true
                    Layout.minimumWidth: 3
                    Layout.maximumWidth: 3

                    color: clr_DARK

                }



                TableView {
                    id: table
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    columnSpacing: 2
                    rowSpacing: 2

                    model: modelCollage

                    clip: true
                    delegate: Rectangle {
                        required property bool selected
                        required property bool displayType
                        required property string display
                        required property int idx

                        implicitWidth: 76 + 10
                        implicitHeight: 85 + 10

                        Image {
                            anchors.centerIn: parent
                            width: 76
                            height: 85
                            visible: displayType
                            source: displayType ? display : ""
                        }

                        Rectangle {
                            anchors.centerIn: parent
                            width: 76
                            height: 85
                            visible: !displayType
                            color: clr_CELL
                        }

                        color: selected ? clr_ORANGE : "transparent"

                        MouseArea {
                            anchors.fill: parent
                            onClicked:
                            {
                                // var idx = modelCollage.index(row,column)
                                // console.log("Clicked cell: ", modelCollage.data(idx))
                                // console.log("Clicked row: ", row, " col: ", column)
                                // modelCollage.setCurrentCell(row, column)
                                if (mode.checked) {
                                    if (currentFile === 0){
                                        modelCollage.setCurrentCell(row, column)
                                    } else {
                                        modelCollage.makeFile(row, column, currentFile)
                                    }
                                } else {
                                    modelCollage.makeFile(row, column, 0)
                                }
                            }
                            onDoubleClicked: {
                                modelCollage.makeFile(row, column, 0)
                            }
                        }
                    }
                    ScrollBar.vertical: ScrollBar { id:scrollVTable }
                    ScrollBar.horizontal: ScrollBar { id:scrollHTable }
                }
            }
        }
    }
}

