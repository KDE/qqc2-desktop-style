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
import QtQuick.Controls 2.0
import QtQuick.Templates 2.0 as T
import org.kde.kirigami 2.2 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.Dial {
    id: controlRoot

    implicitWidth: 128
    implicitHeight: 128

    background: StylePrivate.StyleItem {
        id: style
        control: controlRoot
        visible: true
        elementType: "dial"
        horizontal: false

        maximum: controlRoot.to*100
        minimum: controlRoot.from*100
        step: controlRoot.stepSize*100
        value: controlRoot.value*100

        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
    }
}
