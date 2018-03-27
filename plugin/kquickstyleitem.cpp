/****************************************************************************
**
** Copyright 2017 by Marco Martin <mart@kde.org>
** Copyright 2017 by David Edmundson <davidedmundson@kde.org>
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or (at your option) the GNU General
** Public license version 3 or any later version approved by the KDE Free
** Qt Foundation. The licenses are as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL2 and LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-2.0.html and
** https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "kquickstyleitem_p.h"

#include <qstringbuilder.h>
#include <qpainter.h>
#include <qpixmapcache.h>
#include <qstyle.h>
#include <qstyleoption.h>
#include <qapplication.h>
#include <qquickwindow.h>
#include <QtQuick/qsgninepatchnode.h>

#include <Kirigami2/PlatformTheme>

KQuickStyleItem::KQuickStyleItem(QQuickItem *parent)
    : QQuickItem(parent),
    m_styleoption(nullptr),
    m_itemType(Undefined),
    m_sunken(false),
    m_raised(false),
    m_active(true),
    m_selected(false),
    m_focus(false),
    m_hover(false),
    m_on(false),
    m_horizontal(true),
    m_transient(false),
    m_sharedWidget(false),
    m_minimum(0),
    m_maximum(100),
    m_value(0),
    m_step(0),
    m_paintMargins(0),
    m_contentWidth(0),
    m_contentHeight(0),
    m_textureWidth(0),
    m_textureHeight(0),
    m_lastFocusReason(Qt::NoFocusReason)
{
    m_font = qApp->font();
    setFlag(QQuickItem::ItemHasContents, true);
    setSmooth(false);
    qmlRegisterType<KQuickPadding>();

    connect(this, SIGNAL(visibleChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(widthChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(heightChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(enabledChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(infoChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(onChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(selectedChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(textChanged()), this, SLOT(updateSizeHint()));
    connect(this, SIGNAL(textChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(raisedChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(sunkenChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(hoverChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(maximumChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(minimumChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(valueChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(horizontalChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(transientChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeControlChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(hasFocusChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeControlChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(hintChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(propertiesChanged()), this, SLOT(updateSizeHint()));
    connect(this, SIGNAL(propertiesChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(elementTypeChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(contentWidthChanged(int)), this, SLOT(updateSizeHint()));
    connect(this, SIGNAL(contentHeightChanged(int)), this, SLOT(updateSizeHint()));
    connect(this, SIGNAL(widthChanged()), this, SLOT(updateRect()));
    connect(this, SIGNAL(heightChanged()), this, SLOT(updateRect()));

    connect(this, SIGNAL(heightChanged()), this, SLOT(updateBaselineOffset()));
    connect(this, SIGNAL(contentHeightChanged(int)), this, SLOT(updateBaselineOffset()));
}

KQuickStyleItem::~KQuickStyleItem()
{
    if (const QStyleOptionButton *aux = qstyleoption_cast<const QStyleOptionButton*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionViewItem *aux = qstyleoption_cast<const QStyleOptionViewItem*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionHeader *aux = qstyleoption_cast<const QStyleOptionHeader*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionToolButton *aux = qstyleoption_cast<const QStyleOptionToolButton*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionToolBar *aux = qstyleoption_cast<const QStyleOptionToolBar*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionTab *aux = qstyleoption_cast<const QStyleOptionTab*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionFrame *aux = qstyleoption_cast<const QStyleOptionFrame*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionFocusRect *aux = qstyleoption_cast<const QStyleOptionFocusRect*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionTabWidgetFrame *aux = qstyleoption_cast<const QStyleOptionTabWidgetFrame*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionMenuItem *aux = qstyleoption_cast<const QStyleOptionMenuItem*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionComboBox *aux = qstyleoption_cast<const QStyleOptionComboBox*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionSpinBox *aux = qstyleoption_cast<const QStyleOptionSpinBox*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionSlider *aux = qstyleoption_cast<const QStyleOptionSlider*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionProgressBar *aux = qstyleoption_cast<const QStyleOptionProgressBar*>(m_styleoption))
        delete aux;
    else if (const QStyleOptionGroupBox *aux = qstyleoption_cast<const QStyleOptionGroupBox*>(m_styleoption))
        delete aux;
    else
        delete m_styleoption;

    m_styleoption = nullptr;
}

void KQuickStyleItem::initStyleOption()
{
    if (!m_theme) {
        m_theme = static_cast<Kirigami::PlatformTheme *>(qmlAttachedPropertiesObject<Kirigami::PlatformTheme>(this, true));
        Q_ASSERT(m_theme);

        connect(m_theme, &Kirigami::PlatformTheme::colorsChanged, this, [this]() {
            //we need to reset the palette event if Qt::AA_SetPalette attribute has been set
            m_styleoption->palette = m_theme->palette();
            updateItem();
        });
    }
    Q_ASSERT(m_theme);

    if (m_styleoption)
        m_styleoption->state = 0;

    QString sizeHint = m_hints.value(QStringLiteral("size")).toString();

    bool needsResolvePalette = true;

    switch (m_itemType) {
    case Button: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionButton();

        QStyleOptionButton *opt = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);
        opt->text = text();

        const QVariant icon = m_properties[QStringLiteral("icon")];
        if (icon.canConvert<QIcon>()) {
            opt->icon = icon.value<QIcon>();
        } else if (icon.canConvert<QString>()) {
            opt->icon = m_theme->iconFromTheme(icon.value<QString>(), m_properties[QStringLiteral("iconColor")].value<QColor>());
        }
        int e = qApp->style()->pixelMetric(QStyle::PM_ButtonIconSize, m_styleoption, nullptr);
        opt->iconSize = QSize(e, e);
        opt->features = activeControl() == QLatin1String("default") ?
                    QStyleOptionButton::DefaultButton :
                    QStyleOptionButton::None;
        const QFont font = qApp->font("QPushButton");
        opt->fontMetrics = QFontMetrics(font);
        QObject * menu = m_properties[QStringLiteral("menu")].value<QObject *>();
        if (menu) {
            opt->features |= QStyleOptionButton::HasMenu;
        }
    }
        break;
    case ItemRow: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionViewItem();

        QStyleOptionViewItem *opt = qstyleoption_cast<QStyleOptionViewItem*>(m_styleoption);
        opt->features = 0;
        if (activeControl() == QLatin1String("alternate"))
            opt->features |= QStyleOptionViewItem::Alternate;
    }
        break;

    case Splitter: {
        if (!m_styleoption) {
            m_styleoption = new QStyleOption;
        }
    }
        break;

    case Item: {
        if (!m_styleoption) {
            m_styleoption = new QStyleOptionViewItem();
        }
        QStyleOptionViewItem *opt = qstyleoption_cast<QStyleOptionViewItem*>(m_styleoption);
        opt->features = QStyleOptionViewItem::HasDisplay;
        opt->text = text();
        opt->textElideMode = Qt::ElideRight;
        opt->displayAlignment = Qt::AlignLeft | Qt::AlignVCenter;
        opt->decorationAlignment = Qt::AlignCenter;
        resolvePalette();
        needsResolvePalette = false;
        QPalette pal = m_styleoption->palette;
        pal.setBrush(QPalette::Base, Qt::NoBrush);
        m_styleoption->palette = pal;
        const QFont font = qApp->font("QAbstractItemView");
        opt->font = font;
        opt->fontMetrics = QFontMetrics(font);
        break;
    }
    case ItemBranchIndicator: {
        if (!m_styleoption)
            m_styleoption = new QStyleOption;

        m_styleoption->state = QStyle::State_Item; // We don't want to fully support Win 95
        if (m_properties.value(QStringLiteral("hasChildren")).toBool())
            m_styleoption->state |= QStyle::State_Children;
        if (m_properties.value(QStringLiteral("hasSibling")).toBool()) // Even this one could go away
            m_styleoption->state |= QStyle::State_Sibling;
        if (m_on)
            m_styleoption->state |= QStyle::State_Open;
    }
        break;
    case Header: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionHeader();

        QStyleOptionHeader *opt = qstyleoption_cast<QStyleOptionHeader*>(m_styleoption);
        opt->text = text();
        opt->textAlignment = static_cast<Qt::AlignmentFlag>(m_properties.value(QStringLiteral("textalignment")).toInt());
        opt->sortIndicator = activeControl() == QLatin1String("down") ?
                    QStyleOptionHeader::SortDown
                  : activeControl() == QLatin1String("up") ?
                        QStyleOptionHeader::SortUp : QStyleOptionHeader::None;
        QString headerpos = m_properties.value(QStringLiteral("headerpos")).toString();
        if (headerpos == QLatin1String("beginning"))
            opt->position = QStyleOptionHeader::Beginning;
        else if (headerpos == QLatin1String("end"))
            opt->position = QStyleOptionHeader::End;
        else if (headerpos == QLatin1String("only"))
            opt->position = QStyleOptionHeader::OnlyOneSection;
        else
            opt->position = QStyleOptionHeader::Middle;

        const QFont font = qApp->font("QHeaderView");
        opt->fontMetrics = QFontMetrics(font);
    }
        break;
    case ToolButton: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionToolButton();

        QStyleOptionToolButton *opt =
                qstyleoption_cast<QStyleOptionToolButton*>(m_styleoption);
        opt->subControls = QStyle::SC_ToolButton;
        opt->state |= QStyle::State_AutoRaise;
        opt->activeSubControls = QStyle::SC_ToolButton;
        opt->text = text();
        const QVariant icon = m_properties[QStringLiteral("icon")];
        if (icon.canConvert<QIcon>()) {
            opt->icon = icon.value<QIcon>();
        } else if (icon.canConvert<QString>()) {
            opt->icon = m_theme->iconFromTheme(icon.value<QString>(), m_properties[QStringLiteral("iconColor")].value<QColor>());
        }

        if (m_properties.value(QStringLiteral("menu")).toBool()) {
            opt->subControls |= QStyle::SC_ToolButtonMenu;
            opt->features = QStyleOptionToolButton::HasMenu;
        }

        // For now both text and icon
        opt->toolButtonStyle = Qt::ToolButtonTextBesideIcon;

        int e = qApp->style()->pixelMetric(QStyle::PM_ToolBarIconSize, m_styleoption, nullptr);
        opt->iconSize = QSize(e, e);

        const QFont font = qApp->font("QToolButton");
        opt->font = font;
        opt->fontMetrics = QFontMetrics(font);
    }
        break;
    case ToolBar: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionToolBar();
    }
        break;
    case Tab: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionTab();

        QStyleOptionTab *opt = qstyleoption_cast<QStyleOptionTab*>(m_styleoption);
        opt->text = text();

        if (m_properties.value(QStringLiteral("hasFrame")).toBool())
            opt->features |= QStyleOptionTab::HasFrame;

        QString orientation = m_properties.value(QStringLiteral("orientation")).toString();
        QString position = m_properties.value(QStringLiteral("tabpos")).toString();
        QString selectedPosition = m_properties.value(QStringLiteral("selectedpos")).toString();

        opt->shape = orientation == QLatin1String("Bottom") ? QTabBar::RoundedSouth : QTabBar::RoundedNorth;
        if (position == QLatin1String("beginning"))
            opt->position = QStyleOptionTab::Beginning;
        else if (position == QLatin1String("end"))
            opt->position = QStyleOptionTab::End;
        else if (position == QLatin1String("only"))
            opt->position = QStyleOptionTab::OnlyOneTab;
        else
            opt->position = QStyleOptionTab::Middle;

        if (selectedPosition == QLatin1String("next"))
            opt->selectedPosition = QStyleOptionTab::NextIsSelected;
        else if (selectedPosition == QLatin1String("previous"))
            opt->selectedPosition = QStyleOptionTab::PreviousIsSelected;
        else
            opt->selectedPosition = QStyleOptionTab::NotAdjacent;


    } break;

    case Frame: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionFrame();

        QStyleOptionFrame *opt = qstyleoption_cast<QStyleOptionFrame*>(m_styleoption);
        opt->frameShape = QFrame::StyledPanel;
        opt->lineWidth = 1;
        opt->midLineWidth = 1;
    }
        break;
    case FocusRect: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionFocusRect();
        // Needed on windows
        m_styleoption->state |= QStyle::State_KeyboardFocusChange;
    }
        break;
    case TabFrame: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionTabWidgetFrame();
        QStyleOptionTabWidgetFrame *opt = qstyleoption_cast<QStyleOptionTabWidgetFrame*>(m_styleoption);

        opt->selectedTabRect = m_properties[QStringLiteral("selectedTabRect")].toRect();
        opt->shape = m_properties[QStringLiteral("orientation")] == Qt::BottomEdge ? QTabBar::RoundedSouth : QTabBar::RoundedNorth;
        if (minimum())
            opt->selectedTabRect = QRect(value(), 0, minimum(), height());
        opt->tabBarSize = QSize(minimum() , height());
        // oxygen style needs this hack
        opt->leftCornerWidgetSize = QSize(value(), 0);
    }
        break;
    case MenuBar:
        if (!m_styleoption) {
            QStyleOptionMenuItem *menuOpt = new QStyleOptionMenuItem();
            menuOpt->menuItemType = QStyleOptionMenuItem::EmptyArea;
            m_styleoption = menuOpt;
        }

        break;
    case MenuBarItem:
    {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionMenuItem();

        QStyleOptionMenuItem *opt = qstyleoption_cast<QStyleOptionMenuItem*>(m_styleoption);
        opt->text = text();
        opt->menuItemType = QStyleOptionMenuItem::Normal;
        setProperty("_q_showUnderlined", m_hints[QStringLiteral("showUnderlined")].toBool());

        const QFont font = qApp->font("QMenuBar");
        opt->font = font;
        opt->fontMetrics = QFontMetrics(font);
        m_font = opt->font;
    }
        break;
    case Menu: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionMenuItem();
    }
        break;
    case MenuItem:
    case ComboBoxItem:
    {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionMenuItem();

        QStyleOptionMenuItem *opt = qstyleoption_cast<QStyleOptionMenuItem*>(m_styleoption);
        // For GTK style. See below, in setElementType()
        setProperty("_q_isComboBoxPopupItem", m_itemType == ComboBoxItem);

        KQuickStyleItem::MenuItemType type =
                static_cast<KQuickStyleItem::MenuItemType>(m_properties[QStringLiteral("type")].toInt());
        if (type == KQuickStyleItem::ScrollIndicatorType) {
            int scrollerDirection = m_properties[QStringLiteral("scrollerDirection")].toInt();
            opt->menuItemType = QStyleOptionMenuItem::Scroller;
            opt->state |= scrollerDirection == Qt::UpArrow ?
                        QStyle::State_UpArrow : QStyle::State_DownArrow;
        } else if (type == KQuickStyleItem::SeparatorType) {
            opt->menuItemType = QStyleOptionMenuItem::Separator;
        } else {
            opt->text = text();

            if (type == KQuickStyleItem::MenuType) {
                opt->menuItemType = QStyleOptionMenuItem::SubMenu;
            } else {
                opt->menuItemType = QStyleOptionMenuItem::Normal;

                QString shortcut = m_properties[QStringLiteral("shortcut")].toString();
                if (!shortcut.isEmpty()) {
                    opt->text += QLatin1Char('\t') + shortcut;
                    opt->tabWidth = qMax(opt->tabWidth, qRound(textWidth(shortcut)));
                }

                if (m_properties[QStringLiteral("checkable")].toBool()) {
                    opt->checked = on();
                    QVariant exclusive = m_properties[QStringLiteral("exclusive")];
                    opt->checkType = exclusive.toBool() ? QStyleOptionMenuItem::Exclusive :
                                                          QStyleOptionMenuItem::NonExclusive;
                }
            }
            if (m_properties[QStringLiteral("icon")].canConvert<QIcon>())
                opt->icon = m_properties[QStringLiteral("icon")].value<QIcon>();
            setProperty("_q_showUnderlined", m_hints["showUnderlined"].toBool());

            const QFont font = qApp->font(m_itemType == ComboBoxItem ?"QComboMenuItem" : "QMenu");
            opt->font = font;
            opt->fontMetrics = QFontMetrics(font);
            m_font = opt->font;
        }
    }
        break;
    case CheckBox:
    case RadioButton:
    {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionButton();

        QStyleOptionButton *opt = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);
        if (!on())
            opt->state |= QStyle::State_Off;
        if (m_properties.value(QStringLiteral("partiallyChecked")).toBool())
            opt->state |= QStyle::State_NoChange;
        opt->text = text();
    }
        break;
    case Edit: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionFrame();

        QStyleOptionFrame *opt = qstyleoption_cast<QStyleOptionFrame*>(m_styleoption);
        opt->lineWidth = 1; // this must be non-zero
    }
        break;
    case ComboBox :{
        if (!m_styleoption)
            m_styleoption = new QStyleOptionComboBox();

        QStyleOptionComboBox *opt = qstyleoption_cast<QStyleOptionComboBox*>(m_styleoption);

        const QFont font = qApp->font("QPushButton"); //DAVE - QQC1 code does this, but if you look at QComboBox this doesn't make sense
        opt->fontMetrics = QFontMetrics(font);
        opt->currentText = text();
        opt->editable = m_properties[QStringLiteral("editable")].toBool();
    }
        break;
    case SpinBox: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSpinBox();

        QStyleOptionSpinBox *opt = qstyleoption_cast<QStyleOptionSpinBox*>(m_styleoption);
        opt->frame = true;
        opt->subControls = QStyle::SC_SpinBoxFrame | QStyle::SC_SpinBoxEditField;
        if (value() & 0x1)
            opt->activeSubControls = QStyle::SC_SpinBoxUp;
        else if (value() & (1<<1))
            opt->activeSubControls = QStyle::SC_SpinBoxDown;
        opt->subControls = QStyle::SC_All;
        opt->stepEnabled = 0;
        if (value() & (1<<2))
            opt->stepEnabled |= QAbstractSpinBox::StepUpEnabled;
        if (value() & (1<<3))
            opt->stepEnabled |= QAbstractSpinBox::StepDownEnabled;
    }
        break;
    case Slider:
    case Dial:
    {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSlider();

        QStyleOptionSlider *opt = qstyleoption_cast<QStyleOptionSlider*>(m_styleoption);
        opt->orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt->upsideDown = !horizontal();
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->sliderPosition = value();
        opt->singleStep = step();

        if (opt->singleStep) {
            qreal numOfSteps = (opt->maximum - opt->minimum) / opt->singleStep;
            // at least 5 pixels between tick marks
            qreal extent = horizontal() ? width() : height();
            if (numOfSteps && (extent / numOfSteps < 5))
                opt->tickInterval = qRound((5 * numOfSteps / extent) + 0.5) * step();
            else
                opt->tickInterval = opt->singleStep;

        } else // default Qt-components implementation
            opt->tickInterval = opt->maximum != opt->minimum ? 1200 / (opt->maximum - opt->minimum) : 0;

        opt->sliderValue = value();
        opt->subControls = QStyle::SC_SliderGroove | QStyle::SC_SliderHandle;
        opt->tickPosition = activeControl() == QLatin1String("ticks") ?
                    QSlider::TicksBelow : QSlider::NoTicks;
        if (opt->tickPosition != QSlider::NoTicks)
            opt->subControls |= QStyle::SC_SliderTickmarks;

        opt->activeSubControls = QStyle::SC_SliderHandle;
    }
        break;
    case ProgressBar: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionProgressBar();

        QStyleOptionProgressBar *opt = qstyleoption_cast<QStyleOptionProgressBar*>(m_styleoption);
        opt->orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->progress = value();
    }
        break;
    case GroupBox: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionGroupBox();

        QStyleOptionGroupBox *opt = qstyleoption_cast<QStyleOptionGroupBox*>(m_styleoption);
        opt->text = text();
        opt->lineWidth = 1;
        opt->subControls = QStyle::SC_GroupBoxLabel;
        opt->features = 0;
        if (m_properties[QStringLiteral("sunken")].toBool()) { // Qt draws an ugly line here so I ignore it
            opt->subControls |= QStyle::SC_GroupBoxFrame;
        } else {
            opt->features |= QStyleOptionFrame::Flat;
        }
        if (m_properties[QStringLiteral("checkable")].toBool())
            opt->subControls |= QStyle::SC_GroupBoxCheckBox;

    }
        break;
    case ScrollBar: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSlider();

        QStyleOptionSlider *opt = qstyleoption_cast<QStyleOptionSlider*>(m_styleoption);
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->pageStep = qMax(0, int(horizontal() ? width() : height()));
        opt->orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt->sliderPosition = value();
        opt->sliderValue = value();
        opt->activeSubControls = (activeControl() == QLatin1String("up"))
                ? QStyle::SC_ScrollBarSubLine : (activeControl() == QLatin1String("down")) ?
                      QStyle::SC_ScrollBarAddLine :
                  (activeControl() == QLatin1String("handle")) ?
                      QStyle::SC_ScrollBarSlider : hover() ? QStyle::SC_ScrollBarGroove : QStyle::SC_None;
        if (raised())
            opt->state |= QStyle::State_On;

        opt->sliderValue = value();
        opt->subControls = QStyle::SC_All;

        setTransient(qApp->style()->styleHint(QStyle::SH_ScrollBar_Transient, m_styleoption));
        break;
    }
    default:
        break;
    }

    if (!m_styleoption)
        m_styleoption = new QStyleOption();

    if (needsResolvePalette)
        resolvePalette();

    m_styleoption->styleObject = this;
    m_styleoption->direction = qApp->layoutDirection();

    int w = m_textureWidth > 0 ? m_textureWidth : width();
    int h = m_textureHeight > 0 ? m_textureHeight : height();

    m_styleoption->rect = QRect(m_paintMargins, 0, w - 2* m_paintMargins, h);

    if (isEnabled()) {
        m_styleoption->state |= QStyle::State_Enabled;
        m_styleoption->palette.setCurrentColorGroup(QPalette::Active);
    } else {
        m_styleoption->palette.setCurrentColorGroup(QPalette::Disabled);
    }
    if (m_active)
        m_styleoption->state |= QStyle::State_Active;
    else
        m_styleoption->palette.setCurrentColorGroup(QPalette::Inactive);
    if (m_sunken)
        m_styleoption->state |= QStyle::State_Sunken;
    if (m_raised)
        m_styleoption->state |= QStyle::State_Raised;
    if (m_selected)
        m_styleoption->state |= QStyle::State_Selected;
    if (m_focus)
        m_styleoption->state |= QStyle::State_HasFocus;
    if (m_on)
        m_styleoption->state |= QStyle::State_On;
    if (m_hover)
        m_styleoption->state |= QStyle::State_MouseOver;
    if (m_horizontal)
        m_styleoption->state |= QStyle::State_Horizontal;

    // some styles don't draw a focus rectangle if
    // QStyle::State_KeyboardFocusChange is not set
    if (window()) {
         if (m_lastFocusReason == Qt::TabFocusReason || m_lastFocusReason == Qt::BacktabFocusReason) {
             m_styleoption->state |= QStyle::State_KeyboardFocusChange;
         }
    }

    if (sizeHint == QLatin1String("mini")) {
        m_styleoption->state |= QStyle::State_Mini;
    } else if (sizeHint == QLatin1String("small")) {
        m_styleoption->state |= QStyle::State_Small;
    }

}

const char* KQuickStyleItem::classNameForItem() const
{
    switch(m_itemType) {
    case Button:
        return "QPushButton";
    case RadioButton:
        return "QRadioButton";
    case CheckBox:
        return "QCheckBox";
    case ComboBox:
        return "QComboBox";
    case ComboBoxItem:
        return "QComboMenuItem";
    case ToolBar:
        return "";
    case ToolButton:
        return "QToolButton";
    case Tab:
        return "QTabButton";
    case TabFrame:
        return "QTabBar";
    case Edit:
        return "QTextEdit";
    case GroupBox:
        return "QGroupBox";
    case Header:
        return "QHeaderView";
    case Item:
    case ItemRow:
        return "QAbstractItemView";
    case Menu:
    case MenuItem:
        return "QMenu";
    case MenuBar:
    case MenuBarItem:
        return "QMenuBar";
    default:
        return "";
    }
    Q_UNREACHABLE();
}

void KQuickStyleItem::resolvePalette()
{
    if (QCoreApplication::testAttribute(Qt::AA_SetPalette))
        return;

    m_styleoption->palette = m_theme->palette();
}

/*
 *   Property style
 *
 *   Returns a simplified style name.
 *
 *   QMacStyle = "mac"
 *   QWindowsXPStyle = "windowsxp"
 *   QFusionStyle = "fusion"
 */

