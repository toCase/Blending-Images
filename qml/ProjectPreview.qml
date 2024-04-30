import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Item {

    signal back()

    function load() {
        canvas.requestPaint()

        internal.img_width = modelCollage.columnCount() * internal.cell_width
        internal.img_height = modelCollage.rowCount() * internal.cell_height
        internal.img_bg = modelCollage.getBG()
    }



    QtObject {
        id: internal

        property int cell_width: 76
        property int cell_height: 85

        property int img_width: 0
        property int img_height: 0
        property string img_bg: ""

        function saveAsImage(fileName){
            // var win = modelCollage.testWin()
            // var fname = fileName + ".jpg"
            // if (win) {
            //     fname = fileName
            // }

            // canvas.save(modelCollage.getFile(fname), Qt.size(internal.img_width, internal.img_height))

            modelCollage.saveImage(fileName)

        }

        function saveAsPDF(fileName){
            modelCollage.printPDF(fileName)
        }
    }

    RowLayout {
        id: menu
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: implicitHeight
        spacing: 10

        Button {
            id: but_close
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
            Layout.minimumWidth: implicitWidth
            Layout.maximumWidth: implicitWidth

            text: "< Назад"

            Material.background: clr_ORANGE
            Material.foreground: clr_DARK
            Material.roundedScale: Material.ExtraSmallScale

            onClicked: back()

        }
        Item {
            Layout.fillWidth: true
        }
        Button {
            id: but_upd
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
            Layout.minimumWidth: implicitWidth
            Layout.maximumWidth: implicitWidth

            text: "Сформировать"

            Material.background: clr_ORANGE
            Material.foreground: clr_DARK
            Material.roundedScale: Material.ExtraSmallScale

            onClicked: canvas.requestPaint()

        }

        Button {
            id: but_save
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
            Layout.minimumWidth: implicitWidth
            Layout.maximumWidth: implicitWidth

            text: "Сохранить в файл"

            Material.background: clr_ORANGE
            Material.foreground: clr_DARK
            Material.roundedScale: Material.ExtraSmallScale

            onClicked: fileDialog.open()

        }

    }

    Canvas {
        id: canvas
        anchors.top: menu.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        width: parent.width
        height: parent.height

        onPaint: {
            var ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            for(var r = 0; r < modelCollage.rowCount(); r++){
                for (var c = 0; c < modelCollage.columnCount(); c++){
                    var card = {}
                    card = modelCollage.makeCollage(r, c)

                    var x = c * internal.cell_width
                    var y = r * internal.cell_height
                    var t = card["displayType"]
                    var d = card["display"]

                    if (t){
                        ctx.drawImage(d, x, y, internal.cell_width, internal.cell_height)
                        ctx.save()
                    } else {
                        ctx.fillStyle = internal.img_bg
                        ctx.fillRect(x, y, internal.cell_width, internal.cell_height)
                        ctx.save()
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        // currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        fileMode: FileDialog.SaveFile
        nameFilters: ["Image file (*.jpg)", "PDF file (*.pdf)"]
        onAccepted: {
            if (selectedNameFilter.extensions[0] === "jpg"){
                internal.saveAsImage(selectedFile)
            } else {
                internal.saveAsPDF(selectedFile)
            }
        }
    }
}
