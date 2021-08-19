/*
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2021 Chupligin Sergey <neochapay@gmail.com>
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */

import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import Nemo.Thumbnailer 1.0
import org.nemomobile.contacts 1.0

Image {
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    width: Theme.itemHeightSmall
    height: Theme.itemHeightSmall
    property Person contact
    sourceSize.width: width
    sourceSize.height: width

    onContactChanged: {
        contact.avatarPathChanged.connect(avatarPotentiallyChanged)
        avatarPotentiallyChanged();
    }

    Component.onCompleted: {
        if (contact == null)
            avatarPotentiallyChanged();
    }

    function avatarPotentiallyChanged() {
        if (contact == null || contact.avatarPath == "image://theme/user" || contact.avatarPath == "image://theme/icon-m-telephony-contact-avatar") {
            source = "image://theme/user"
        } else {
            if (String(contact.avatarPath).startsWith("image://")) { // don't add thumbnail if already image provider
                source = contact.avatarPath
            } else {
                source = "image://nemothumbnail/" + contact.avatarPath
            }
        }
    }

    onStatusChanged: {
        var fallback = "image://theme/user"
        if (status == Image.Error || status == Image.Null) {
            if (source == fallback)
                console.log("ContactAvatarImage failed to load fallback image!");
            else
                source = fallback
        }
    }
}