QString KQuickStyleItem::style() const
{
    QString style = qApp->style()->metaObject()->className();
    style = style.toLower();
    if (style.startsWith(QLatin1Char('q')))
        style = style.right(style.length() - 1);
    if (style.endsWith(QLatin1String("style")))
        style = style.left(style.length() - 5);
    return style;
}

QString KQuickStyleItem::hitTest(int px, int py)
{
    QStyle::SubControl subcontrol = QStyle::SC_All;
    switch (m_itemType) {
    case SpinBox :{
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_SpinBox,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), nullptr);
        if (subcontrol == QStyle::SC_SpinBoxUp)
            return QStringLiteral("up");
        else if (subcontrol == QStyle::SC_SpinBoxDown)
            return QStringLiteral("down");
    }
        break;

    case Slider: {
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_Slider,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), nullptr);
        if (subcontrol == QStyle::SC_SliderHandle)
            return QStringLiteral("handle");
    }
        break;

    case ScrollBar: {
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_ScrollBar,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), nullptr);
        switch (subcontrol) {
        case QStyle::SC_ScrollBarSlider:
            return QStringLiteral("handle");

        case QStyle::SC_ScrollBarSubLine:
            return QStringLiteral("up");

        case QStyle::SC_ScrollBarSubPage:
            return QStringLiteral("upPage");

        case QStyle::SC_ScrollBarAddLine:
            return QStringLiteral("down");

        case QStyle::SC_ScrollBarAddPage:
            return QStringLiteral("downPage");

        default:
            break;
        }
    }
        break;

    default:
        break;
    }
    return QStringLiteral("none");
}

