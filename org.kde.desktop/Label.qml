/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Window 2.2
import QtQuick.Templates 2.15 as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

T.Label {
    id: control

    // Work around Qt bug where left aligned text is not right aligned
    // in RTL mode unless horizontalAlignment is explicitly set.
    // https://bugreports.qt.io/browse/QTBUG-95873
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: lineCount > 1 ? Text.AlignTop : Text.AlignVCenter

    // Work around Qt bug where NativeRendering breaks for non-integer scale factors
    // https://bugreports.qt.io/browse/QTBUG-67007
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    HoverHandler {
        // By default HoverHandler accepts the left button while it shouldn't accept anything,
        // causing https://bugreports.qt.io/browse/QTBUG-106489.
        // Qt.NoButton unfortunately is not a valid value for acceptedButtons.
        // Disabling masks the problem, but
        // there is no proper workaround other than an upstream fix
        enabled: false
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : undefined
    }

    color: Kirigami.Theme.textColor
    linkColor: Kirigami.Theme.linkColor
    font: Kirigami.Theme.defaultFont
}
