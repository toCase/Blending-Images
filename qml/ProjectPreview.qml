import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Item {

    signal back()

    function load() {
        // canvas.requestPaint()

        // internal.img_width = modelCollage.columnCount() * internal.cell_width
        // internal.img_height = modelCollage.rowCount() * internal.cell_height
        // internal.img_bg = modelCollage.getBG()

        img_preview.source = ""
        img_preview.source = modelCollage.getPreviewUrl()

    }



    QtObject {
        id: internal

        property int cell_width: 76
        property int cell_height: 85

        property int img_width: 0
        property int img_height: 0
        property string img_bg: ""

        function saveAsImage(fileName){
            modelCollage.saveImagePIL(fileName, false)
        }

        function saveAsPDF(fileName){
            modelCollage.printPillowPDF(fileName)
        }

        function openPDFSetting(){
            sett.visible = !sett.visible
            sett_intent.text = String(modelCollage.getSetting())
        }

        function savePDFSetting(){
            var x = Number(sett_intent.text)
            modelCollage.setSetting(x)
            sett.visible = false

        }
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 5

        RowLayout {
            id: menu
            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
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
            // Button {
            //     id: but_upd
            //     Layout.minimumHeight: implicitHeight
            //     Layout.maximumHeight: implicitHeight
            //     Layout.minimumWidth: implicitWidth
            //     Layout.maximumWidth: implicitWidth

            //     text: "Сформировать"

            //     Material.background: clr_ORANGE
            //     Material.foreground: clr_DARK
            //     Material.roundedScale: Material.ExtraSmallScale

            //     onClicked: canvas.requestPaint()

            // }

            Button {
                id: but_save
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight
                Layout.minimumWidth: implicitWidth
                Layout.maximumWidth: implicitWidth

                text: "Сохранить JPG"

                Material.background: clr_ORANGE
                Material.foreground: clr_DARK
                Material.roundedScale: Material.ExtraSmallScale

                onClicked: fileDialogJPG.open()

            }

            Button {
                id: but_pdf
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight
                Layout.minimumWidth: implicitWidth
                Layout.maximumWidth: implicitWidth

                text: "Сохранить PDF"

                Material.background: clr_ORANGE
                Material.foreground: clr_DARK
                Material.roundedScale: Material.ExtraSmallScale

                onClicked: fileDialogPDF.open()

            }
            Item {
                Layout.fillWidth: true
            }
            Button {
                id: but_sett_pdf
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: implicitHeight
                Layout.minimumWidth: implicitWidth
                Layout.maximumWidth: implicitWidth

                text: "Настройки PDF"

                Material.background: clr_ORANGE
                Material.foreground: clr_DARK
                Material.roundedScale: Material.ExtraSmallScale

                onClicked: {

                    internal.openPDFSetting()
                }
            }
        }

        Pane {
            id: sett
            Layout.fillWidth: true
            Layout.minimumHeight: 60
            Layout.maximumHeight: 60
            visible: but_sett_pdf.checked

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "Отступы для страницы PDF (mm): "
                }

                TextField {
                    id: sett_intent
                    Layout.minimumHeight: but_sett_save.height - 10
                    Layout.maximumHeight: but_sett_save.height - 10
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 100

                    validator: RegularExpressionValidator{
                        regularExpression: /^[1-9]\d{0,1}$/
                    }
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter

                    onFocusChanged: {
                        if (focus){
                            selectAll()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: but_sett_save
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight
                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth

                    text: "Сохранить"

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.savePDFSetting()
                }
            }
        }


        // Pane {
        //     Layout.fillWidth: true
        //     Layout.fillHeight: true

        //     Canvas {
        //         id: canvas
        //         anchors.centerIn: parent

        //         width: parent.width
        //         height: parent.height

        //         onPaint: {
        //             var ctx = canvas.getContext('2d');
        //             ctx.clearRect(0, 0, canvas.width, canvas.height);

        //             for(var r = 0; r < modelCollage.rowCount(); r++){
        //                 for (var c = 0; c < modelCollage.columnCount(); c++){
        //                     var card = {}
        //                     card = modelCollage.makeCollage(r, c)

        //                     var x = c * internal.cell_width
        //                     var y = r * internal.cell_height
        //                     var t = card["displayType"]
        //                     var d = card["display"]

        //                     if (t){
        //                         ctx.drawImage(d, x, y, internal.cell_width, internal.cell_height)
        //                         ctx.save()
        //                     } else {
        //                         ctx.fillStyle = internal.img_bg
        //                         ctx.fillRect(x, y, internal.cell_width, internal.cell_height)
        //                         ctx.save()
        //                     }
        //                 }
        //             }
        //         }
        //     }


        // }
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                id: img_preview
                anchors.top: parent.top
                anchors.left: parent.left

                width: implicitWidth
                height: implicitHeight

                cache: false
            }
        }
    }

    Connections {
        target: modelCollage
        function onPreviewReady(){
            img_preview.source = ""
            img_preview.source = modelCollage.getPreviewUrl()
        }
    }

    FileDialog {
        id: fileDialogJPG
        fileMode: FileDialog.SaveFile
        nameFilters: ["Image file (*.jpg)"]
        onAccepted: internal.saveAsImage(selectedFile)
    }

    FileDialog {
        id: fileDialogPDF
        fileMode: FileDialog.SaveFile
        nameFilters: ["PDF file (*.pdf)"]
        onAccepted: internal.saveAsPDF(selectedFile)
    }
}
