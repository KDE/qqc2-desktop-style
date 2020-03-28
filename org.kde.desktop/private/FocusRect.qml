/*
    SPDX-FileCopyrightText: 2018 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

StylePrivate.StyleItem {
    elementType: "focusrect"
    // those random numbers come from QQC1 desktop style
    anchors {
        top: parent.top
        bottom: parent.bottom
        topMargin: parent.topPadding - 1
        bottomMargin: parent.bottomPadding - 1
    }
    // this is explicitly not using left anchor for auto mirroring
    // since the label's leftPadding/rightPadding already accounts for that
    x: parent.leftPadding - 2
    width: parent.implicitWidth - parent.leftPadding - parent.rightPadding + 3
    visible: control.activeFocus
}
