import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {

    signal create()
    signal edit(idx:int)
    signal open(idx:int)


    QtObject {
        id: internal

        function selectProject(i){
            project_list.currentIndex = i
            modelProject.setCurrent(i)
        }

        function openProject(i){
            selectProject(i)
        }

        function delProject(){
            var r = modelProject.delete()
            var count = modelProject.rowCount()
            if (r === true & count > 0) {
                selectProject(0)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Pane {
            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight

            RowLayout {
                anchors.fill: parent
                spacing: 10

                Button {
                    id: but_create
                    Layout.minimumWidth: 120
                    Layout.maximumWidth: 120
                    // Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "Создать"

                    // Material.variant: Material.Dense
                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: create()
                }

                Label {
                    Layout.fillWidth: true
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    text: "Проекты"
                    font.pointSize: 18
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }

        ListView {
            id: project_list
            Layout.leftMargin: but_create.width + 20
            Layout.rightMargin: 20
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip:true

            model: modelProject
            delegate: Item {
                height: 40
                width: project_list.width

                required property int index
                required property string name

                RowLayout{
                    anchors.fill: parent
                    spacing: 10

                    Label {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.leftMargin: 25

                        text: name
                        horizontalAlignment: Qt.AlignLeft
                        verticalAlignment: Qt.AlignVCenter
                        font.pointSize: 13

                        MouseArea {
                            anchors.fill: parent
                            onClicked:internal.selectProject(index)
                            onDoubleClicked: open(index)
                        }
                    }


                    Button {
                        Layout.minimumWidth: implicitWidth
                        Layout.maximumWidth: implicitWidth
                        Layout.fillHeight: true
                        flat: true
                        text: '\u22EE'

                        Material.roundedScale: Material.ExtraSmallScale

                        onClicked: edit(index)
                    }
                }
            }

            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            highlightMoveDuration: 0
            highlightMoveVelocity: 10
            focus: true
        }

        Pane {
            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight

            RowLayout {
                anchors.fill: parent
                spacing: 10

                Button {
                    id: but_del
                    Layout.minimumWidth: 120
                    Layout.maximumWidth: 120
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "Удалить"

                    Material.background: Material.Pink
                    Material.foreground: clr_WHITE
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.delProject()
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }
    }
}
