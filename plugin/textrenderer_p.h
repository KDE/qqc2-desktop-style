/*
    SPDX-FileCopyrightText: 2022 by David Edmundson <davidedmundson@kde.org>
*/

#include <QQuickItem>
#include <QQuickWindow>

class TextRenderAttached : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QQuickWindow::TextRenderType renderType READ renderType NOTIFY renderTypeChanged)
public:
    TextRenderAttached(QObject *attachee);

    QQuickWindow::TextRenderType renderType() const
    {
        return m_renderType;
    }
Q_SIGNALS:
    void renderTypeChanged();

protected:
    void itemChange(ItemChange, const ItemChangeData &value) override;

private:
    QQuickWindow::TextRenderType m_renderType = QQuickWindow::NativeTextRendering;
    void update();
};

class TextRenderer : public QObject
{
    Q_OBJECT
    QML_ATTACHED(TextRenderAttached)
    static TextRenderAttached *qmlAttachedProperties(QObject *object)
    {
        return new TextRenderAttached(object);
    }
};
