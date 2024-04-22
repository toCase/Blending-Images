import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Item {
    id: base

    ListModel {
        id: testModel

        ListElement {
            idx: 1
            name: "Test A"
        }

        ListElement {
            idx: 2
            name: "Test B"
        }

        ListElement {
            idx: 3
            name: "Test C"
        }
    }

    signal baseEdit(idx:int)

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Pane {
            id: menu

            Layout.fillWidth: true
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Button {
                    id: but_add

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "ADD"

                    onClicked: base.baseEdit(0)
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: but_del

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "DEL"

                    // onClicked: internal.openProject()

                }
            }
        }

        Pane {
            id: form_directory
            visible: false

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
                    text: "Name: "
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

                    text: "SAVE"
                }
            }
        }

        Pane {
            id: directory

            Layout.fillWidth: true
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5


                ListView {
                    id: dirSelector
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: modelDir
                    orientation: ListView.Horizontal
                    delegate: Rectangle {
                        // required property int idx
                        required property string dir

                        required property int index

                        width: dirSelector.width / modelDir.rowCount()
                        height: dirSelector.height
                        color: dirSelector.currentIndex === index ? "#ff6600" : "#707b90"
                        Label{
                            anchors.centerIn: parent
                            text: dir
                            color: "#ffffff"//sett.appGetColor(parent.color)
                            font.family: "Roboto"
                            font.pointSize: 16
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // internal.selectSpec(idx)
                                dirSelector.currentIndex = index
                            }
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                    focus: true
                }

                Button {
                    id: but_dir_add

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "+"
                }
            }
        }

        GridView {
            id: grid
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

}
