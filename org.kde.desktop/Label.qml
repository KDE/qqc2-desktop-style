/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.1
import QtQuick.Window 2.2
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

T.Label {
    id: control

    palette: Kirigami.Theme.palette
    verticalAlignment: lineCount > 1 ? Text.AlignTop : Text.AlignVCenter

    activeFocusOnTab: false

    // Work around Qt bug where NativeRendering breaks for non-integer scale factors
    // https://bugreports.qt.io/browse/QTBUG-67007
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    // Since Text (and Label) lack cursor-changing abilities of their own,
    // as suggested by QTBUG-30804, use a MouseAra to do our dirty work.
    // See comment https://bugreports.qt.io/browse/QTBUG-30804?#comment-206287
    // TODO: Once HoverHandler and friends are able to change cursor shapes, this will want changing to that method
    MouseArea {
        anchors.fill: parent
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.NoButton // Not actually accepting clicks, just changing the cursor
    }

    font.capitalization: Kirigami.Theme.defaultFont.capitalization
    font.family: Kirigami.Theme.defaultFont.family
    font.italic: Kirigami.Theme.defaultFont.italic
    font.letterSpacing: Kirigami.Theme.defaultFont.letterSpacing
    font.pointSize: Kirigami.Theme.defaultFont.pointSize
    font.strikeout: Kirigami.Theme.defaultFont.strikeout
    font.underline: Kirigami.Theme.defaultFont.underline
    font.weight: Kirigami.Theme.defaultFont.weight
    font.wordSpacing: Kirigami.Theme.defaultFont.wordSpacing
    color: Kirigami.Theme.textColor
    linkColor: Kirigami.Theme.linkColor

    opacity: enabled? 1 : 0.6

    Accessible.role: Accessible.StaticText
    Accessible.name: text
}
