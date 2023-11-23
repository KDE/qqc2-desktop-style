/*
    SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
    SPDX-FileCopyrightText: 2023 David Redondo <kde@david-redondo.de>
*/

#ifndef ITEMBRANCHINDICATORS_H
#define ITEMBRANCHINDICATORS_H

#include <QModelIndex>
#include <QPalette>
#include <QQuickPaintedItem>

class ItemBranchIndicators : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QModelIndex modelIndex MEMBER m_index WRITE setModelIndex NOTIFY modelIndexChanged)
    Q_PROPERTY(bool selected MEMBER m_selected WRITE setSelected NOTIFY selectedChanged)
public:
    explicit ItemBranchIndicators(QQuickItem *parent = nullptr);
    void setModelIndex(const QModelIndex &index);
    void setSelected(bool selected);
    void paint(QPainter *painter) override;

Q_SIGNALS:
    void modelIndexChanged();
    void selectedChanged();

private:
    std::vector<QModelIndex> parentChain;
    QModelIndex m_index;
    bool m_selected;
    QPalette m_palette;
};

#endif
