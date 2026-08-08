asepriteFile = AsepriteRead("slice.aseprite");
asepriteFile.DeleteTagsByMask("*[ignore]");
asepriteFile.HideLayersByMask("*[ignore]");
asepriteFile.Render();

show_debug_message(asepriteFile.GetSliceNames());