QSize KQuickStyleItem::sizeFromContents(int width, int height)
{
    initStyleOption();

    QSize size;
    switch (m_itemType) {
    case RadioButton:
        size =  qApp->style()->sizeFromContents(QStyle::CT_RadioButton, m_styleoption, QSize(width,height));
        break;
    case CheckBox:
        size =  qApp->style()->sizeFromContents(QStyle::CT_CheckBox, m_styleoption, QSize(width,height));
        break;
    case ToolBar:
        size = QSize(200, style().contains(QLatin1String("windows")) ? 30 : 42);
        break;
    case ToolButton: {
        QStyleOptionToolButton *btn = qstyleoption_cast<QStyleOptionToolButton*>(m_styleoption);
        int w = 0;
        int h = 0;
        if (btn->toolButtonStyle != Qt::ToolButtonTextOnly) {
            QSize icon = btn->iconSize;
            w = icon.width();
            h = icon.height();
        }
        if (btn->toolButtonStyle != Qt::ToolButtonIconOnly) {
            QSize textSize = btn->fontMetrics.size(Qt::TextShowMnemonic, btn->text);
            textSize.setWidth(textSize.width() + btn->fontMetrics.width(QLatin1Char(' '))*2);
            if (btn->toolButtonStyle == Qt::ToolButtonTextUnderIcon) {
                h += 4 + textSize.height();
                if (textSize.width() > w)
                    w = textSize.width();
            } else if (btn->toolButtonStyle == Qt::ToolButtonTextBesideIcon) {
                w += 4 + textSize.width();
                if (textSize.height() > h)
                    h = textSize.height();
            } else { // TextOnly
                w = textSize.width();
                h = textSize.height();
            }
        }
        btn->rect.setSize(QSize(w, h));
        size = qApp->style()->sizeFromContents(QStyle::CT_ToolButton, m_styleoption, QSize(w, h)); }
        break;
    case Button: {
        QStyleOptionButton *btn = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);

        int contentWidth = btn->fontMetrics.width(btn->text);
        int contentHeight = btn->fontMetrics.height();
        if (!btn->icon.isNull()) {
            //+4 matches a hardcoded value in QStyle and acts as a margin between the icon and the text.
            contentWidth += btn->iconSize.width() + 4;
            contentHeight = qMax(btn->fontMetrics.height(), btn->iconSize.height());
        }
        int newWidth = qMax(width, contentWidth);
        int newHeight = qMax(height, contentHeight);
        size = qApp->style()->sizeFromContents(QStyle::CT_PushButton, m_styleoption, QSize(newWidth, newHeight)); }
        break;
    case ComboBox: {
        QStyleOptionComboBox *btn = qstyleoption_cast<QStyleOptionComboBox*>(m_styleoption);
        int newWidth = qMax(width, btn->fontMetrics.width(btn->currentText));
        int newHeight = qMax(height, btn->fontMetrics.height());
        size = qApp->style()->sizeFromContents(QStyle::CT_ComboBox, m_styleoption, QSize(newWidth, newHeight)); }
        break;
    case Tab:
        size = qApp->style()->sizeFromContents(QStyle::CT_TabBarTab, m_styleoption, QSize(width,height));
        break;
    case Slider:
        size = qApp->style()->sizeFromContents(QStyle::CT_Slider, m_styleoption, QSize(width,height));
        break;
    case ProgressBar:
        size = qApp->style()->sizeFromContents(QStyle::CT_ProgressBar, m_styleoption, QSize(width,height));
        break;
    case SpinBox:
    case Edit:
        {
            // We have to create a new style option since we might be calling with a QStyleOptionSpinBox
            QStyleOptionFrame frame;
            frame.state = m_styleoption->state;
            frame.lineWidth = qApp->style()->pixelMetric(QStyle::PM_DefaultFrameWidth, m_styleoption, nullptr);
            frame.rect = m_styleoption->rect;
            frame.styleObject = this;
            size = qApp->style()->sizeFromContents(QStyle::CT_LineEdit, &frame, QSize(width, height));
            if (m_itemType == SpinBox)
                size.setWidth(qApp->style()->sizeFromContents(QStyle::CT_SpinBox,
                                                              m_styleoption, QSize(width + 2, height)).width());
        }
        break;
    case GroupBox: {
            QStyleOptionGroupBox *box = qstyleoption_cast<QStyleOptionGroupBox*>(m_styleoption);
            QFontMetrics metrics(box->fontMetrics);
            int baseWidth = metrics.width(box->text) + metrics.width(QLatin1Char(' '));
            int baseHeight = metrics.height() + m_contentHeight;
            if (box->subControls & QStyle::SC_GroupBoxCheckBox) {
                baseWidth += qApp->style()->pixelMetric(QStyle::PM_IndicatorWidth);
                baseWidth += qApp->style()->pixelMetric(QStyle::PM_CheckBoxLabelSpacing);
                baseHeight = qMax(baseHeight, qApp->style()->pixelMetric(QStyle::PM_IndicatorHeight));
            }
            size = qApp->style()->sizeFromContents(QStyle::CT_GroupBox, m_styleoption, QSize(qMax(baseWidth, m_contentWidth), baseHeight));
        }
        break;
    case Header:
        size = qApp->style()->sizeFromContents(QStyle::CT_HeaderSection, m_styleoption, QSize(width,height));
        break;
    case ItemRow:
    case Item: //fall through
        size = qApp->style()->sizeFromContents(QStyle::CT_ItemViewItem, m_styleoption, QSize(width,height));
        break;
    case MenuBarItem:
        size = qApp->style()->sizeFromContents(QStyle::CT_MenuBarItem, m_styleoption, QSize(width,height));
        break;
    case MenuBar:
        size = qApp->style()->sizeFromContents(QStyle::CT_MenuBar, m_styleoption, QSize(width,height));
        break;
    case Menu:
        size = qApp->style()->sizeFromContents(QStyle::CT_Menu, m_styleoption, QSize(width,height));
        break;
    case MenuItem:
    case ComboBoxItem:
        if (static_cast<QStyleOptionMenuItem *>(m_styleoption)->menuItemType == QStyleOptionMenuItem::Scroller) {
            size.setHeight(qMax(QApplication::globalStrut().height(),
                                qApp->style()->pixelMetric(QStyle::PM_MenuScrollerHeight, nullptr, nullptr)));
        } else {
            size = qApp->style()->sizeFromContents(QStyle::CT_MenuItem, m_styleoption, QSize(width,height));
        }
        break;
    default:
        break;
    }
    return size.expandedTo(QSize(m_contentWidth, m_contentHeight));
}

