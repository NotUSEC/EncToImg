# EncToImg
Репозиторий который содержит закодированные строки, которые при расшифровке выводят картинку.

В основном тут мемы если что, просто потому что короткая ссылка на GH выглядит красивее длинной B64 на 3к строк.

Исполняемые файлы выполняющие шифрование/расшифрование лежат в корне репоизитория и имеют соответствующие расширения.

## Пример шифрования изображения

1 - Запускаем EncToJpg.ps1

2 - Нажимаем цифру "1", жмём на клавиатуре "Enter"

3 - Прописываем полный путь до шифруемого файла. Пример: "C:\Users\user\Downloads\testEncToJPG\download00.jpg"

Зашифрованная версия сохраняется в той же директории, имеет то же название, но с расширением .bin

## Пример расшифрования изображения по URL
1 - Запускаем EncToJpg.ps1

2 - Нажимаем цифру "2", жмём на клавиатуре "Enter"

3 - Прописываем полный URL путь до файлика в формате RAW. Пример: "https://github.com/NotUSEC/EncToImg/raw/refs/heads/main/data/HSHNtSA.bin"

4 - Прописываем полный путь куда сохранить расшифрованное изображение, и в каком формате. Пример: "C:\Users\locadm\Downloads\testEncToJPG\HSHNtSA.png"

Если прошло успешно, то в ответ выдаст путь куда сохранилось изображение.

## Пример расшифрования изображения из .bin

1 - Запускаем EncToJpg.ps1

2 - Нажимаем цифру "2", жмём на клавиатуре "Enter"

3 - Прописываем полный путь до .bin файла. Пример: "C:\Users\user\Downloads\testEncToJPG\download00.bin"

4 - Прописываем полный путь куда сохранить расшифрованное изображение, и в каком формате. Пример: "C:\Users\locadm\Downloads\testEncToJPG\download01.jpg"

Если прошло успешно, то в ответ выдаст путь куда сохранилось изображение.
