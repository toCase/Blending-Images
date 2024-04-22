import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Item {

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
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Button {
                    id: but_base

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "База"

                    onClicked: internal.openBaseEditor()
                }

                Button {
                    id: but_project

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "Project"

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

    Item {
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
