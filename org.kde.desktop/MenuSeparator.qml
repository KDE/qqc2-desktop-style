/*
    SPDX-FileCopyrightText: 2019 Alexander Stippich <a.stippich@gmx.net>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.MenuSeparator {
    id: controlRoot

    implicitHeight: Kirigami.Units.smallSpacing + separator.height
    width: parent.width

    background: Kirigami.Separator {
        id: separator
        anchors.centerIn: controlRoot
        width: controlRoot.width
    }
}
