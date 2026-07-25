function AsepriteImport(_filename, _keepSurfaces = true)
{
    if (not file_exists(_filename))
    {
        __AsepriteError($"Cannot find \"{_filename}\"");
    }
    
    var _buffer = buffer_load(_filename);
    if (not buffer_exists(_buffer))
    {
        __AsepriteError($"Failed to load \"{_filename}\"");
    }
    
    return (new __AsepriteClassFile()).__Deserialize(_buffer, _keepSurfaces);
}