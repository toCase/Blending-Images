import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Item {

    QtObject {
        id: internal

        property int idx: 0

        function add() {
            idx = 0
            dir_name.clear()
            but_dir_del.visible = false
            form_directory.visible = true
        }

        function edit(i){
            idx = modelDir.get(i, 'id')
            dir_name.text = modelDir.get(i, 'dir')
            but_dir_del.visible = true
            form_directory.visible = true
        }

        function del(){
            var r = modelDir.delete(idx)
            if (r){
                close()

                if (modelDir.rowCount() === 0){
                    dirSelector.currentIndex = -1
                    modelDir.setCurrent(-1)
                } else {
                    dirSelector.currentIndex = 0
                    modelDir.setCurrent(0)
                }
            }
        }

        function save(){
            let l = []
            l[0] = idx
            l[1] = dir_name.text

            var r = modelDir.save(l)
            if (r){
                close()
            }
        }

        function close(){
            form_directory.visible = false
        }

        function select(i){
            modelDir.setCurrent(i)
        }
    }

    Connections{
        target: modelDir
        function onError(error){
            console.log("message", error)
        }

        function onCurrentChanged(current){
            console.log("current", current)
        }
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 5


        Pane {
            id: directory

            Layout.fillWidth: true
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5


                ListView {
                    id: dirSelector
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: modelDir
                    orientation: ListView.Horizontal
                    delegate: Rectangle {
                        // required property int idx
                        required property string dir

                        required property int index

                        width: dirSelector.width / modelDir.rowCount()
                        height: dirSelector.height
                        color: dirSelector.currentIndex === index ? "#ff6600" : "#707b90"
                        Label{
                            anchors.centerIn: parent
                            text: dir
                            color: "#ffffff"//sett.appGetColor(parent.color)
                            font.family: "Roboto"
                            font.pointSize: 16
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // internal.selectSpec(idx)
                                dirSelector.currentIndex = index
                                internal.select(index)
                            }
                            onDoubleClicked: {
                                dirSelector.currentIndex = index
                                internal.select(index)
                                internal.edit(index)
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
                    Layout.fillHeight: true

                    text: "+"
                    onClicked: internal.add()
                }
            }
        }

        Pane {
            id: form_directory
            visible: false

            Layout.fillWidth: true
            Layout.minimumHeight: 55
            Layout.maximumHeight: 55

            RowLayout {
                anchors.fill: parent
                spacing: 5

                Button {
                    id: but_dir_del

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "Удалить"
                    onClicked: internal.del()
                }

                TextField {
                    id: dir_name
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    placeholderText: "Название раздела"
                }

                Button {
                    id: but_dir_save

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "Сохранить"
                    onClicked: internal.save()
                }
                Button {
                    id: but_dir_close

                    Layout.minimumWidth: implicitWidth
                    Layout.maximumWidth: implicitWidth
                    Layout.fillHeight: true

                    text: "X"
                    onClicked: internal.close()
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

}
