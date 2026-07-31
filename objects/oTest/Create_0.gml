asepriteFile = AsepriteRead("linkedcel.aseprite");
asepriteFile.DeleteTagsByMask("*[ignore]");
asepriteFile.HideLayersByMask("*[ignore]");
asepriteFile.Render();