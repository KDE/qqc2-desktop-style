/*
    SPDX-FileCopyrightText: 2021 Jonah Brüchert <jbb@kaidan.im>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef KIRIGAMIPLASMADESKTOPUNITS_H
#define KIRIGAMIPLASMADESKTOPUNITS_H

#include <QObject>

#include <Units>

#include <KConfigWatcher>

class PlasmaDesktopUnits : public Kirigami::Units
{
    Q_OBJECT

public:
    explicit PlasmaDesktopUnits(QObject *parent = nullptr);

    void updateAnimationSpeed();

private:
    KConfigWatcher::Ptr m_animationSpeedWatcher;
};

#endif
