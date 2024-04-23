import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Item {

    Label {
        anchors.centerIn: parent
        text: "PROJECTS"
        font.pointSize: 19
    }

}


// import QtQuick 2.0
// import QtQml.Models

// Item{

//     GridView {
//         id: gridView
//         width: parent.width
//         height: parent.height

//         // Отключаем прокрутку
//         boundsBehavior: Flickable.StopAtBounds

//         model: myModel
//         delegate: Item {
//             width: 100
//             height: 100
//             Rectangle {
//                 width: 50
//                 height: 50
//                 color: selected ? "blue" : "green"
//                 MouseArea {
//                     anchors.fill: parent
//                     onClicked: {
//                         selected = !selected;
//                         myModel.setProperty(index, "selected", selected);
//                     }
//                 }
//             }
//         }
//     }

//     Rectangle {
//         id: selectionRect
//         color: "transparent"
//         border.color: "blue"
//         border.width: 2
//         visible: false
//     }

//     property real startX: 0
//     property real startY: 0

//     MouseArea {
//         id: selectionArea
//         anchors.fill: parent
//         onClicked: {
//             selectionRect.visible = true;
//             selectionRect.width = 0;
//             selectionRect.height = 0;
//             startX = mouseX;
//             startY = mouseY;
//             selectionRect.x = mouseX;
//             selectionRect.y = mouseY;
//         }
//         onMouseXChanged: {
//             if (mouseX > startX) {
//                 selectionRect.width = mouseX - startX;
//             } else {
//                 selectionRect.width = startX - mouseX;
//                 selectionRect.x = mouseX;
//             }
//         }
//         onMouseYChanged: {
//             if (mouseY > startY) {
//                 selectionRect.height = mouseY - startY;
//             } else {
//                 selectionRect.height = startY - mouseY;
//                 selectionRect.y = mouseY;
//             }
//         }
//         onPressed: {
//             selectionRect.visible = true;
//             startX = mouseX;
//             startY = mouseY;
//         }
//         onReleased: {
//             selectionRect.visible = false;
//             selectItemsInRect(selectionRect.x, selectionRect.y, selectionRect.width, selectionRect.height);
//         }
//     }

//     function selectItemsInRect(x, y, width, height) {

//         console.log("RECT: x: ", selectionRect.x, " y: ", selectionRect.y, " w: ", selectionRect.width, "h: ", selectionRect.height)
//         console.log(gridView.contentItem.children.length)



//         for (var i = 0; i < gridView.contentItem.children.length; ++i) {
//             var item = gridView.contentItem.children[i];
//             console.log("X: ", item.x, " Y: ", item.y)


//             var modelIndex = item.index;
//             if (item.x + item.width > x && item.x < x + width &&
//                     item.y + item.height > y && item.y < y + height) {
//                 myModel.setProperty(modelIndex, "selected", true);

//                 console.log("YES")
//             }
//             myModel.modelReset()
//         }
//     }

//     function updateModel() {
//         for (var i = 0; i < gridView.contentItem.children.length; ++i) {
//             var item = gridView.contentItem.children[i];
//             var modelIndex = item.model.index;
//             gridView.model.setProperty(modelIndex, "selected", item.model.selected);
//         }
//     }

//     ListModel {
//         id: myModel
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         ListElement { text: "Item 1"; selected: false }
//         ListElement { text: "Item 2"; selected: false }
//         ListElement { text: "Item 3"; selected: false }
//         // Add more ListElements as needed
//     }


// }
