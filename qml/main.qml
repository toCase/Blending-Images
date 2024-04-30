import QtQuick
import QtQuick.Window
import QtQuick.Controls


Window {
    width: 1200
    height: 700
    visible: true
    title: qsTr("Blending Images")

    property color clr_ORANGE: "#FF9800"
    property color clr_DARK: "#32012F"
    property color clr_GREEN: "#746f67"
    property color clr_LIGHT: "#E2DFD0"

    property color clr_WHITE: "#FFFFFF"
    property color clr_CELL: "#C9D4C0"


    App {
        id: app
        anchors.fill: parent
    }
}
