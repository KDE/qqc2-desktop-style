/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.ToolBar {
    id: controlRoot

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, contentHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.smallSpacing
    contentItem: Item {}
    position: controlRoot.parent.footer === controlRoot ? ToolBar.Footer : ToolBar.Header

    // Use Header colors if it's a header and Header colors are available
    // (if not, this will fall back to window colors)
    // Window colors
    Kirigami.Theme.colorSet: position === T.ToolBar.Footer || (parent.footer && parent.footer === controlRoot) ? Kirigami.Theme.Window : Kirigami.Theme.Header
    Kirigami.Theme.inherit: false

    background: Rectangle {
        implicitHeight: 40
        color: Kirigami.Theme.backgroundColor
        Kirigami.Separator {
            anchors {
                left: parent.left
                right: parent.right
                top: controlRoot.position === T.ToolBar.Footer || (controlRoot.parent.footer && controlRoot.parent.footer === controlRoot) ? parent.top : undefined
                bottom: controlRoot.position === T.ToolBar.Footer || (controlRoot.parent.footer && controlRoot.parent.footer === controlRoot) ? undefined : parent.bottom
            }
        }
    }
}
