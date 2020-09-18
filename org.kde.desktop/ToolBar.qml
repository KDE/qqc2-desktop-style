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

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    contentWidth: contentChildren[0].implicitWidth
    contentHeight: contentChildren[0].implicitHeight

    padding: Kirigami.Units.smallSpacing
    contentItem: Item {}
    position: controlRoot.parent.footer == controlRoot ? ToolBar.Footer : ToolBar.Header

    // Use Header colors if it's a header and Header colors are available
    // (if not, this will fall back to window colors)
    // Window colors
    Kirigami.Theme.colorSet: position == T.ToolBar.Footer || (parent.footer && parent.footer == controlRoot) ? Kirigami.Theme.Window : Kirigami.Theme.Header
    Kirigami.Theme.inherit: position == T.ToolBar.Footer || (parent.footer && parent.footer == controlRoot) == T.ToolBar.header ? true :  false

    background: Rectangle {
        implicitHeight: 40
        color: Kirigami.Theme.backgroundColor
        Kirigami.Separator {
            anchors {
                left: parent.left
                right: parent.right
                top: controlRoot.position == T.ToolBar.Footer || (controlRoot.parent.footer && controlRoot.parent.footer == controlRoot) ? parent.top : undefined
                bottom: controlRoot.position == T.ToolBar.Footer || (controlRoot.parent.footer && controlRoot.parent.footer == controlRoot) ? undefined : parent.bottom
            }
        }
    }
}
