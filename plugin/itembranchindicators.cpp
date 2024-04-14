/*
    SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
    SPDX-FileCopyrightText: 2023 David Redondo <kde@david-redondo.de>
*/

#include "itembranchindicators.h"

#include "kquickstyleitem_p.h"

#include <Kirigami/Platform/PlatformTheme>

#include <QAbstractItemModel>
#include <QGuiApplication>
#include <QStyle>
#include <QStyleOption>

ItemBranchIndicators::ItemBranchIndicators(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_selected(false)
{
    if (auto theme = static_cast<Kirigami::Platform::PlatformTheme *>(qmlAttachedPropertiesObject<Kirigami::Platform::PlatformTheme>(this, true))) {
        m_palette = theme->palette();
        connect(theme, &Kirigami::Platform::PlatformTheme::paletteChanged, this, [this](const QPalette &palette) {
            m_palette = palette;
            update();
        });
    }
}

void ItemBranchIndicators::updateParentChain()
{
    const bool wasPainting = parentChain.size() != 0;
    parentChain.clear();

    // If we have children the indicator is drawn in the QML
    if (m_index.column() == 0) {
        auto index = m_index.model()->hasChildren(m_index) ? m_index.parent() : m_index;
        // if the TreeView's root index is set, don't go past it
        while (index.isValid() && (!m_rootIndex.isValid() || index != m_rootIndex)) {
            parentChain.push_back(index);
            index = index.parent();
        }
    }

    const auto elementWidth = KQuickStyleItem::style()->pixelMetric(QStyle::PM_TreeViewIndentation);
    setImplicitWidth(elementWidth * parentChain.size());

    if (wasPainting || !parentChain.empty()) {
        update();
    }
}

void ItemBranchIndicators::setRootIndex(const QModelIndex &new_root_index)
{
    m_rootIndex = new_root_index;
    updateParentChain();
    Q_EMIT rootIndexChanged();
}

void ItemBranchIndicators::setModelIndex(const QModelIndex &new_index)
{
    m_index = new_index;
    updateParentChain();
    Q_EMIT modelIndexChanged();
}

void ItemBranchIndicators::setSelected(bool selected)
{
    if (m_selected == selected) {
        return;
    }
    m_selected = selected;
    update();
    Q_EMIT selectedChanged();
}

void ItemBranchIndicators::paint(QPainter *painter)
{
    const auto elementWidth = KQuickStyleItem::style()->pixelMetric(QStyle::PM_TreeViewIndentation);
    QStyleOption styleOption;
    styleOption.state.setFlag(QStyle::State_Selected, m_selected);
    styleOption.state.setFlag(QStyle::State_Children, false);
    styleOption.rect.setSize(QSize(elementWidth, height()));
    styleOption.palette = m_palette;
    for (auto it = parentChain.rbegin(); it != parentChain.rend(); ++it) {
        styleOption.state.setFlag(QStyle::State_Item, *it == m_index);
        styleOption.state.setFlag(QStyle::State_Sibling, it->siblingAtRow(it->row() + 1).isValid());
        if (QGuiApplication::layoutDirection() == Qt::LeftToRight) {
            styleOption.rect.moveLeft(std::distance(parentChain.rbegin(), it) * elementWidth);
        } else {
            styleOption.rect.moveLeft((std::distance(it, parentChain.rend()) - 1) * elementWidth);
        }
        KQuickStyleItem::style()->drawPrimitive(QStyle::PE_IndicatorBranch, &styleOption, painter);
    }
}
