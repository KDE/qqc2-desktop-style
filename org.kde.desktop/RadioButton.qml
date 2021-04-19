/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import QtQuick.Controls @QQC2_VERSION@
import org.kde.kirigami 2.4 as Kirigami
import "private"

T.RadioButton {
    id: controlRoot

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    spacing: indicator && typeof indicator.pixelMetric === "function" ? indicator.pixelMetric("radiobuttonlabelspacing") : Kirigami.Units.smallSpacing

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
        onActivated: controlRoot.checked = true
    }

    contentItem: Label {
        readonly property int indicatorEffectiveWidth: controlRoot.indicator && typeof controlRoot.indicator.pixelMetric === "function"
            ? controlRoot.indicator.pixelMetric("exclusiveindicatorwidth") : controlRoot.indicator.width

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

            anchors {
                leftMargin: (controlRoot.mirrored ? parent.rightPadding : parent.leftPadding ) - Kirigami.Units.smallSpacing / 2
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                topMargin: parent.topPadding - 1
                bottomMargin: parent.bottomPadding - 1
            }

            width: parent.paintedWidth + Kirigami.Units.smallSpacing
            visible: control.activeFocus
        }
    }
}