qreal KQuickStyleItem::baselineOffset()
{
    QRect r;
    bool ceilResult = true; // By default baseline offset rounding is done upwards
    switch (m_itemType) {
    case RadioButton:
        r = qApp->style()->subElementRect(QStyle::SE_RadioButtonContents, m_styleoption);
        break;
    case Button:
        r = qApp->style()->subElementRect(QStyle::SE_PushButtonContents, m_styleoption);
        break;
    case CheckBox:
        r = qApp->style()->subElementRect(QStyle::SE_CheckBoxContents, m_styleoption);
        break;
    case Edit:
        r = qApp->style()->subElementRect(QStyle::SE_LineEditContents, m_styleoption);
        break;
    case ComboBox:
        if (const QStyleOptionComboBox *combo = qstyleoption_cast<const QStyleOptionComboBox *>(m_styleoption)) {
            r = qApp->style()->subControlRect(QStyle::CC_ComboBox, combo, QStyle::SC_ComboBoxEditField);
            if (style() != QLatin1String("mac"))
                r.adjust(0,0,0,1);
        }
        break;
    case SpinBox:
        if (const QStyleOptionSpinBox *spinbox = qstyleoption_cast<const QStyleOptionSpinBox *>(m_styleoption)) {
            r = qApp->style()->subControlRect(QStyle::CC_SpinBox, spinbox, QStyle::SC_SpinBoxEditField);
            ceilResult = false;
        }
        break;
    default:
        break;
    }
    if (r.height() > 0) {
        const QFontMetrics &fm = m_styleoption->fontMetrics;
        int surplus = r.height() - fm.height();
        if ((surplus & 1) && ceilResult)
            surplus++;
        int result = r.top() + surplus/2 + fm.ascent();
        return result;
    }

    return 0.;
}

