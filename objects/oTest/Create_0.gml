asepriteFile = AsepriteImport("sSimon.ase");
asepriteFile.DeleteTagsByMask("*[ignore]");
asepriteFile.HideLayersByMask("*[ignore]");
asepriteFile.Render();
