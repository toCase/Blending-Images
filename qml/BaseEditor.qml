import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Item {
    id: baseEditor




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
            color: "#707b90"
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

            Pane {
                id: editor

                Layout.fillWidth: true
                Layout.fillHeight: true
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
                    color: "#FFFFFF"

                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter

                }

            }

        }
    }

    Timer {
        id: timer
        interval: 7000
        repeat: false
        running: false

        onTriggered: {
            messageBox.visible = false
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
    }

}
