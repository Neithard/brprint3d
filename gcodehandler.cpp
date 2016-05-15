#include "gcodehandler.h"
#include <QTextStream>
#include <QFileInfo>

GCodeHandler::GCodeHandler(QObject *parent) : QObject(parent)
{

}

/*
 * Save edit file - overrite
*/
void GCodeHandler::saveFile() //Default pattern .gcode - Needs handle it?
{
    QFile gcode(m_filePath.toLocalFile());
    if(!gcode.open(QFile::WriteOnly | QFile::Text)){
        gcode.write(m_doc->toPlainText().toUtf8());
        gcode.close();
    }

}

void GCodeHandler::setFilePath(QUrl &name)
{
    if(m_filePath != name){
        m_filePath = name;
        QString path = name.toLocalFile();
        setFileName(QFileInfo(path).baseName());
        setFileContent(path);
    }
}

QString GCodeHandler::fileName() const
{
    return m_fileName;
}

QString GCodeHandler::fileContent() const
{
    return m_fileContent;
}

void GCodeHandler::setFileContent(QString path)
{
    if (!path.isEmpty()) { //Remove this test???
        QFile gcode(path);
        if (!gcode.open(QFile::ReadOnly | QFile::Text)) {
            return;
        }
        QTextStream in(&gcode);
        m_fileContent = in.readAll();
        emit fileContentChanged(m_fileContent);
    }
}

void GCodeHandler::setFileName(QString n)
{
    if(m_fileName != n){
        m_fileName = n;
        emit fileNameChanged(m_fileName);
    }
}
