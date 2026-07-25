// https://github.com/aseprite/aseprite/blob/main/docs/ase-file-specs.md

function __AsepriteClassFile() constructor
{
    static _system = __AsepriteSystem();
    
    colorProfile = {
        type: 1, //Default to sRGB
        flags: 0,
        fixedGamma: 1, //Linear sRGB
    };
    
    layerArray  = [];
    tagDict     = {};
    tagArray    = [];
    sliceArray  = [];
    framesArray = [];
    hasUUIDs    = false;
    
    paletteArray     = array_create(256, 0x00000000);
    paletteNameArray = array_create(256, undefined);
    
    width      = undefined;
    height     = undefined;
    colorDepth = undefined;
    pixelRatio = 1;
    
    userData = undefined;
    
    grid = {
        enabled: false,
        x: 0,
        y: 0,
        width: 0,
        height: 0,
    };
    
    
    
    static GetFrameCount = function()
    {
        return array_length(framesArray);
    }
    
    static Draw = function(_image, _x, _y)
    {
        framesArray[max(0, _image) mod array_length(framesArray)].Draw(_x, _y);
    }
    
    static DrawExt = function(_image, _x, _y, _xScale, _yScale, _angle, _blend, _alpha)
    {
        framesArray[max(0, _image) mod array_length(framesArray)].DrawExt(_x, _y, _xScale, _yScale, _angle, _blend, _alpha);
    }
    
    static Destroy = function()
    {
        var _i = 0;
        repeat(array_length(framesArray))
        {
            framesArray[_i].__Destroy();
            ++_i;
        }
    }
    
    
    
    static __Deserialize = function(_buffer, _keepSurfaces)
    {
        _system.__writePaletteIndex  = 0;
        _system.__userDataToTagIndex = 0;
        
        var _filesize = buffer_read(_buffer, buffer_u32);
        if (buffer_get_size(_buffer) != _filesize)
        {
            __AsepriteTrace($"Warning! Buffer size {buffer_get_size(_buffer)} doesn't agree with Aseprite filesize {_filesize}");
        }
        
        var _magicNumber = buffer_read(_buffer, buffer_u16);
        if (_magicNumber != 0xA5E0)
        {
            __AsepriteError($"Magic number check failed; got 0x{string_delete(string(ptr(_magicNumber)), 1, 12)}, expecting 0xA5E0");
        }
        
        array_resize(framesArray, buffer_read(_buffer, buffer_u16));
        width      = buffer_read(_buffer, buffer_u16);
        height     = buffer_read(_buffer, buffer_u16);
        colorDepth = buffer_read(_buffer, buffer_u16);
        flags      = buffer_read(_buffer, buffer_u32); hasUUIDs = ((flags & 0b100) > 0);
        buffer_seek(_buffer, buffer_seek_relative, 2); //Deprecated
        buffer_seek(_buffer, buffer_seek_relative, 8); //Unused
        transparentIndex = buffer_read(_buffer, buffer_u8);
        buffer_seek(_buffer, buffer_seek_relative, 3); //Unused
        
        colorCount = buffer_read(_buffer, buffer_u16);
        if (colorCount <= 0) colorCount = 256;
        
        var _pixelWidth  = buffer_read(_buffer, buffer_u8);
        var _pixelHeight = buffer_read(_buffer, buffer_u8);
        pixelRatio = ((_pixelWidth == 0) || (_pixelHeight == 0))? 1 : (_pixelWidth / _pixelHeight);
        
        var _gridX      = buffer_read(_buffer, buffer_s16);
        var _gridY      = buffer_read(_buffer, buffer_s16);
        var _gridWidth  = buffer_read(_buffer, buffer_u16);
        var _gridHeight = buffer_read(_buffer, buffer_u16);
        
        grid = {
            enabled: ((_gridWidth != 0) && (_gridHeight != 0)),
            x: _gridX,
            y: _gridY,
            width:  _gridWidth,
            height: _gridHeight,
        };
        
        buffer_seek(_buffer, buffer_seek_relative, 84); //Reserved
        
        var _i = 0;
        repeat(array_length(framesArray))
        {
            framesArray[@ _i] = (new __AsepriteClassFrame()).__Deserialize(_buffer, self);
            ++_i;
        }
        
        paletteArray[@ transparentIndex] &= 0x00_FFFFFF;
        
        var _i = 0;
        repeat(array_length(framesArray))
        {
            framesArray[_i].__Flatten(self, paletteArray, transparentIndex, _keepSurfaces);
            ++_i;
        }
        
        return self;
    }
}