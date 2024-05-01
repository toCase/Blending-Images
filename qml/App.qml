import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {

    property int row_HEIGHT: 55

    QtObject{
        id: internal

        property int win_item: 0 // идентификатор окна

        function openBase() {
            if (win_item !== 1){
                win_item = 1
                app_stack.pop()
                app_stack.push(base)
            }
        }

        function openProject() {
            if (win_item !== 2){
                win_item = 2
                app_stack.pop()
                app_stack.push(projects)
            }
        }

        function openBaseEditor(){
            if (win_item !== 3){
                win_item = 3
                app_stack.pop()
                app_stack.push(base_editor)
            }
        }

    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Pane {
            id: top_menu

            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Button {
                    id: but_base

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "База"

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.openBaseEditor()
                }

                Button {
                    id: but_project

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "Проекты"

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.openProject()

                }
                Item {
                    Layout.fillWidth: true
                }
            }
        }

        StackView {
            id: app_stack
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: lab_start
        }
    }

    Pane {
        id: lab_start
        visible: false

        Label {
            anchors.centerIn: parent
            text: "Blending Images"
            font.pointSize: 19
        }
    }

    Base {
        id: base
        visible: false
    }

    Connections{
        target: base
        function onBaseEdit(idx){
            console.info(idx)
            internal.openBaseEditor()
        }
    }

    Projects {
        id: projects
        visible: false
    }

    BaseEditor {
        id: base_editor
        visible: false
    }


}
