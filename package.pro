TEMPLATE = app
TARGET = package

QT += qml quick widgets network

SOURCES += main.cpp

lupdate_only{
SOURCES = *.qml \
          content/*.qml \
          content/styles/*.qml
          content/scripts/*.js
}

RESOURCES += package.qrc

# DEV DEPLOYMENT
OBJECTS_DIR = $$OUT_PWD/_build/obj
MOC_DIR     = $$OUT_PWD/_build/moc
RCC_DIR     = $$OUT_PWD/_build/rcc
UI_DIR      = $$OUT_PWD/_build/ui
