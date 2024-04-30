import QtQuick
import QtQuick.Controls
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

        function onOpen(idx){
            projectConstructor.load()
            var cardID = Number(modelProject.get(idx, "id"))
            var cols = Number(modelProject.get(idx, "columns"))
            var rows = Number(modelProject.get(idx, "rows"))
            var bg = String(modelProject.get(idx, "bg"))

            modelCollage.setProject(cardID, rows, cols, bg)
            project_stack.push(projectConstructor)
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

    ProjectConstructor {
        id: projectConstructor
        visible: false
    }

    Connections {
        target: projectConstructor
        function onBack(){
            project_stack.pop()
        }
        function onPreview(){
            projectPreview.load()
            project_stack.push(projectPreview)

        }
    }

    ProjectPreview {
        id: projectPreview
        visible: false
    }
    Connections {
        target: projectPreview
        function onBack(){
            project_stack.pop()

        }
    }
}
