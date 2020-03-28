/*
    SPDX-FileCopyrightText: 2019 Cyril Rossi <cyril.rossi@enioka.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
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
