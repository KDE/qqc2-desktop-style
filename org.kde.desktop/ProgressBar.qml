/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import org.kde.qqc2desktopstyle.private as StylePrivate
import QtQuick.Templates as T
import org.kde.kirigami 2.4 as Kirigami

T.ProgressBar {
    id: controlRoot

    implicitWidth: 250
    implicitHeight: 22

    hoverEnabled: true

    contentItem: Item {}

    background: StylePrivate.StyleItem {
        // Rescale for extra precision. Adapts to the range of `from` & `to` to avoid integer overflow.
        property int factor: (Math.abs(controlRoot.from) < 100000 && Math.abs(controlRoot.to) < 100000)
            ? 10000 : 1

        elementType: "progressbar"
        control: controlRoot
        maximum: indeterminate ? 0 : factor * controlRoot.to
        minimum: indeterminate ? 0 : factor * controlRoot.from
        value: indeterminate ? 0 : factor * controlRoot.value
        horizontal: true
        enabled: controlRoot.enabled
    }
}
