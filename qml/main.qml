import QtQuick
import QtQuick.Window
import QtQuick.Controls


Window {
    width: 1200
    height: 700
    visible: true
    title: qsTr("Blending Images")

    property color clr_ORANGE: "#A5C9CA"
    property color clr_DARK: "#2C3333"
    property color clr_GREEN: "#395B64"
    property color clr_LIGHT: "#E7F6F2"

    property color clr_WHITE: "#FFFFFF"
    property color clr_CELL: "#C9D4C0"


    App {
        id: app
        anchors.fill: parent
    }
}
