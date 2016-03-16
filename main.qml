import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import qt.DES.component 1.0

ApplicationWindow {
    title: qsTr("DES for MD5")
    width: 600
    height: 260
    maximumWidth: 600
    minimumWidth: 600
    maximumHeight: 260
    minimumHeight: 260
    visible: true

    /* note message */
    MessageDialog {
        id: myNote
        standardButtons: StandardButton.Ok
        title: ""
        text: ""
        detailedText: ""
        icon: StandardIcon.Critical
        visible: false
    }

    /* main surface of des operation */
    Rectangle {
        id: rectEncrypt
        width: 580
        height: 240
        border.color: "#62932e"

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10

        /* DES from C++ */
        MyDES {
            id: myDES
        }

        /* "Key" text */
        Text {
            id: textKey
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            text: "Key:"
        }

        /* key input field*/
        TextField {
            id: tfKey
            width: 200
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: textKey.bottom
            anchors.topMargin: 10
            text: "%U(^f6@R"

            onTextChanged: {
                if (length != 8) {
                    textColor = "red"
                } else {
                    textColor = "black"
                }
            }
        }

        /* "Input" text */
        Text {
            id: textInput
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: tfKey.bottom
            anchors.topMargin: 10
            text: "Input:"
        }

        /* input field */
        TextField {
            id: tfInput
            width: 480
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: textInput.bottom
            anchors.topMargin: 10
//            inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhUppercaseOnly | Qt.ImhLowercaseOnly
            text: "1ACD4C7146546673F213506404446249"

            onTextChanged: {
                if (length %16 != 0) {
                    textColor = "red"
                } else {
                    textColor = "black"
                }
            }
        }

        /* "Output" text */
        Text {
            id: textOutput
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: tfInput.bottom
            anchors.topMargin: 10
            text: "Output:"
        }

        /* output field */
        TextField {
            id: tfOutput
            width: 480
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: textOutput.bottom
            anchors.topMargin: 10
            readOnly: true

        }

        /* button for clear key contents */
        Button {
            id: btKeyClear
            width: 60
            height: 30
            anchors.top: textKey.bottom
            anchors.topMargin: 10
            anchors.left: tfKey.right
            anchors.leftMargin: 10
            text: "Clear"

            onClicked: {
                tfKey.text = ""
            }
        }

        /* button for clear input contents */
        Button {
            id: btInClear
            width: 60
            height: 30
            anchors.top: textInput.bottom
            anchors.topMargin: 10
            anchors.left: tfInput.right
            anchors.leftMargin: 10
            text: "Clear"

            onClicked: {
                tfInput.text = ""
            }
        }

        /* button for clear output contents */
        Button {
            id: btOutClear
            width: 60
            height: 30
            anchors.top: textOutput.bottom
            anchors.topMargin: 10
            anchors.left: tfOutput.right
            anchors.leftMargin: 10
            text: "Clear"

            onClicked: {
                tfOutput.text = ""
            }
        }

        /* button for encrypt */
        Button {
            id: btEncrypt
            width: 60
            height: 30
            anchors.top: tfOutput.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: "encrypt"

            onClicked: {
                var inputLength = tfInput.text.trim().length
                var keyLength = tfKey.text.trim().length
                if (inputLength % 16 != 0 || inputLength == 0 || keyLength != 8) {
                    if (keyLength != 8) {
                        myNote.detailedText = "The Key is empty, or the length of the Key is not 8."
                    } else {
                        tfInput.focus = true
                        myNote.detailedText = "The Input data is empty, or the length of the Input is not 16*n."
                    }
                    myNote.title = "Error"
                    myNote.text = "Invalid input."

                    myNote.visible = true
                } else {
                    tfOutput.text = myDES.encryptDataByDES(tfInput.text.trim(), tfKey.text.trim())
                    console.log("Result:", tfOutput.text);
                }
            }
        }

        /* button for decrypt */
        Button {
            id: btDecrypt
            width: 60
            height: 30
            anchors.top: tfOutput.bottom
            anchors.topMargin: 15
            anchors.left: btEncrypt.right
            anchors.leftMargin: 30
            text: "decrypt"

            onClicked: {
                var inputLength = tfInput.text.trim().length
                var keyLength = tfKey.text.trim().length
                if (inputLength % 16 != 0 || inputLength == 0 || keyLength != 8) {
                    if (keyLength != 8) {
                        myNote.detailedText = "The Key is empty, or the length of the Key is not 8."
                    } else {
                        myNote.detailedText = "The Input data is empty, or the length of the Input is not 16*n."
                    }
                    myNote.title = "Error"
                    myNote.text = "Invalid input."
                    myNote.visible = true
                } else {
                    tfOutput.text = myDES.decryptDataByDES(tfInput.text.trim(), tfKey.text.trim())
                    console.log("Result:", tfOutput.text);
                }
            }
        }

        /* button for clear all contents */
        Button {
            id: btClearAll
            width: 80
            height: 30
            anchors.top: tfOutput.bottom
            anchors.topMargin: 15
            anchors.left: btDecrypt.right
            anchors.leftMargin: 30
            text: "Clear all"

            onClicked: {
                tfKey.text = ""
                tfInput.text = ""
                tfOutput.text = ""
            }
        }

    }
}
