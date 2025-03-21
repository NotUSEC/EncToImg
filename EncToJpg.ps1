function Convert-ImageToCompressedEncryptedBinary {
    param (
        [string]$ImagePath
    )
    
    if (!(Test-Path $ImagePath)) {
        Write-Host "Файл не существует: $ImagePath"
        return
    }
    
    $Bytes = [System.IO.File]::ReadAllBytes($ImagePath)
    
    $CompressedStream = New-Object System.IO.MemoryStream
    $DeflateStream = New-Object System.IO.Compression.DeflateStream ($CompressedStream, [System.IO.Compression.CompressionMode]::Compress)
    $DeflateStream.Write($Bytes, 0, $Bytes.Length)
    $DeflateStream.Close()
    
    $CompressedBytes = $CompressedStream.ToArray()
    
    $Key = [System.Text.Encoding]::UTF8.GetBytes("9s1ZyTdp3NciKGQdGCeS")
        # Да, я знаю что ключ шифрования нельзя хранить в коде, но сам проект пишется просто по приколу, так что целям проекта это не мешает.
    # fyi ключ можно заменить в любой момент :)
    $Aes = [System.Security.Cryptography.Aes]::Create()
    $Aes.Key = $Key + (New-Object byte[] (32 - $Key.Length))
    $Aes.IV = New-Object byte[] (16)
    $Encryptor = $Aes.CreateEncryptor()
    
    $EncryptedBytes = $Encryptor.TransformFinalBlock($CompressedBytes, 0, $CompressedBytes.Length)
    
    $OutputPath = [System.IO.Path]::ChangeExtension($ImagePath, ".bin")
    [System.IO.File]::WriteAllBytes($OutputPath, $EncryptedBytes)
    
    Write-Host "Файл сохранен: $OutputPath"
}

function Convert-EncryptedBinaryToImage {
    param (
        [string]$EncodedFilePath,
        [string]$OutputImagePath
    )
    
    if ($EncodedFilePath -match "^https?:\/\/.*") {
        try {
            $EncryptedBytes = Invoke-WebRequest -Uri $EncodedFilePath -UseBasicParsing | Select-Object -ExpandProperty Content
            $EncryptedBytes = [Convert]::FromBase64String($EncryptedBytes)
        } catch {
            Write-Host "Ошибка загрузки файла по URL: $_"
            return
        }
    } elseif (Test-Path $EncodedFilePath) {
        $EncryptedBytes = [System.IO.File]::ReadAllBytes($EncodedFilePath)
    } else {
        Write-Host "Файл не найден: $EncodedFilePath"
        return
    }
    
    $Key = [System.Text.Encoding]::UTF8.GetBytes("9s1ZyTdp3NciKGQdGCeS")
    # Да, я знаю что ключ шифрования нельзя хранить в коде, но сам проект пишется просто по приколу, так что целям проекта это не мешает.
    # fyi ключ можно заменить в любой момент :)
    $Aes = [System.Security.Cryptography.Aes]::Create()
    $Aes.Key = $Key + (New-Object byte[] (32 - $Key.Length))
    $Aes.IV = New-Object byte[] (16)
    $Decryptor = $Aes.CreateDecryptor()
    
    $DecryptedBytes = $Decryptor.TransformFinalBlock($EncryptedBytes, 0, $EncryptedBytes.Length)
    
    $CompressedStream = New-Object System.IO.MemoryStream (,$DecryptedBytes)
    $DeflateStream = New-Object System.IO.Compression.DeflateStream ($CompressedStream, [System.IO.Compression.CompressionMode]::Decompress)
    
    $OutputStream = New-Object System.IO.MemoryStream
    $DeflateStream.CopyTo($OutputStream)
    $DeflateStream.Close()
    
    $DecompressedBytes = $OutputStream.ToArray()
    [System.IO.File]::WriteAllBytes($OutputImagePath, $DecompressedBytes)
    
    Write-Host "Изображение восстановлено: $OutputImagePath"
}

Write-Host "Выберите действие:`n1. Зашифровать изображение`n2. Расшифровать изображение"
$choice = Read-Host "Введите 1 или 2"

if ($choice -eq "1") {
    $imagePath = Read-Host "Введите путь к картинке ТОЛЬКО JPG. В формате C:\somedir\somefile.jpg"
    Convert-ImageToCompressedEncryptedBinary -ImagePath $imagePath
} elseif ($choice -eq "2") {
    $encodedFilePath = Read-Host "Введите путь до закодированного файла или URL с данными в RAW"
    $outputImagePath = Read-Host "Введите путь куда сохранить вывод. В формате C:\somedir\somefile.jpg"
    Convert-EncryptedBinaryToImage -EncodedFilePath $encodedFilePath -OutputImagePath $outputImagePath
} else {
    Write-Host "Неверный ввод. Запустите скрипт заново."
}
