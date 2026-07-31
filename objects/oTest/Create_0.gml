asepriteFile = AsepriteRead("slice.aseprite");
asepriteFile.DeleteTagsByMask("*[ignore]");
asepriteFile.HideLayersByMask("*[ignore]");
asepriteFile.Render();