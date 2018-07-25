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


import QtQuick 2.7
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls @QQC2_VERSION@
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.Menu {
    id: control

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem ? contentItem.implicitWidth + leftPadding + rightPadding : 0)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding

    margins: 0

@DISABLE_UNDER_QQC2_2_3@    delegate: MenuItem { }

    contentItem: ListView {
        implicitWidth: control.contentItem.childrenRect.width
        implicitHeight: contentHeight
        property bool hasCheckables: false
        property bool hasIcons: false
        model: control.contentModel

        interactive: ApplicationWindow.window ? contentHeight > ApplicationWindow.window.height : false
        clip: true
        currentIndex: control.currentIndex || 0
        keyNavigationEnabled: true
        keyNavigationWraps: true

        ScrollBar.vertical: ScrollBar {}
    }

    Connections {
        target: control.contentItem.contentItem
        onChildrenChanged: {
            for (var i in control.contentItem.contentItem.children) {
                var child = control.contentItem.contentItem.children[i];
                if (child.checkable) {
                    control.contentItem.hasCheckables = true;
                }
                if (child.icon && child.icon.hasOwnProperty("name") && (child.icon.name.length > 0 || child.icon.source.length > 0)) {
                    control.contentItem.hasIcons = true;
                }
            }
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: 150
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: 150
        }
    }

    background: Rectangle {
        radius: 2
        implicitWidth: Kirigami.Units.gridUnit * 8
        implicitHeight: 40
        color: Kirigami.Theme.backgroundColor
        property color borderColor: Kirigami.Theme.textColor
        border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
        layer.enabled: true
        
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 8
            samples: 8
            horizontalOffset: 0
            verticalOffset: 2
            color: Qt.rgba(0, 0, 0, 0.3)
        }
    }
}
