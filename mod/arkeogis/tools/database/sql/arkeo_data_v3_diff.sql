DELETE FROM ark_site;
DELETE FROM ark_realestate;
INSERT INTO ark_realestate (re_id, re_parentid, re_name_fr, re_name_de, re_desc )
	VALUES
	(1, NULL, 'Habitat', 'Siedlung', ''),(2, 1, 'Indéterminé', 'Unbestimmt', ''),(3, 2, 'Non renseigné', 'Nicht dokumentiert', ''),(4, 2, 'Fosse', 'Grube', ''),(5, 2, 'Fossé', 'Graben', ''),(6, 1, 'Non renseigné', 'Nicht dokumentiert', ''),(7, 6, 'Non déterminé', 'Unbestimmbar', ''),(8, 6, 'Camp militaire', 'Lager', ''),(9, 6, 'Château', 'Schloss', ''),(10, 6, 'Ferme', 'Bauernhof', ''),(11, 6, 'Villa', 'Villa', ''),(12, 6, 'Village hameau', 'Dorf, Weiler', ''),(13, 1, 'Fortifié', 'Befestigt', ''),(14, 13, 'Non déterminé', 'unbestimmbar', ''),(15, 13, 'Camp militaire', 'Lager', ''),(16, 13, 'Château', 'Schloss', ''),(17, 13, 'Ferme', 'Bauernhof', ''),(18, 13, 'Villa', 'Villa', ''),(19, 13, 'Village hameau', 'Dorf Weiler', ''),(20, 1, 'Enclos', 'Schanze', ''),(21, 20, 'Non déterminé', 'unbestimmbar', ''),(22, 20, 'Camp militaire', 'Lager', ''),(23, 20, 'Château', 'Schloss', ''),(24, 20, 'Ferme', 'Bauernhof', ''),(25, 20, 'Villa', 'Villa', ''),(26, 20, 'Village hameau', 'Dorf Weiler', ''),(27, 1, 'Ouvert', 'Unbefestigt', ''),(28, 27, 'Non déterminé', 'unbestimmbar', ''),(29, 27, 'Camp militaire', 'Lager', ''),(30, 27, 'Château', 'Schloss', ''),(31, 27, 'Ferme', 'Bauernhof', ''),(32, 27, 'Villa', 'Villa', ''),(33, 27, 'Village hameau', 'Dorf Weiler', ''),(34, 1, 'Groupé', 'Dicht', ''),(35, 34, 'Non déterminé', 'unbestimmbar', ''),(36, 34, 'Camp militaire', 'Lager', ''),(37, 34, 'Château', 'Schloss', ''),(38, 34, 'Ferme', 'Bauernhof', ''),(39, 34, 'Villa', 'Villa', ''),(40, 34, 'Village hameau', 'Dorf Weiler', ''),(41, 1, 'Isolé', 'Alleinstehend', ''),(42, 41, 'Non déterminé', 'unbestimmbar', ''),(43, 41, 'Camp militaire', 'Lager', ''),(44, 41, 'Château', 'Schloss', ''),(45, 41, 'Ferme', 'Bauernhof', ''),(46, 41, 'Villa', 'Villa', ''),(47, 41, 'Village hameau', 'Dorf Weiler', ''),(48, NULL, 'Funéraire', 'Gräber', ''),(49, 48, 'Autres', 'Anderes', ''),(50, 49, 'Non renseigné', 'Nicht dokumentiert', ''),(51, 50, 'Architecture de bois', 'Holzarchitektur', ''),(52, 50, 'Architecture de pierre', 'Steinarchitektur', ''),(53, 50, 'Enclos sépulcral', 'Grabbezirk', ''),(54, 50, 'Ustrinum', 'Ustrinum', ''),(55, 49, 'Inhumation', 'Leichengrab', ''),(56, 55, 'Architecture de bois', 'Holzarchitektur', ''),(57, 55, 'Architecture de pierre', 'Steinarchitektur', ''),(58, 55, 'Enclos sépulcral', 'Grabbezirk', ''),(59, 49, 'Incinération', 'Brandgrab', ''),(60, 59, 'Architecture de bois', 'Holzarchitektur', ''),(61, 59, 'Architecture de pierre', 'Steinarchitektur', ''),(62, 59, 'Enclos sépulcral', 'Grabbezirk', ''),(63, 49, 'Les deux', 'Beides', ''),(64, 63, 'Architecture de bois', 'Holzarchitektur', ''),(65, 63, 'Architecture de pierre', 'Steinarchitektur', ''),(66, 63, 'Enclos sépulcral', 'Grabbezirk', ''),(67, 48, 'Enclos Funéraire', 'Grabschanze', ''),(68, 67, 'Non renseigné', 'Nicht dokumentiert', ''),(69, 68, 'Tombe de grand module', 'Grossgrab', ''),(70, 68, 'Architecture de bois', 'Holzarchitektur', ''),(71, 68, 'Architecture de pierre', 'Steinarchitektur', ''),(72, 68, 'Enclos sépulcral', 'Grabbezirk', ''),(73, 67, 'Inhumation', 'Leichengrab', ''),(74, 73, 'Tombe de grand module', 'Grossgrab', ''),(75, 73, 'Architecture de bois', 'Holzarchitektur', ''),(76, 73, 'Architecture de pierre', 'Steinarchitektur', ''),(77, 73, 'Enclos sépulcral', 'Grabbezirk', ''),(78, 67, 'Incinération', 'Brandgrab', ''),(79, 78, 'Tombe de grand module', 'Grossgrab', ''),(80, 78, 'Architecture de bois', 'Holzarchitektur', ''),(81, 78, 'Architecture de pierre', 'Steinarchitektur', ''),(82, 78, 'Enclos sépulcral', 'Grabbezirk', ''),(83, 67, 'Les deux', 'Beides', ''),(84, 83, 'Tombe de grand module', 'Grossgrab', ''),(85, 83, 'Architecture de bois', 'Holzarchitektur', ''),(86, 83, 'Architecture de pierre', 'Steinarchitektur', ''),(87, 83, 'Enclos sépulcral', 'Grabbezirk', ''),(88, 48, 'Tombe plate isolée', 'Einzelner Grab', ''),(89, 88, 'Non renseigné', 'Nicht dokumentiert', ''),(90, 89, 'Architecture de bois', 'Holzarchitektur', ''),(91, 89, 'Architecture de pierre', 'Steinarchitektur', ''),(92, 89, 'Enclos sépulcral', 'Grabbezirk', ''),(93, 88, 'Inhumation', 'Leichengrab', ''),(94, 93, 'Architecture de bois', 'Holzarchitektur', ''),(95, 93, 'Architecture de pierre', 'Steinarchitektur', ''),(96, 93, 'Enclos sépulcral', 'Grabbezirk', ''),(97, 88, 'Incinération', 'Brandgrab', ''),(98, 97, 'Architecture de bois', 'Holzarchitektur', ''),(99, 97, 'Architecture de pierre', 'Steinarchitektur', ''),(100, 97, 'Enclos sépulcral', 'Grabbezirk', ''),(101, 88, 'Les deux', 'Beides', ''),(102, 101, 'Architecture de bois', 'Holzarchitektur', ''),(103, 101, 'Architecture de pierre', 'Steinarchitektur', ''),(104, 101, 'Enclos sépulcral', 'Grabbezirk', ''),(105, 48, 'Tumulus isolé', 'Einzelner Tumulus', ''),(106, 105, 'Non renseigné', 'Nicht dokumentiert', ''),(107, 106, 'Tombe de grand module', 'Grossgrab', ''),(108, 106, 'Architecture de bois', 'Holzarchitektur', ''),(109, 106, 'Architecture de pierre', 'Steinarchitektur', ''),(110, 106, 'Enclos sépulcral', 'Grabbezirk', ''),(111, 105, 'Inhumation', 'Leichengrab', ''),(112, 111, 'Tombe de grand module', 'Grossgrab', ''),(113, 111, 'Architecture de bois', 'Holzarchitektur', ''),(114, 111, 'Architecture de pierre', 'Steinarchitektur', ''),(115, 111, 'Enclos sépulcral', 'Grabbezirk', ''),(116, 105, 'Incinération', 'Brandgrab', ''),(117, 116, 'Tombe de grand module', 'Grossgrab', ''),(118, 116, 'Architecture de bois', 'Holzarchitektur', ''),(119, 116, 'Architecture de pierre', 'Steinarchitektur', ''),(120, 116, 'Enclos sépulcral', 'Grabbezirk', ''),(121, 105, 'Les deux', 'Beides', ''),(122, 121, 'Tombe de grand module', 'Grossgrab', ''),(123, 121, 'Architecture de bois', 'Holzarchitektur', ''),(124, 121, 'Architecture de pierre', 'Steinarchitektur', ''),(125, 121, 'Enclos sépulcral', 'Grabbezirk', ''),(126, 48, 'Nécropole tumulaire', 'Tumuli Nekropole', ''),(127, 126, 'Non renseigné', 'Nicht dokumentiert', ''),(128, 127, 'Tombe de grand module', 'Grossgrab', ''),(129, 127, 'Architecture de bois', 'Holzarchitektur', ''),(130, 127, 'Architecture de pierre', 'Steinarchitektur', ''),(131, 127, 'Enclos sépulcral', 'Grabbezirk', ''),(132, 126, 'Inhumation', 'Leichengrab', ''),(133, 132, 'Tombe de grand module', 'Grossgrab', ''),(134, 132, 'Architecture de bois', 'Holzarchitektur', ''),(135, 132, 'Architecture de pierre', 'Steinarchitektur', ''),(136, 132, 'Enclos sépulcral', 'Grabbezirk', ''),(137, 126, 'Incinération', 'Brandgrab', ''),(138, 137, 'Tombe de grand module', 'Grossgrab', ''),(139, 137, 'Architecture de bois', 'Holzarchitektur', ''),(140, 137, 'Architecture de pierre', 'Steinarchitektur', ''),(141, 137, 'Enclos sépulcral', 'Grabbezirk', ''),(142, 126, 'Les deux', 'Beides', ''),(143, 142, 'Tombe de grand module', 'Grossgrab', ''),(144, 142, 'Architecture de bois', 'Holzarchitektur', ''),(145, 142, 'Architecture de pierre', 'Steinarchitektur', ''),(146, 142, 'Enclos sépulcral', 'Grabbezirk', ''),(147, 48, 'Nécropole tombes plates', 'Gräberfeld', ''),(148, 147, 'Non renseigné', 'Nicht dokumentiert', ''),(149, 148, 'Architecture de bois', 'Holzarchitektur', ''),(150, 148, 'Architecture de pierre', 'Steinarchitektur', ''),(151, 148, 'Enclos sépulcral', 'Grabbezirk', ''),(152, 147, 'Inhumation', 'Leichengrab', ''),(153, 152, 'Architecture de bois', 'Holzarchitektur', ''),(154, 152, 'Architecture de pierre', 'Steinarchitektur', ''),(155, 152, 'Enclos sépulcral', 'Grabbezirk', ''),(156, 147, 'Incinération', 'Brandgrab', ''),(157, 156, 'Architecture de bois', 'Holzarchitektur', ''),(158, 156, 'Architecture de pierre', 'Steinarchitektur', ''),(159, 156, 'Enclos sépulcral', 'Grabbezirk', ''),(160, 147, 'Les deux', 'Beides', ''),(161, 160, 'Architecture de bois', 'Holzarchitektur', ''),(162, 160, 'Architecture de pierre', 'Steinarchitektur', ''),(163, 160, 'Enclos sépulcral', 'Grabbezirk', ''),(164, NULL, 'Isolé', 'Einzelfund', ''),(165, 164, 'Bloc architectural', 'Baustein', ''),(166, 165, 'Inscription', 'Inschrift', ''),(167, 165, 'Non-inscrit', 'Ohne inschrift', ''),(168, 165, 'Figuré', 'Figürlich', ''),(169, 164, 'Dépôt', 'Hortfund', ''),(170, 169, 'Inscription', 'Inschrift', ''),(171, 169, 'Non-inscrit', 'Ohne inschrift', ''),(172, 169, 'Figuré', 'Figürlich', ''),(173, 164, 'Découverte subaquatique', 'Gewaesserfund', ''),(174, 173, 'Inscription', 'Inschrift', ''),(175, 173, 'Non-inscrit', 'Ohne inschrift', ''),(176, 173, 'Figuré', 'Figürlich', ''),(177, 164, 'Statuaire', 'Statue', ''),(178, 177, 'Inscription', 'Inschrift', ''),(179, 177, 'Non-inscrit', 'Ohne inschrift', ''),(180, 177, 'Figuré', 'Figürlich', ''),(181, 164, 'Stèle', 'Stele', ''),(182, 181, 'Inscription', 'Inschrift', ''),(183, 181, 'Non-inscrit', 'Ohne inschrift', ''),(184, 181, 'Figuré', 'Figürlich', ''),(185, NULL, 'Rituel', 'Kult', ''),(186, 185, 'Indéterminé', 'Unbestimmt', ''),(187, 186, 'Arme mutilée', 'verbogen Waffen', ''),(188, 186, 'Association de mobiliers', 'Fundzusammenhang', ''),(189, 186, 'Jetons', 'Spielstein', ''),(190, 186, 'Monnaies', 'Münzen', ''),(191, 186, 'Ossements humains', 'Menschenknochen', ''),(192, 186, 'Ossements animaux', 'Tierknochen', ''),(193, 186, 'Rouelles', 'Radamulett', ''),(194, 186, 'Statuette', 'Statuette', ''),(195, 186, 'Vases miniatures', 'Miniaturgefässe', ''),(196, 185, 'Fanum', 'Fanum', ''),(197, 196, 'Arme mutilée', 'verbogen Waffen', ''),(198, 196, 'Association de mobiliers', 'Fundzusammenhang', ''),(199, 196, 'Jetons', 'Spielstein', ''),(200, 196, 'Monnaies', 'Münzen', ''),(201, 196, 'Ossements humains', 'Menschenknochen', ''),(202, 196, 'Ossements animaux', 'Tierknochen', ''),(203, 196, 'Rouelles', 'Radamulett', ''),(204, 196, 'Statuette', 'Statuette', ''),(205, 196, 'Vases miniatures', 'Miniaturgefässe', ''),(206, 185, 'Puits', 'Brunnen', ''),(207, 206, 'Arme mutilée', 'verbogen Waffen', ''),(208, 206, 'Association de mobiliers', 'Fundzusammenhang', ''),(209, 206, 'Jetons', 'Spielstein', ''),(210, 206, 'Monnaies', 'Münzen', ''),(211, 206, 'Ossements humains', 'Menschenknochen', ''),(212, 206, 'Ossements animaux', 'Tierknochen', ''),(213, 206, 'Rouelles', 'Radamulett', ''),(214, 206, 'Statuette', 'Statuette', ''),(215, 206, 'Vases miniatures', 'Miniaturgefässe', ''),(216, 185, 'Source', 'Quelle', ''),(217, 216, 'Arme mutilée', 'verbogen Waffen', ''),(218, 216, 'Association de mobiliers', 'Fundzusammenhang', ''),(219, 216, 'Jetons', 'Spielstein', ''),(220, 216, 'Monnaies', 'Münzen', ''),(221, 216, 'Ossements humains', 'Menschenknochen', ''),(222, 216, 'Ossements animaux', 'Tierknochen', ''),(223, 216, 'Rouelles', 'Radamulett', ''),(224, 216, 'Statuette', 'Statuette', ''),(225, 216, 'Vases miniatures', 'Miniaturgefässe', ''),(226, 185, 'Grotte', 'Höhle', ''),(227, 226, 'Arme mutilée', 'verbogen Waffen', ''),(228, 226, 'Association de mobiliers', 'Fundzusammenhang', ''),(229, 226, 'Jetons', 'Spielstein', ''),(230, 226, 'Monnaies', 'Münzen', ''),(231, 226, 'Ossements humains', 'Menschenknochen', ''),(232, 226, 'Ossements animaux', 'Tierknochen', ''),(233, 226, 'Rouelles', 'Radamulett', ''),(234, 226, 'Statuette', 'Statuette', ''),(235, 226, 'Vases miniatures', 'Miniaturgefässe', ''),(236, 185, 'Dans l’habitat', 'Im sieldungskontext', ''),(237, 236, 'Arme mutilée', 'verbogen Waffen', ''),(238, 236, 'Association de mobiliers', 'Fundzusammenhang', ''),(239, 236, 'Jetons', 'Spielstein', ''),(240, 236, 'Monnaies', 'Münzen', ''),(241, 236, 'Ossements humains', 'Menschenknochen', ''),(242, 236, 'Ossements animaux', 'Tierknochen', ''),(243, 236, 'Rouelles', 'Radamulett', ''),(244, 236, 'Statuette', 'Statuette', ''),(245, 236, 'Vases miniatures', 'Miniaturgefässe', ''),(246, 185, 'Isolé', 'Alleinstehend', ''),(247, 246, 'Arme mutilée', 'verbogen Waffen', ''),(248, 246, 'Association de mobiliers', 'Fundzusammenhang', ''),(249, 246, 'Jetons', 'Spielstein', ''),(250, 246, 'Monnaies', 'Münzen', ''),(251, 246, 'Ossements humains', 'Menschenknochen', ''),(252, 246, 'Ossements animaux', 'Tierknochen', ''),(253, 246, 'Rouelles', 'Radamulett', ''),(254, 246, 'Statuette', 'Statuette', ''),(255, 246, 'Vases miniatures', 'Miniaturgefässe', ''),(256, 185, 'Abbaye', 'Kloster', ''),(257, 256, 'Arme mutilée', 'verbogen Waffen', ''),(258, 256, 'Association de mobiliers', 'Fundzusammenhang', ''),(259, 256, 'Jetons', 'Spielstein', ''),(260, 256, 'Monnaies', 'Münzen', ''),(261, 256, 'Ossements humains', 'Menschenknochen', ''),(262, 256, 'Ossements animaux', 'Tierknochen', ''),(263, 256, 'Rouelles', 'Radamulett', ''),(264, 256, 'Statuette', 'Statuette', ''),(265, 256, 'Vases miniatures', 'Miniaturgefässe', ''),(266, 185, 'Eglise', 'Kirche', ''),(267, 266, 'Arme mutilée', 'verbogen Waffen', ''),(268, 266, 'Association de mobiliers', 'Fundzusammenhang', ''),(269, 266, 'Jetons', 'Spielstein', ''),(270, 266, 'Monnaies', 'Münzen', ''),(271, 266, 'Ossements humains', 'Menschenknochen', ''),(272, 266, 'Ossements animaux', 'Tierknochen', ''),(273, 266, 'Rouelles', 'Radamulett', ''),(274, 266, 'Statuette', 'Statuette', ''),(275, 266, 'Vases miniatures', 'Miniaturgefässe', ''),(276, 185, 'Temple', 'Tempel', ''),(277, 276, 'Arme mutilée', 'verbogen Waffen', ''),(278, 276, 'Association de mobiliers', 'Fundzusammenhang', ''),(279, 276, 'Jetons', 'Spielstein', ''),(280, 276, 'Monnaies', 'Münzen', ''),(281, 276, 'Ossements humains', 'Menschenknochen', ''),(282, 276, 'Ossements animaux', 'Tierknochen', ''),(283, 276, 'Rouelles', 'Radamulett', ''),(284, 276, 'Statuette', 'Statuette', ''),(285, 276, 'Vases miniatures', 'Miniaturgefässe', ''),(286, NULL, 'Circulation', 'Verkehr', ''),(287, 286, 'Gué', 'Furth', ''),(288, 287, 'Pente aménagée', 'Steige', ''),(289, 286, 'Pont', 'Brücke', ''),(290, 289, 'Pente aménagée', 'Steige', ''),(291, 286, 'Voie', 'Wege', ''),(292, 291, 'Pente aménagée', 'Steige', ''),(293, 286, 'Aménagement de berge', 'Uferbefestigung', ''),(294, 286, 'Borne', 'Meilenstein', ''),(295, 286, 'Quai', 'Kai', ''),(296, NULL, 'Fente neolithique', 'Schlitzgrube', ''),(297, 296, 'Non renseigné', 'Nicht dokumentiert', ''),(298, 297, 'Non renseigné', 'Nicht dokumentiert', ''),(299, 297, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(300, 297, 'Intrasite', 'In einer Fundstelle', ''),(301, 296, 'Autres profils', 'Anderes Profil', ''),(302, 301, 'Non renseigné', 'Nicht dokumentiert', ''),(303, 301, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(304, 301, 'Intrasite', 'In einer Fundstelle', ''),(305, 296, 'Profil en U', 'U-förmiges Profil', ''),(306, 305, 'Non renseigné', 'Nicht dokumentiert', ''),(307, 305, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(308, 305, 'Intrasite', 'In einer Fundstelle', ''),(309, 296, 'Profil en V', 'V-förmiges Profil', ''),(310, 309, 'Non renseigné', 'Nicht dokumentiert', ''),(311, 309, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(312, 309, 'Intrasite', 'In einer Fundstelle', ''),(313, 296, 'Profil en Y', 'Y-förmiges Profil', ''),(314, 313, 'Non renseigné', 'Nicht dokumentiert', ''),(315, 313, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(316, 313, 'Intrasite', 'In einer Fundstelle', '');
