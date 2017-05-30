/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */


import QtQuick 2.6
import QtQuick.Templates 2.0 as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.TextArea {
    id: control

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            background ? background.implicitWidth : 0,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: 6

    color: StylePrivate.SystemPaletteSingleton.text(control.enabled)
    selectionColor: StylePrivate.SystemPaletteSingleton.highlight(control.enabled)
    selectedTextColor: StylePrivate.SystemPaletteSingleton.highlightedText(control.enabled)
    wrapMode: Text.WordWrap
    verticalAlignment: TextEdit.AlignTop
    renderType: Text.NativeRendering
    

    Label {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
        color: StylePrivate.SystemPaletteSingleton.text(false)
        horizontalAlignment: control.horizontalAlignment
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
    }

    background: StylePrivate.StyleItem {
        id: style
        visible: control.backgroundVisible
        elementType: "edit"
        implicitWidth: 200
        implicitHeight: 22

        sunken: true
        hasFocus: control.activeFocus
        hover: control.hovered
    }
}
