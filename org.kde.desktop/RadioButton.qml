/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.desktop.private as Private

T.RadioButton {
    id: controlRoot

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    baselineOffset: contentItem ? contentItem.y + contentItem.baselineOffset : 0

    spacing: indicator && typeof indicator.pixelMetric === "function" ? indicator.pixelMetric("radiobuttonlabelspacing") : Kirigami.Units.smallSpacing

    hoverEnabled: true

    indicator: Private.CheckIndicator {
        elementType: "radiobutton"
        x: if (control.contentItem !== null && control.contentItem.width > 0) {
            return control.mirrored ?
                control.width - width - control.rightPadding : control.leftPadding
        } else {
            return control.leftPadding + (control.availableWidth - width) / 2
        }
        y: if (control.contentItem !== null
            && (control.contentItem instanceof Text || control.contentItem instanceof TextEdit)
            && control.contentItem.lineCount > 1) {
            return control.topPadding
        } else {
            return control.topPadding + Math.round((control.availableHeight - height) / 2)
        }
        control: controlRoot
    }

    Kirigami.MnemonicData.enabled: enabled && visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: text
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: {
            // TODO Remove check once we depend on Qt 6.8.
            if (typeof controlRoot.animateClick === "function") {
                controlRoot.animateClick();
            } else {
                controlRoot.checked = true;
            }
        }
    }

    contentItem: Label {
        id: contentLabel
        readonly property int indicatorEffectiveWidth: (
                controlRoot.indicator
                && typeof controlRoot.indicator.pixelMetric === "function"
                && controlRoot.icon.name === ""
                && controlRoot.icon.source.toString() === ""
            ) ? controlRoot.indicator.pixelMetric("exclusiveindicatorwidth") + controlRoot.spacing
              : controlRoot.indicator.width

        property FontMetrics fontMetrics: FontMetrics {}
        // Ensure consistent vertical position relative to indicator with multiple lines.
        // No need to round because .5 from the top will add with .5 from the bottom becoming 1.
        topPadding: Math.max(0, (controlRoot.implicitIndicatorHeight - fontMetrics.height) / 2)
        bottomPadding: topPadding
        leftPadding: controlRoot.indicator && !controlRoot.mirrored ? indicatorEffectiveWidth : 0
        rightPadding: controlRoot.indicator && controlRoot.mirrored ? indicatorEffectiveWidth : 0
        opacity: controlRoot.enabled ? 1 : 0.6
        text: controlRoot.Kirigami.MnemonicData.richTextLabel
        font: controlRoot.font
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        Private.FocusRect {
            control: controlRoot

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
                topMargin: contentLabel.topPadding - 1
                leftMargin: (controlRoot.mirrored ? contentLabel.rightPadding : contentLabel.leftPadding) - Kirigami.Units.smallSpacing / 2
                bottomMargin: contentLabel.bottomPadding - 1
            }

            width: contentLabel.paintedWidth + Kirigami.Units.smallSpacing
            visible: control.activeFocus
        }
    }
}
