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
import QtQuick.Templates @QQC2_VERSION@ as T
import QtQuick.Controls @QQC2_VERSION@
import org.kde.kirigami 2.4 as Kirigami
import "private"

T.CheckBox {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    spacing: indicator && typeof indicator.pixelMetric === "function" ? indicator.pixelMetric("checkboxlabelspacing") : Kirigami.Units.smallSpacing

    hoverEnabled: true

    indicator: CheckIndicator {
        LayoutMirroring.enabled: controlRoot.mirrored
        LayoutMirroring.childrenInherit: true
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        control: controlRoot
    }

    Kirigami.MnemonicData.enabled: controlRoot.enabled && controlRoot.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: controlRoot.text
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: controlRoot.toggle();
    }

    contentItem: Label {
        readonly property int indicatorEffectiveWidth: controlRoot.indicator && typeof controlRoot.indicator.pixelMetric === "function"
            ? controlRoot.indicator.pixelMetric("indicatorwidth") : controlRoot.indicator.width

        leftPadding: controlRoot.indicator && !controlRoot.mirrored ? indicatorEffectiveWidth + controlRoot.spacing : 0
        rightPadding: controlRoot.indicator && controlRoot.mirrored ? indicatorEffectiveWidth + controlRoot.spacing : 0
        opacity: controlRoot.enabled ? 1 : 0.6
        text: controlRoot.Kirigami.MnemonicData.richTextLabel
        font: controlRoot.font
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        FocusRect {
            control: controlRoot
        }
    }
}
