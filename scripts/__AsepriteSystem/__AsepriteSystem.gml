function __AsepriteSystem()
{
    static _once = (function()
    {
        with({})
        {
            __writePaletteIndex  = 0;
            __userDataToTagIndex = 0;
            
            return self;
        }
    })();
    
    return _once;
}