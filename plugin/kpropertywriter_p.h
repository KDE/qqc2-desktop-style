/*
 *   Copyright (C) 2019 Cyril Rossi <cyril.rossi@enioka.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifndef KPROPERTYWRITER_H
#define KPROPERTYWRITER_H

#include <QObject>
#include <QVariant>

class KPropertyWriter : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QObject *target READ target WRITE setTarget NOTIFY targetChanged)
    Q_PROPERTY(QString propertyName READ propertyName WRITE setPropertyName NOTIFY propertyNameChanged)

public:
    using QObject::QObject;

    QObject *target() const;
    QString propertyName() const;

    Q_INVOKABLE bool writeProperty(const QVariant &value);

public Q_SLOTS:
    void setTarget(QObject *target);
    void setPropertyName(const QString &propertyName);

Q_SIGNALS:
    void targetChanged(QObject *target);
    void propertyNameChanged(const QString &propertyName);

private:
    QObject *m_target = nullptr;
    QString m_propertyName;
};

#endif // KPROPERTYWRITER_H
