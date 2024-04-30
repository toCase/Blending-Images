import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Imagine
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

            var fname = fileName + ".jpg"
            canvas.save(modelCollage.getFile(fname), Qt.size(internal.img_width, internal.img_height))

        }

        function saveAsPDF(fileName){
            modelCollage.printPDF(fileName)
            // var pdf = new QtPdfWriter(fileName + ".pdf")
            // pdf.setPageSize(Qt.size(internal.img_width, internal.img_height))

            // var ctx = pdf.paintEngine()
            // ctx.clearRect(0, 0, internal.img_width, internal.img_height)

            // for (var r = 0; r < modelCollage.rowCount(); r++) {
            //     for (var c = 0; c < modelCollage.columnCount(); c++) {
            //         var card = modelCollage.makeCollage(r, c)
            //         var x = c * internal.cell_width
            //         var y = r * internal.cell_height
            //         var t = card["displayType"]
            //         var d = card["display"]

            //         if (t) {
            //             ctx.drawImage(d, x, y, internal.cell_width, internal.cell_height)
            //             ctx.save()
            //         } else {
            //             ctx.fillStyle = internal.img_bg
            //             ctx.fillRect(x, y, internal.cell_width, internal.cell_height)
            //             ctx.save()
            //         }
            //     }
            // }

            // pdf.end()
        }
    }

    RowLayout {
        id: menu
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 35
        spacing: 10

        Button {
            id: but_close
            Layout.fillHeight: true
            Layout.minimumWidth: implicitWidth
            Layout.maximumWidth: implicitWidth

            text: "< Back"

            onClicked: back()

        }
        Item {
            Layout.fillWidth: true
        }
        Button {
            id: but_upd
            Layout.fillHeight: true
            Layout.minimumWidth: implicitWidth
            Layout.maximumWidth: implicitWidth

            text: "UPDATE"

            onClicked: canvas.requestPaint()

        }

        Button {
            id: but_save
            Layout.fillHeight: true
            Layout.minimumWidth: implicitWidth
            Layout.maximumWidth: implicitWidth

            text: "SAVE"

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