void KQuickStyleItem::updateBaselineOffset()
{
    const qreal baseline = baselineOffset();
    if (baseline > 0)
        setBaselineOffset(baseline);
}

void KQuickStyleItem::setContentWidth(int arg)
{
    if (m_contentWidth != arg) {
        m_contentWidth = arg;
        emit contentWidthChanged(arg);
    }
}

void KQuickStyleItem::setContentHeight(int arg)
{
    if (m_contentHeight != arg) {
        m_contentHeight = arg;
        emit contentHeightChanged(arg);
    }
}

void KQuickStyleItem::updateSizeHint()
{
    QSize implicitSize = sizeFromContents(m_contentWidth, m_contentHeight);
    setImplicitSize(implicitSize.width(), implicitSize.height());
}

void KQuickStyleItem::updateRect()
{
    initStyleOption();
    m_styleoption->rect.setWidth(width());
    m_styleoption->rect.setHeight(height());
}

int KQuickStyleItem::pixelMetric(const QString &metric)
{

    if (metric == QLatin1String("scrollbarExtent"))
        return qApp->style()->pixelMetric(QStyle::PM_ScrollBarExtent, nullptr);
    else if (metric == QLatin1String("defaultframewidth"))
        return qApp->style()->pixelMetric(QStyle::PM_DefaultFrameWidth, m_styleoption);
    else if (metric == QLatin1String("taboverlap"))
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabOverlap, nullptr);
    else if (metric == QLatin1String("tabbaseoverlap"))
        return qApp->style()->pixelMetric(QStyle::PM_TabBarBaseOverlap, m_styleoption);
    else if (metric == QLatin1String("tabhspace"))
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabHSpace, nullptr);
    else if (metric == QLatin1String("indicatorwidth"))
        return qApp->style()->pixelMetric(QStyle::PM_ExclusiveIndicatorWidth, nullptr);
    else if (metric == QLatin1String("tabvspace"))
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabVSpace, nullptr);
    else if (metric == QLatin1String("tabbaseheight"))
        return qApp->style()->pixelMetric(QStyle::PM_TabBarBaseHeight, nullptr);
    else if (metric == QLatin1String("tabvshift"))
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabShiftVertical, nullptr);
    else if (metric == QLatin1String("menubarhmargin"))
        return qApp->style()->pixelMetric(QStyle::PM_MenuBarHMargin, nullptr);
    else if (metric == QLatin1String("menubarvmargin"))
        return qApp->style()->pixelMetric(QStyle::PM_MenuBarVMargin, nullptr);
    else if (metric == QLatin1String("menubarpanelwidth"))
        return qApp->style()->pixelMetric(QStyle::PM_MenuBarPanelWidth, nullptr);
    else if (metric == QLatin1String("menubaritemspacing"))
        return qApp->style()->pixelMetric(QStyle::PM_MenuBarItemSpacing, nullptr);
    else if (metric == QLatin1String("spacebelowmenubar"))
        return qApp->style()->styleHint(QStyle::SH_MainWindow_SpaceBelowMenuBar, m_styleoption);
    else if (metric == QLatin1String("menuhmargin"))
        return qApp->style()->pixelMetric(QStyle::PM_MenuHMargin, nullptr);
    else if (metric == QLatin1String("menuvmargin"))
        return qApp->style()->pixelMetric(QStyle::PM_MenuVMargin, nullptr);
    else if (metric == QLatin1String("menupanelwidth"))
        return qApp->style()->pixelMetric(QStyle::PM_MenuPanelWidth, nullptr);
    else if (metric == QLatin1String("submenuoverlap"))
        return qApp->style()->pixelMetric(QStyle::PM_SubMenuOverlap, nullptr);
    else if (metric == QLatin1String("splitterwidth"))
        return qApp->style()->pixelMetric(QStyle::PM_SplitterWidth, nullptr);
    else if (metric == QLatin1String("scrollbarspacing"))
        return abs(qApp->style()->pixelMetric(QStyle::PM_ScrollView_ScrollBarSpacing, nullptr));
    else if (metric == QLatin1String("treeviewindentation"))
        return qApp->style()->pixelMetric(QStyle::PM_TreeViewIndentation, nullptr);
    return 0;
}

