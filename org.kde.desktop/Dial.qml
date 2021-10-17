/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Controls @QQC2_VERSION@
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.Dial {
    id: controlRoot

    implicitWidth: 128
    implicitHeight: 128

    background: StylePrivate.StyleItem {
        id: style
        control: controlRoot
        visible: true
        elementType: "dial"
        horizontal: false

        maximum: controlRoot.to*100
        minimum: controlRoot.from*100
        step: controlRoot.stepSize*100
        value: controlRoot.value*100

        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
    }
}
