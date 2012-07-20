import QtQuick 1.1
import QtMobility.contacts 1.1
import com.nokia.meego 1.0
import "constants.js" as Constants

Sheet {
    id: newContactViewPage
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    property Contact contact

    content: Flickable {
        anchors.fill: parent
        contentHeight: editorContent.childrenRect.height

        Item {
            id: editorContent
            anchors { leftMargin: UiConstants.DefaultMargin; rightMargin: UiConstants.DefaultMargin; fill: parent }

            Button {
                id: avatarRect
                width: height
                anchors { top: parent.top; topMargin: UiConstants.DefaultMargin; left:parent.left; bottom: data_last.bottom }
                onClicked: {
                    Constants.loadSingleton("AvatarPickerSheet.qml", newContactViewPage,
                        function(avatarPicker) {
                            avatarPicker.contact = contact
                            avatarPicker.avatarPicked.disconnect()
                            avatarPicker.avatarPicked.connect(function(avatar) {
                                newContactViewPage.contact.avatar.imageUrl = avatar
                            });
                            avatarPicker.open();
                        }
                    );
                }
                AvatarImage {
                    id: data_avatar
                    width: parent.width - UiConstants.DefaultMargin
                    height: parent.height - UiConstants.DefaultMargin
                    fillMode: Image.PreserveAspectCrop
                    anchors.centerIn: parent
                    contact: newContactViewPage.contact
                }
            }
            TextField {
                id: data_first
                placeholderText: qsTr("First name")
                text: contact.name.firstName
                anchors { top: avatarRect.top; right: parent.right; left: avatarRect.right; leftMargin: UiConstants.DefaultMargin }
            }
            TextField {
                id: data_last
                placeholderText: qsTr("Last name")
                text: contact.name.lastName
                anchors { top: data_first.bottom;
                    topMargin: UiConstants.DefaultMargin;
                    right: parent.right; left: data_first.left
                }
            }

            Column {
                id: phoneColumn
                anchors { top: data_last.bottom; topMargin: UiConstants.DefaultMargin }
                width: parent.width
                spacing: UiConstants.DefaultMargin

                // TODO: we should have a Repeater for all numbers on a contact,
                // but lol, adding a single number seems quite hard.
                TextField {
                    id: data_phone
                    placeholderText: qsTr("Phone number")
                    width: parent.width
                    text: contact.phoneNumber.number
                    onTextChanged: contact.phoneNumber.number = data_phone.text
                }
            }
        }
    }

    onAccepted: saveContact();

    function saveContact() {
        // work around a QML(?)/mobility bug: if we assign to contact.name.firstName,
        // it seems to cause data.name.lastName to change, which resets the
        // binding on lastName to data_last, which means we don't save the last
        // name.
        var last = data_last.text;
        contact.name.firstName = data_first.text
        contact.name.lastName = last

        // TODO: this isn't asynchronous
        app.contactListModel.saveContact(contact)

        // TODO: revisit
        if (contact.dirty)
            console.log("[saveContact] Unable to create new contact due to missing info");
        else
            console.log("[saveContact] Saved contact")
    }
}


