import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    id: app

    property int row_HEIGHT: 40

    QtObject{
        id: internal

        property int win_item: 0 // идентификатор окна

        // function openBase() {
        //     if (win_item !== 1){
        //         win_item = 1
        //         app_stack.pop()
        //         app_stack.push(base)
        //     }
        // }

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
                base_editor.load()
                app_stack.push(base_editor)
            }
        }

    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Rectangle {
            id: top_menu

            Layout.fillWidth: true
            Layout.minimumHeight: app.row_HEIGHT
            Layout.maximumHeight: app.row_HEIGHT

            color: "transparent"

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Button {
                    id: but_base

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: app.row_HEIGHT
                    Layout.maximumHeight: app.row_HEIGHT

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
                    Layout.minimumHeight: app.row_HEIGHT
                    Layout.maximumHeight: app.row_HEIGHT

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

    Projects {
        id: projects
        visible: false
    }

    BaseEditor {
        id: base_editor
        visible: false
    }


}
