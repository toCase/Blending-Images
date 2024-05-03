import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {

    signal error(message:string)

    function load(){
        internal.current_idx = 0
        dirSelector.currentIndex = 0
        internal.select(modelDir.get(0, 'id'))
    }

    QtObject {
        id: internal

        property int current_idx: 0

        function add() {
            modelDir.setCurrent(0)
            dir_name.clear()
            but_dir_del.visible = false
            form_directory.visible = true
        }

        function edit(i){
            dir_name.text = modelDir.get(current_idx, 'dir')
            but_dir_del.visible = true
            form_directory.visible = true
            modelDir.setCurrent(i)
        }

        function del(){
            var c = modelFile.rowCount()
            var r = modelDir.delete(c)
            if (r){
                if (modelDir.rowCount() === 0){
                    dirSelector.currentIndex = -1
                    modelDir.setCurrent(-1)
                } else {
                    dirSelector.currentIndex = 0
                    modelDir.setCurrent(modelDir.get(0, 'id'))
                }
                close()
            }
        }

        function save(){
            var r = modelDir.save(dir_name.text)
            if (r){
                current_idx = modelDir.rowCount() - 1
                dirSelector.currentIndex = current_idx
                form_directory.visible = false
            }
        }

        function close(){
            form_directory.visible = false


        }

        function select(i){
            form_directory.visible= false
            modelDir.setCurrent(i)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5


        Pane {
            id: directory

            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight

            RowLayout {
                anchors.fill: parent
                spacing: 5


                ListView {
                    id: dirSelector
                    Layout.fillWidth: true
                    Layout.minimumHeight: parent.height - 10
                    Layout.maximumHeight: parent.height - 10
                    Layout.alignment: Qt.AlignVCenter

                    model: modelDir
                    orientation: ListView.Horizontal
                    delegate: Rectangle {
                        required property int id
                        required property string dir
                        required property int index

                        width: dirSelector.width / modelDir.rowCount()
                        height: dirSelector.height
                        color: dirSelector.currentIndex === index ? clr_ORANGE : clr_GREEN
                        Label{
                            id: dirSelector_name
                            anchors.centerIn: parent
                            text: dir
                            color: clr_WHITE
                            font.family: "Roboto"
                            font.pointSize: 16
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                dirSelector.currentIndex = index
                                internal.current_idx = index
                                internal.select(id)
                            }
                            onDoubleClicked: {
                                dirSelector.currentIndex = index
                                internal.current_idx = index
                                internal.edit(id)
                            }

                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                    focus: true
                }

                Button {
                    id: but_dir_add

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight


                    text: "+"

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.add()
                }
            }
        }

        Pane {
            id: form_directory
            visible: false

            Layout.fillWidth: true
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Button {
                    id: but_dir_del

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "Удалить"

                    Material.background: Material.Pink
                    Material.foreground: clr_WHITE
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.del()
                }

                TextField {
                    id: dir_name
                    Layout.fillWidth: true
                    Layout.minimumHeight: but_dir_save.height - 10
                    Layout.maximumHeight: but_dir_save.height - 10
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    placeholderText: "Название раздела"
                }

                Button {
                    id: but_dir_save

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "Сохранить"

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.save()
                }
                Button {
                    id: but_dir_close

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.minimumHeight: implicitHeight
                    Layout.maximumHeight: implicitHeight

                    text: "X"

                    Material.background: clr_ORANGE
                    Material.foreground: clr_DARK
                    Material.roundedScale: Material.ExtraSmallScale

                    onClicked: internal.close()
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: {
        grid_main.currentIndex = internal.current_idx
        modelDir.setCurrent(modelDir.get(0, 'id'))
    }

}
