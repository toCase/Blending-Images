import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Imagine
import Qt.labs.qmlmodels

Item {

    signal back()
    signal preview()

    property int currentFile: 0

    function load(){

    }

    QtObject {
        id: internal

        function selectFile(i, selected){
            var scrollposition = scrollTable.position

            console.log("SELECTED: ", selected)


            currentFile = modelFile.selectItemOne(i, selected)
            grid.currentIndex = i

            scrollTable.position = scrollposition
            console.log('CURRENT FILE: ', currentFile)

        }
    }

    Connections{
        target: modelDir
        function onCurrentChanged(current){
            console.log(current)
            modelFile.setCurrentDir(current)

        }
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Pane {
            id: menu
            Layout.fillWidth: true
            Layout.minimumHeight: 60
            Layout.maximumHeight: 60

            RowLayout {
                anchors.fill: parent
                spacing: 10

                Button {
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth

                    text: "< Back"
                    onClicked: back()
                }
                Button {
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth

                    text: "Preview"
                    onClicked: preview()
                }

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    text: "Удаление"
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    color: mode.checked ? "#786e8a": "#29c200"

                }

                Switch {
                    id: mode
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    checked: true

                }
                Label {
                    Layout.fillHeight: true
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    text: "Вставка"
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    color: mode.checked ? "#29c200" : "#786e8a"

                }
                Item {
                    Layout.fillWidth: true
                }


            }
        }

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

                    Pane {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 55
                        Layout.maximumHeight: 55

                        ComboBox {
                            id: combo_dir
                            anchors.fill: parent
                            model: modelDir
                            textRole: "dir"
                            valueRole: "id"
                            onActivated: {
                                modelDir.setCurrent(currentValue)
                            }
                        }
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

                        model: modelFile

                        delegate: Rectangle {
                            width: grid.cellWidth - 20
                            height: grid.cellHeight - 20

                            radius: 5

                            required property string file
                            required property bool selected
                            required property int index

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
                        highlightMoveDuration: 0
                        focus: true
                        ScrollBar.vertical: ScrollBar { id:scrollTable }

                    }

                }


                Rectangle {

                    Layout.fillHeight: true
                    Layout.minimumWidth: 3
                    Layout.maximumWidth: 3

                    color: "#007c89"

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
                            color: "#C9D4C0"
                        }

                        color: selected ? "#406684": "transparent"

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

                                console.log("ID: ", idx)
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
