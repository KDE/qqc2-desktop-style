/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.kirigami.dialogs as KDialogs

T.Dialog {
    id: control

    z: Kirigami.OverlayZStacking.z

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitHeaderWidth,
                            implicitFooterWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    padding: Kirigami.Units.gridUnit

    // determine parent so that popup knows which window to popup in
    // we want to open the dialog in the center of the window, if possible
    parent: typeof applicationWindow !== "undefined" ? applicationWindow().overlay : undefined

    // center dialog
    x: parent ? Math.round(((parent && parent.width) - width) / 2) : 0
    y: parent ? Math.round(((parent && parent.height) - height) / 2) + Kirigami.Units.gridUnit * 2 * (1 - opacity) : 0 // move animation

    // black background, fades in and out
    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.3)

        // the opacity of the item is changed internally by QQuickPopup on open/close
        Behavior on opacity {
            enabled: Kirigami.Units.longDuration > 0
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    contentItem: Item {}

    background: Kirigami.ShadowedRectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: false

        color: Kirigami.Theme.backgroundColor
        radius: Kirigami.Units.cornerRadius

        shadow {
            size: radius * 2
            color: Qt.rgba(0, 0, 0, 0.3)
            yOffset: 1
        }

        border {
            width: 1
            color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast);
        }
    }

    header: KDialogs.DialogHeader {
        dialog: root
        contentItem: KDialogs.DialogHeaderTopContent {
            dialog: root
        }
    }

    footer: DialogButtonBox {
        visible: count > 0
    }
}
