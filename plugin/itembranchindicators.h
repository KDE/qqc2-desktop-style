/*
    SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
    SPDX-FileCopyrightText: 2023 David Redondo <kde@david-redondo.de>
*/

#ifndef ITEMBRANCHINDICATORS_H
#define ITEMBRANCHINDICATORS_H

#include <QModelIndex>
#include <QQuickPaintedItem>

class ItemBranchIndicators : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QModelIndex modelIndex MEMBER m_index WRITE setModelIndex NOTIFY modelIndexChanged)
public:
    void setModelIndex(const QModelIndex &index);
    void paint(QPainter *painter) override;

Q_SIGNALS:
    void modelIndexChanged();

private:
    std::vector<QModelIndex> parentChain;
    QModelIndex m_index;
};

#endif