QVariant KQuickStyleItem::styleHint(const QString &metric)
{
    initStyleOption();
    if (metric == QLatin1String("comboboxpopup")) {
        return qApp->style()->styleHint(QStyle::SH_ComboBox_Popup, m_styleoption);
    } else if (metric == QLatin1String("highlightedTextColor")) {
        return m_styleoption->palette.highlightedText().color().name();
    } else if (metric == QLatin1String("textColor")) {
        QPalette pal = m_styleoption->palette;
        pal.setCurrentColorGroup(active()? QPalette::Active : QPalette::Inactive);
        return pal.text().color().name();
    } else if (metric == QLatin1String("focuswidget")) {
        return qApp->style()->styleHint(QStyle::SH_FocusFrame_AboveWidget);
    } else if (metric == QLatin1String("tabbaralignment")) {
        int result = qApp->style()->styleHint(QStyle::SH_TabBar_Alignment);
        if (result == Qt::AlignCenter)
            return QStringLiteral("center");
        return QStringLiteral("left");
    } else if (metric == QLatin1String("externalScrollBars")) {
        return qApp->style()->styleHint(QStyle::SH_ScrollView_FrameOnlyAroundContents);
    } else if (metric == QLatin1String("scrollToClickPosition"))
        return qApp->style()->styleHint(QStyle::SH_ScrollBar_LeftClickAbsolutePosition);
    else if (metric == QLatin1String("activateItemOnSingleClick"))
        return qApp->style()->styleHint(QStyle::SH_ItemView_ActivateItemOnSingleClick);
    else if (metric == QLatin1String("submenupopupdelay"))
        return qApp->style()->styleHint(QStyle::SH_Menu_SubMenuPopupDelay, m_styleoption);
    else if (metric == QLatin1String("wheelScrollLines"))
        return qApp->wheelScrollLines();
    return 0;

    // Add SH_Menu_SpaceActivatesItem
}

void KQuickStyleItem::setHints(const QVariantMap &str)
{
    if (m_hints != str) {
        m_hints = str;
        initStyleOption();
        updateSizeHint();
        if (m_styleoption->state & QStyle::State_Mini) {
            m_font.setPointSize(9.);
            emit fontChanged();
        } else if (m_styleoption->state & QStyle::State_Small) {
            m_font.setPointSize(11.);
            emit fontChanged();
        } else {
            emit hintChanged();
        }
    }
}

void KQuickStyleItem::resetHints()
{
    m_hints.clear();
}


void KQuickStyleItem::setElementType(const QString &str)
{
    if (m_type == str)
        return;

    m_type = str;

    emit elementTypeChanged();
    if (m_styleoption) {
        delete m_styleoption;
        m_styleoption = nullptr;
    }

    // Only enable visible if the widget can animate
    if (str == QLatin1String("menu")) {
        m_itemType = Menu;
    } else if (str == QLatin1String("menuitem")) {
        m_itemType = MenuItem;
    } else if (str == QLatin1String("item") || str == QLatin1String("itemrow") || str == QLatin1String("header")) {
        if (str == QLatin1String("header")) {
            m_itemType = Header;
        } else {
            m_itemType = str == QLatin1String("item") ? Item : ItemRow;
        }
    } else if (str == QLatin1String("itembranchindicator")) {
        m_itemType = ItemBranchIndicator;
    } else if (str == QLatin1String("groupbox")) {
        m_itemType = GroupBox;
    } else if (str == QLatin1String("tab")) {
        m_itemType = Tab;
    } else if (str == QLatin1String("tabframe")) {
        m_itemType = TabFrame;
    } else if (str == QLatin1String("comboboxitem"))  {
        // Gtk uses qobject cast, hence we need to separate this from menuitem
        // On mac, we temporarily use the menu item because it has more accurate
        // palette.
        m_itemType = ComboBoxItem;
    } else if (str == QLatin1String("toolbar")) {
        m_itemType = ToolBar;
    } else if (str == QLatin1String("toolbutton")) {
        m_itemType = ToolButton;
    } else if (str == QLatin1String("slider")) {
        m_itemType = Slider;
    } else if (str == QLatin1String("frame")) {
        m_itemType = Frame;
    } else if (str == QLatin1String("combobox")) {
        m_itemType = ComboBox;
    } else if (str == QLatin1String("splitter")) {
        m_itemType = Splitter;
    } else if (str == QLatin1String("progressbar")) {
        m_itemType = ProgressBar;
    } else if (str == QLatin1String("button")) {
        m_itemType = Button;
    } else if (str == QLatin1String("checkbox")) {
        m_itemType = CheckBox;
    } else if (str == QLatin1String("radiobutton")) {
        m_itemType = RadioButton;
    } else if (str == QLatin1String("edit")) {
        m_itemType = Edit;
    } else if (str == QLatin1String("spinbox")) {
        m_itemType = SpinBox;
    } else if (str == QLatin1String("scrollbar")) {
        m_itemType = ScrollBar;
    } else if (str == QLatin1String("widget")) {
        m_itemType = Widget;
    } else if (str == QLatin1String("focusframe")) {
        m_itemType = FocusFrame;
    } else if (str == QLatin1String("focusrect")) {
        m_itemType = FocusRect;
    } else if (str == QLatin1String("dial")) {
        m_itemType = Dial;
    } else if (str == QLatin1String("statusbar")) {
        m_itemType = StatusBar;
    } else if (str == QLatin1String("machelpbutton")) {
        m_itemType = MacHelpButton;
    } else if (str == QLatin1String("scrollareacorner")) {
        m_itemType = ScrollAreaCorner;
    } else if (str == QLatin1String("menubar")) {
        m_itemType = MenuBar;
    } else if (str == QLatin1String("menubaritem")) {
        m_itemType = MenuBarItem;
    } else {
        m_itemType = Undefined;
    }
    updateSizeHint();
}

QRectF KQuickStyleItem::subControlRect(const QString &subcontrolString)
{
    QStyle::SubControl subcontrol = QStyle::SC_None;
    initStyleOption();
    switch (m_itemType) {
    case SpinBox:
    {
        QStyle::ComplexControl control = QStyle::CC_SpinBox;
        if (subcontrolString == QLatin1String("down"))
            subcontrol = QStyle::SC_SpinBoxDown;
        else if (subcontrolString == QLatin1String("up"))
            subcontrol = QStyle::SC_SpinBoxUp;
        else if (subcontrolString == QLatin1String("edit")){
            subcontrol = QStyle::SC_SpinBoxEditField;
        }
        return qApp->style()->subControlRect(control,
                                             qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                             subcontrol);

    }
        break;
    case Slider:
    {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        if (subcontrolString == QLatin1String("handle"))
            subcontrol = QStyle::SC_SliderHandle;
        else if (subcontrolString == QLatin1String("groove"))
            subcontrol = QStyle::SC_SliderGroove;
        return qApp->style()->subControlRect(control,
                                             qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                             subcontrol);

    }
        break;
    case ScrollBar:
    {
        QStyle::ComplexControl control = QStyle::CC_ScrollBar;
        if (subcontrolString == QLatin1String("slider"))
            subcontrol = QStyle::SC_ScrollBarSlider;
        if (subcontrolString == QLatin1String("groove"))
            subcontrol = QStyle::SC_ScrollBarGroove;
        else if (subcontrolString == QLatin1String("handle"))
            subcontrol = QStyle::SC_ScrollBarSlider;
        else if (subcontrolString == QLatin1String("add"))
            subcontrol = QStyle::SC_ScrollBarAddPage;
        else if (subcontrolString == QLatin1String("sub"))
            subcontrol = QStyle::SC_ScrollBarSubPage;
        return qApp->style()->subControlRect(control,
                                             qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                             subcontrol);
    }
        break;
    case ItemBranchIndicator: {
        QStyleOption opt;
        opt.rect = QRect(0, 0, implicitWidth(), implicitHeight());
        return qApp->style()->subElementRect(QStyle::SE_TreeViewDisclosureItem, &opt, nullptr);
    }
    default:
        break;
    }
    return QRectF();
}

