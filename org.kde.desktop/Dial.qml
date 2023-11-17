/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.desktop.impl as StyleImpl

T.Dial {
    id: controlRoot

    implicitWidth: 128
    implicitHeight: 128

    background: StyleImpl.StyleItem {
        control: controlRoot
        visible: true
        elementType: "dial"
        horizontal: false

        maximum: controlRoot.to * 100
        minimum: controlRoot.from * 100
        step: controlRoot.stepSize * 100
        value: controlRoot.value * 100

        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
    }
}
