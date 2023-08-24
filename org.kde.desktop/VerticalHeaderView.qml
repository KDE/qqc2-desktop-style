/*
    SPDX-FileCopyrightText: 2023 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2020 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import org.kde.qqc2desktopstyle.private as StylePrivate

T.VerticalHeaderView {
    id: controlRoot

    // The contentWidth of TableView will be zero at start-up, until the delegate
    // items have been loaded. This means that even if the implicit width of
    // VerticalHeaderView should be the same as the content width in the end, we
    // need to ensure that it has at least a width of 1 at start-up, otherwise
    // TableView won't bother loading any delegates at all.
    implicitWidth: Math.max(1, contentWidth)
    implicitHeight: syncView ? syncView.height : 0

    delegate: StylePrivate.StyleItem {
        required property var model
        required property int row
        readonly property string headerPosition: {
            if (controlRoot.rows === 1) {
                return "only";
            }
            if (model.row == 0) {
                return LayoutMirroring.enabled ? "end" : "beginning"
            }
            return "middle"
        }

        text: model[controlRoot.textRole]
        elementType: "header"
        on: {
            if (!controlRoot.syncView || !controlRoot.syncView.selectionModel) {
                return false
            }
            for (let idx of controlRoot.syncView.selectionModel.selectedIndexes) {
                if (idx.row === model.row || idx.column === model.column) {
                    return true;
                }
            }
            return false;
        }
        properties: {
            "headerpos": headerPosition,
            "textalignment": Text.AlignVCenter | Text.AlignHCenter,
            "orientation": Qt.Vertical
        }
    }
}