namespace  {
class QHighDpiPixmapsEnabler1 {
public:
    QHighDpiPixmapsEnabler1()
    :wasEnabled(false)
    {
        if (!qApp->testAttribute(Qt::AA_UseHighDpiPixmaps)) {
            qApp->setAttribute(Qt::AA_UseHighDpiPixmaps);
            wasEnabled = true;
        }
    }

    ~QHighDpiPixmapsEnabler1()
    {
        if (wasEnabled)
            qApp->setAttribute(Qt::AA_UseHighDpiPixmaps, false);
    }
private:
    bool wasEnabled;
};
}

void KQuickStyleItem::paint(QPainter *painter)
{
    initStyleOption();
    if (QStyleOptionMenuItem *opt = qstyleoption_cast<QStyleOptionMenuItem*>(m_styleoption))
        painter->setFont(opt->font);
    else {
        QFont font;
        if (m_styleoption->state & QStyle::State_Mini) {
            font = qApp->font("QMiniFont");
        } else if (m_styleoption->state & QStyle::State_Small) {
            font = qApp->font("QSmallFont");
        }
        painter->setFont(font);
    }

    // Set AA_UseHighDpiPixmaps when calling style code to make QIcon return
    // "retina" pixmaps. The flag is controlled by the application so we can't
    // set it unconditinally.
    QHighDpiPixmapsEnabler1 enabler;

    switch (m_itemType) {
    case Button:
        qApp->style()->drawControl(QStyle::CE_PushButton, m_styleoption, painter);
        break;
    case ItemRow :{
        QPixmap pixmap;
        // Only draw through style once
        const QString pmKey = QLatin1Literal("itemrow") % QString::number(m_styleoption->state,16) % activeControl();
        if (!QPixmapCache::find(pmKey, pixmap) || pixmap.width() < width() || height() != pixmap.height()) {
            int newSize = width();
            pixmap = QPixmap(newSize, height());
            pixmap.fill(Qt::transparent);
            QPainter pixpainter(&pixmap);
            qApp->style()->drawPrimitive(QStyle::PE_PanelItemViewRow, m_styleoption, &pixpainter);
            if ((style() == QLatin1String("mac") || !qApp->style()->styleHint(QStyle::SH_ItemView_ShowDecorationSelected)) && selected()) {
                QPalette pal = QApplication::palette("QAbstractItemView");
                pal.setCurrentColorGroup(m_styleoption->palette.currentColorGroup());
                pixpainter.fillRect(m_styleoption->rect, pal.highlight());
            }
            QPixmapCache::insert(pmKey, pixmap);
        }
        painter->drawPixmap(0, 0, pixmap);
    }
        break;
    case Item:
        qApp->style()->drawControl(QStyle::CE_ItemViewItem, m_styleoption, painter);
        break;
    case ItemBranchIndicator:
        qApp->style()->drawPrimitive(QStyle::PE_IndicatorBranch, m_styleoption, painter);
        break;
    case Header:
        qApp->style()->drawControl(QStyle::CE_Header, m_styleoption, painter);
        break;
    case ToolButton:
        qApp->style()->drawComplexControl(QStyle::CC_ToolButton, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter);
        break;
    case Tab:
        {
            if (m_lastFocusReason != Qt::TabFocusReason && m_lastFocusReason != Qt::BacktabFocusReason) {
                m_styleoption->state &= ~QStyle::State_HasFocus;
            }
            qApp->style()->drawControl(QStyle::CE_TabBarTab, m_styleoption, painter);
        }
        break;
    case Frame:
        qApp->style()->drawControl(QStyle::CE_ShapedFrame, m_styleoption, painter);
        break;
    case FocusFrame:
        qApp->style()->drawControl(QStyle::CE_FocusFrame, m_styleoption, painter);
        break;
    case FocusRect:
        qApp->style()->drawPrimitive(QStyle::PE_FrameFocusRect, m_styleoption, painter);
        break;
    case TabFrame:
        qApp->style()->drawPrimitive(QStyle::PE_FrameTabWidget, m_styleoption, painter);
        break;
    case MenuBar:
        qApp->style()->drawControl(QStyle::CE_MenuBarEmptyArea, m_styleoption, painter);
        break;
    case MenuBarItem:
        qApp->style()->drawControl(QStyle::CE_MenuBarItem, m_styleoption, painter);
        break;
    case MenuItem:
    case ComboBoxItem: { // fall through
        QStyle::ControlElement menuElement =
                static_cast<QStyleOptionMenuItem *>(m_styleoption)->menuItemType == QStyleOptionMenuItem::Scroller ?
                    QStyle::CE_MenuScroller : QStyle::CE_MenuItem;
        qApp->style()->drawControl(menuElement, m_styleoption, painter);
        }
        break;
    case CheckBox:
        qApp->style()->drawControl(QStyle::CE_CheckBox, m_styleoption, painter);
        break;
    case RadioButton:
        qApp->style()->drawControl(QStyle::CE_RadioButton, m_styleoption, painter);
        break;
    case Edit: {
        qApp->style()->drawPrimitive(QStyle::PE_PanelLineEdit, m_styleoption, painter);
    }
        break;
    case MacHelpButton:
        //Not managed as mac is not supported
        break;
    case Widget:
        qApp->style()->drawPrimitive(QStyle::PE_Widget, m_styleoption, painter);
        break;
    case ScrollAreaCorner:
        qApp->style()->drawPrimitive(QStyle::PE_PanelScrollAreaCorner, m_styleoption, painter);
        break;
    case Splitter:
        if (m_styleoption->rect.width() == 1)
            painter->fillRect(0, 0, width(), height(), m_styleoption->palette.dark().color());
        else
            qApp->style()->drawControl(QStyle::CE_Splitter, m_styleoption, painter);
        break;
    case ComboBox:
    {
        qApp->style()->drawComplexControl(QStyle::CC_ComboBox,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        // This is needed on mac as it will use the painter color and ignore the palette
        QPen pen = painter->pen();
        painter->setPen(m_styleoption->palette.text().color());
        qApp->style()->drawControl(QStyle::CE_ComboBoxLabel, m_styleoption, painter);
        painter->setPen(pen);
    }    break;
    case SpinBox:
#ifdef Q_OS_MAC
        // macstyle depends on the embedded qlineedit to fill the editfield background
        if (style() == QLatin1String("mac")) {
            QRect editRect = qApp->style()->subControlRect(QStyle::CC_SpinBox,
                                                           qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                           QStyle::SC_SpinBoxEditField);
            painter->fillRect(editRect.adjusted(-1, -1, 1, 1), m_styleoption->palette.base());
        }
#endif
        qApp->style()->drawComplexControl(QStyle::CC_SpinBox,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        break;
    case Slider:
        qApp->style()->drawComplexControl(QStyle::CC_Slider,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        break;
    case Dial:
        qApp->style()->drawComplexControl(QStyle::CC_Dial,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        break;
    case ProgressBar:
        qApp->style()->drawControl(QStyle::CE_ProgressBar, m_styleoption, painter);
        break;
    case ToolBar:
        painter->fillRect(m_styleoption->rect, m_styleoption->palette.window().color());
        qApp->style()->drawControl(QStyle::CE_ToolBar, m_styleoption, painter);
        painter->save();
        painter->setPen(style() != QLatin1String("fusion") ? m_styleoption->palette.dark().color().darker(120) :
                                              m_styleoption->palette.window().color().lighter(107));
        painter->drawLine(m_styleoption->rect.bottomLeft(), m_styleoption->rect.bottomRight());
        painter->restore();
        break;
    case StatusBar:
        {
            painter->fillRect(m_styleoption->rect, m_styleoption->palette.window().color());
            painter->setPen(m_styleoption->palette.dark().color().darker(120));
            painter->drawLine(m_styleoption->rect.topLeft(), m_styleoption->rect.topRight());
            qApp->style()->drawPrimitive(QStyle::PE_PanelStatusBar, m_styleoption, painter);
        }
        break;
    case GroupBox:
        qApp->style()->drawComplexControl(QStyle::CC_GroupBox, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter);
        break;
    case ScrollBar:
        qApp->style()->drawComplexControl(QStyle::CC_ScrollBar, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter);
        break;
    case Menu: {
        QStyleHintReturnMask val;
        qApp->style()->styleHint(QStyle::SH_Menu_Mask, m_styleoption, nullptr, &val);
        painter->save();
        painter->setClipRegion(val.region);
        painter->fillRect(m_styleoption->rect, m_styleoption->palette.window());
        painter->restore();
        qApp->style()->drawPrimitive(QStyle::PE_PanelMenu, m_styleoption, painter);

        if (int fw = qApp->style()->pixelMetric(QStyle::PM_MenuPanelWidth)) {
            QStyleOptionFrame frame;
            frame.state = QStyle::State_None;
            frame.lineWidth = fw;
            frame.midLineWidth = 0;
            frame.rect = m_styleoption->rect;
            frame.styleObject = this;
            frame.palette = m_styleoption->palette;
            qApp->style()->drawPrimitive(QStyle::PE_FrameMenu, &frame, painter);
        }
    }
        break;
    default:
        break;
    }
}

qreal KQuickStyleItem::textWidth(const QString &text)
{
    QFontMetricsF fm = QFontMetricsF(m_styleoption->fontMetrics);
    return fm.boundingRect(text).width();
}

qreal KQuickStyleItem::textHeight(const QString &text)
{
    QFontMetricsF fm = QFontMetricsF(m_styleoption->fontMetrics);
    return text.isEmpty() ? fm.height() :
                            fm.boundingRect(text).height();
}

QString KQuickStyleItem::elidedText(const QString &text, int elideMode, int width)
{
    return m_styleoption->fontMetrics.elidedText(text, Qt::TextElideMode(elideMode), width);
}

bool KQuickStyleItem::hasThemeIcon(const QString &icon) const
{
    return QIcon::hasThemeIcon(icon);
}

bool KQuickStyleItem::event(QEvent *ev)
{
    if (ev->type() == QEvent::StyleAnimationUpdate) {
        if (isVisible()) {
            ev->accept();
            polish();
        }
        return true;
    } else if (ev->type() == QEvent::StyleChange) {
        if (m_itemType == ScrollBar)
            initStyleOption();
    }
    return QQuickItem::event(ev);
}

void KQuickStyleItem::setTextureWidth(int w)
{
    if (m_textureWidth == w)
        return;
    m_textureWidth = w;
    emit textureWidthChanged(m_textureWidth);
    update();
}

void KQuickStyleItem::setTextureHeight(int h)
{
    if (m_textureHeight == h)
        return;
    m_textureHeight = h;
    emit textureHeightChanged(m_textureHeight);
    update();
}

QQuickItem *KQuickStyleItem::control() const
{
    return m_control;
}

void KQuickStyleItem::setControl(QQuickItem *control)
{
    if (control == m_control) {
        return;
    }

    if (m_control) {
        m_control->removeEventFilter(this);
    }

    m_control = control;
    m_control->installEventFilter(this);

    emit controlChanged();
}

QSGNode *KQuickStyleItem::updatePaintNode(QSGNode *node, UpdatePaintNodeData *)
{
    if (m_image.isNull()) {
        delete node;
        return nullptr;
    }

    QSGNinePatchNode *styleNode = static_cast<QSGNinePatchNode *>(node);
    if (!styleNode)
        styleNode = window()->createNinePatchNode();

#ifdef QSG_RUNTIME_DESCRIPTION
    qsgnode_set_description(styleNode,
                            QString::fromLatin1("%1:%2, '%3'")
                            .arg(style())
                            .arg(elementType())
                            .arg(text()));
#endif

    styleNode->setTexture(window()->createTextureFromImage(m_image, QQuickWindow::TextureCanUseAtlas));
    styleNode->setBounds(boundingRect());
    styleNode->setDevicePixelRatio(window()->devicePixelRatio());
    styleNode->setPadding(m_border.left(), m_border.top(), m_border.right(), m_border.bottom());
    styleNode->update();

    return styleNode;
}

void KQuickStyleItem::updatePolish()
{
    if (width() >= 1 && height() >= 1) { // Note these are reals so 1 pixel is minimum
        float devicePixelRatio = window() ? window()->devicePixelRatio() : qApp->devicePixelRatio();
        int w = m_textureWidth > 0 ? m_textureWidth : width();
        int h = m_textureHeight > 0 ? m_textureHeight : height();
        m_image = QImage(w * devicePixelRatio, h * devicePixelRatio, QImage::Format_ARGB32_Premultiplied);
        m_image.setDevicePixelRatio(devicePixelRatio);
        m_image.fill(Qt::transparent);
        QPainter painter(&m_image);
        painter.setLayoutDirection(qApp->layoutDirection());
        paint(&painter);
        QQuickItem::update();
    } else if (!m_image.isNull()) {
        m_image = QImage();
        QQuickItem::update();
    }
}

bool KQuickStyleItem::eventFilter(QObject *watched, QEvent *event)
{
    if (event->type() == QEvent::FocusIn || event->type() == QEvent::FocusOut) {
        QFocusEvent *fe = static_cast<QFocusEvent *>(event);
        m_lastFocusReason = fe->reason();
    }

    return QQuickItem::eventFilter(watched, event);
}

QPixmap QQuickTableRowImageProvider1::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED (requestedSize);
    int width = 16;
    int height = 16;
    if (size)
        *size = QSize(width, height);

    QPixmap pixmap(width, height);

    QStyleOptionViewItem opt;
    opt.state |= QStyle::State_Enabled;
    opt.rect = QRect(0, 0, width, height);
    QString style = qApp->style()->metaObject()->className();
    opt.features = 0;

    if (id.contains(QLatin1String("selected")))
        opt.state |= QStyle::State_Selected;

    if (id.contains(QLatin1String("active"))) {
        opt.state |= QStyle::State_Active;
        opt.palette.setCurrentColorGroup(QPalette::Active);
    } else
        opt.palette.setCurrentColorGroup(QPalette::Inactive);

    if (id.contains(QLatin1String("alternate")))
        opt.features |= QStyleOptionViewItem::Alternate;

    QPalette pal = QApplication::palette("QAbstractItemView");
    if (opt.state & QStyle::State_Selected && (style.contains(QLatin1String("Mac")) ||
                                               !qApp->style()->styleHint(QStyle::SH_ItemView_ShowDecorationSelected))) {
        pal.setCurrentColorGroup(opt.palette.currentColorGroup());
        pixmap.fill(pal.highlight().color());
    } else {
        pixmap.fill(pal.base().color());
        QPainter pixpainter(&pixmap);
        qApp->style()->drawPrimitive(QStyle::PE_PanelItemViewRow, &opt, &pixpainter);
    }
    return pixmap;
}

#include "moc_kquickstyleitem_p.cpp"
#include "moc_kquickpadding_p.cpp"
