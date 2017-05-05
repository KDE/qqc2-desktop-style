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


import QtQuick 2.1
import QtQuick.Templates 2.0 as T
//QQC1 is needed for StyleItem to fully work
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0

T.Label {
    id: control

    height: Math.round(Math.max(paintedHeight, TextSingleton.height * 1.6))
    verticalAlignment: lineCount > 1 ? Text.AlignTop : Text.AlignVCenter

    activeFocusOnTab: false
    renderType: Text.NativeRendering

    //font data is the system one by default
    color: SystemPaletteSingleton.text(control.enabled)
    //SystemPaletteSingleton doesn't have a link color
    linkColor: "#2196F3"

    opacity: enabled? 1 : 0.6

    Accessible.role: Accessible.StaticText
    Accessible.name: text
}
