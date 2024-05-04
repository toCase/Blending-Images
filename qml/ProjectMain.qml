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
            preview.source = ""

            var r = modelProject.delete()
            var count = modelProject.rowCount()
            if (r === true & count > 0) {
                selectProject(0)
            }
        }

        function filterEdit(f){
            if (f.length > 0){
                but_clearF.visible = true
            } else {
                but_clearF.visible = false
            }
            modelProject.setFilter(f)
        }

        function filterClear(){
            modelProject.setFilter("")
            filter.clear()
            but_clearF.visible = false
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
                spacing: 1

                Button {
                    id: but_create
                    Layout.leftMargin: 50
                    Layout.minimumWidth: 150
                    Layout.maximumWidth: 150
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
                Item {
                    Layout.fillWidth: true
                }

                TextField {
                    id: filter
                    Layout.minimumWidth: 250
                    Layout.maximumWidth: 250
                    Layout.minimumHeight: but_create.height - 10
                    Layout.maximumHeight: but_create.height - 10

                    placeholderText: "Поиск..."

                    onTextEdited: internal.filterEdit(filter.text)
                }

                ToolButton {
                    id: but_clearF

                    visible: false

                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth

                    text: "X"

                    onClicked: internal.filterClear()

                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5

            Image {
                id: preview


                Layout.minimumWidth: 250
                Layout.maximumWidth: 250

                Layout.minimumHeight: 300
                Layout.maximumHeight: 300
                Layout.alignment: Qt.AlignBottom

                fillMode: Image.PreserveAspectFit
                smooth: true
                cache: false
            }

            ListView {
                id: project_list
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

                highlight: Rectangle { color: clr_ORANGE; radius: 5 }
                highlightMoveDuration: 0
                highlightMoveVelocity: 10
                focus: true
                ScrollBar.vertical: ScrollBar{}
            }
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
                    Layout.leftMargin: 50
                    Layout.minimumWidth: 150
                    Layout.maximumWidth: 150
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

    Connections{
        target: modelProject
        function onImgReady(file) {
            preview.source = file
        }
    }
}
