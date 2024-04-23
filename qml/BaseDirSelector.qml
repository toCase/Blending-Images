import QtQuick
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Item {

    QtObject {
        id: internal

        property int current_idx: -1

        function add() {
            modelDir.setCurrent(0)
            dir_name.clear()
            but_dir_del.visible = false
            form_directory.visible = true
        }

        function edit(i){
            modelDir.setCurrent(i)
            dir_name.text = modelDir.get(current_idx, 'dir')
            but_dir_del.visible = true
            form_directory.visible = true
        }

        function del(){
            var r = modelDir.delete()
            if (r){
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

            if (modelDir.rowCount() === 0){
                dirSelector.currentIndex = -1
                modelDir.setCurrent(-1)
            } else {
                dirSelector.currentIndex = 0
                modelDir.setCurrent(modelDir.get(0, 'id'))
            }
        }

        function select(i){
            modelDir.setCurrent(i)
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
                        required property int id
                        required property string dir
                        required property int index

                        width: dirSelector.width / modelDir.rowCount()
                        height: dirSelector.height
                        color: dirSelector.currentIndex === index ? "#ff6600" : "#707b90"
                        Label{
                            id: dirSelector_name
                            anchors.centerIn: parent
                            text: dir
                            color: "#ffffff"
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
                                internal.select(id)
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

    Component.onCompleted: {
        grid_main.currentIndex = internal.current_idx
        modelDir.setCurrent(modelDir.get(0, 'id'))
    }

}
