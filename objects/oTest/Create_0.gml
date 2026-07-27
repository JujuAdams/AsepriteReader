asepriteFile = AsepriteRead("test.ase");
asepriteFile.DeleteTagsByMask("*[ignore]");
asepriteFile.HideLayersByMask("*[ignore]");
asepriteFile.Render();
