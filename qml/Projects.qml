import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Item {

    StackView {
        id: project_stack
        anchors.fill: parent
        initialItem: projectMain
    }

    ProjectMain {
        id: projectMain
        visible: false
    }

    Connections {
        target: projectMain
        function onCreate(){
            projectCard.load()
            project_stack.push(projectCard)
        }
        function onEdit(idx){
            projectCard.load(idx)
            project_stack.push(projectCard)
        }
    }


    ProjectCard {
        id: projectCard
        visible: false
    }

    Connections {
        target: projectCard
        function onCancel(){
            project_stack.pop()
        }
    }

}
