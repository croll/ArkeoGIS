--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: ch_page_pid_seq; Type: SEQUENCE SET; Schema: public; Owner: captainhook
--

SELECT pg_catalog.setval('ch_page_pid_seq', 15, true);


--
-- Data for Name: ch_page; Type: TABLE DATA; Schema: public; Owner: captainhook
--

INSERT INTO ch_page VALUES (4, 'partenaires', 'Partenaires', 1, 1, '', 'fr_FR', 0, '2012-03-01 16:55:28', '2012-03-01 18:56:11');
INSERT INTO ch_page VALUES (6, 'logiciel', 'Logiciel', 1, 1, '', 'fr_FR', 0, '2012-03-01 17:39:18', '2012-03-01 18:56:59');
INSERT INTO ch_page VALUES (8, 'credits', 'Crédits', 1, 1, '', 'fr_FR', 0, '2012-03-01 18:57:40', '2012-03-01 18:57:40');
INSERT INTO ch_page VALUES (9, 'contact', 'Contact', 1, 1, '', 'fr_FR', 0, '2012-03-01 18:57:59', '2012-03-01 18:58:09');
INSERT INTO ch_page VALUES (7, 'code_source', 'Code Source', 1, 1, '', 'fr_FR', 0, '2012-03-01 18:57:17', '2012-03-01 18:58:15');
INSERT INTO ch_page VALUES (10, 'manuel_requetes', 'Manuel Requêtes', 1, 1, '', 'fr_FR', 0, '2012-03-01 18:58:43', '2012-03-01 18:58:43');
INSERT INTO ch_page VALUES (11, 'manuel_fiches', 'Manuel Fiches', 1, 1, '', 'fr_FR', 0, '2012-03-01 18:59:05', '2012-03-01 18:59:05');
INSERT INTO ch_page VALUES (13, 'manuel_cartes', 'Manuel Cartes', 1, 1, '', 'fr_FR', 0, '2012-03-01 18:59:34', '2012-03-01 18:59:34');
INSERT INTO ch_page VALUES (12, 'manuel_import', 'Manuel Import', 1, 1, '', 'fr_FR', 0, '2012-03-01 18:59:17', '2012-03-01 19:00:10');
INSERT INTO ch_page VALUES (14, 'presentation', 'Présentation', 1, 1, '<p>
	<b>ArkeoGIS</b></p>
<p style="margin-bottom: 0cm">
	La finalit&eacute; de ce projet est de mettre en commun les donn&eacute;es scientifiques disponibles en arch&eacute;ologie sur la vall&eacute;e du Rhin, depuis les Vosges jusque dans la For&ecirc;t-Noire. Il est en effet difficile de trouver l&#39;information qui n&#39;est pas toujours publi&eacute;e.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Il n&rsquo;existe pas &agrave; ce jour de cartes actualis&eacute;es et scientifiques traitant de l&rsquo;&eacute;tat des connaissances arch&eacute;ologiques de part et d&rsquo;autre du Rhin, et on ne peut plus se contenter de cartes arr&ecirc;t&eacute;es au fleuve.</p>
<p style="margin-bottom: 0cm">
	La sp&eacute;cificit&eacute; g&eacute;ographique de cette vall&eacute;e est &agrave; prendre en compte pour l&rsquo;arch&eacute;ologie : qu&rsquo;est-ce qui a pu &ecirc;tre d&eacute;truit par l&rsquo;&eacute;rosion, ou recouvert par des colluvions, et comment les g&eacute;ographes peuvent-ils contribuer aux probl&eacute;matiques arch&eacute;ologiques ?</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Le r&eacute;seau de chercheurs dont les travaux ont trait &agrave; l&rsquo;arch&eacute;ologie ou &agrave; la g&eacute;ographie du Rhin Sup&eacute;rieur est en train de se recomposer suite &agrave; de nombreuses fusions (Universit&eacute; de Strasbourg, Regierungspr&auml;sidien, apparition d&rsquo;op&eacute;rateurs priv&eacute;s&hellip;).</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	<u>Objectifs</u></p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Le projet vise &agrave; mutualiser les travaux arch&eacute;ologiques effectu&eacute;s par les op&eacute;rateurs de l&#39;arch&eacute;ologie dans la vall&eacute;e du Rhin.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Les services r&eacute;gionaux de l&rsquo;arch&eacute;ologie fourniront des donn&eacute;es brutes et aideront &agrave; la r&eacute;flexion scientifique sur la hi&eacute;rarchisation de ces donn&eacute;es.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Par la suite, les informations seront regroup&eacute;es et compar&eacute;es avec des donn&eacute;es scientifiques et g&eacute;ographiques sur la vall&eacute;e du Rhin gr&acirc;ce &agrave; un web-SIA (syst&egrave;me d&rsquo;information arch&eacute;ologique) actualis&eacute;, participatif, transfrontalier et interactif.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Les r&eacute;sultats attendus constitueront une relecture actualis&eacute;e de nos connaissances sur l&rsquo;histoire de la vall&eacute;e du Rhin. Plus concr&egrave;tement cela am&egrave;nera &agrave; la production de cartes antiques repr&eacute;sentant la r&eacute;alit&eacute; de la recherche aujourd&rsquo;hui.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Cette base de donn&eacute;es, mise &agrave; disposition des diff&eacute;rents acteurs de l&#39;arch&eacute;ologie, participera en outre de la bonne conservation et de la mise en valeur du patrimoine. Ce sera la garantie d&rsquo;une am&eacute;lioration des &eacute;changes scientifiques et techniques entre les services patrimoniaux, universitaires ou de recherche dans le cadre d&rsquo;une coop&eacute;ration transfrontali&egrave;re renouvel&eacute;e.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	<u>Contenu du projet</u></p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Concr&egrave;tement, il s&#39;agit de d&eacute;velopper un web-SIA (Syst&egrave;me d&#39;Information arch&eacute;ologique en ligne) s&eacute;curis&eacute; et bilingue permettant aux diff&eacute;rents partenaires du projet de disposer d&#39;un outil propre permettant de visualiser les donn&eacute;es cartographi&eacute;es concernant la fin de la Pr&eacute;histoire et l&#39;antiquit&eacute;. Ce web-SIA servira d&rsquo;outil de recherche comme d&rsquo;outil p&eacute;dagogique.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Cela permettra :</p>
<p style="margin-bottom: 0cm">
	-De valoriser, hi&eacute;rarchiser et exploiter des donn&eacute;es existantes en les mettant en commun.</p>
<p style="margin-bottom: 0cm">
	-De d&eacute;velopper la pr&eacute;sentation cartographique bilingue et coh&eacute;rente des sites antiques de la vall&eacute;e du Rhin, &agrave; destination des chercheurs, des &eacute;tudiants et du public</p>
<p style="margin-bottom: 0cm">
	-De mettre en commun l&rsquo;exp&eacute;rience des diff&eacute;rents op&eacute;rateurs</p>
<p style="margin-bottom: 0cm">
	-De d&eacute;velopper des formations binationales</p>
<p style="margin-bottom: 0cm">
	-D&rsquo;int&eacute;grer mieux des probl&eacute;matiques g&eacute;ographiques &agrave; l&rsquo;arch&eacute;ologie</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Ce projet participera ainsi pleinement &agrave; une gestion dynamique des sites arch&eacute;ologiques rh&eacute;nans, dans leur dimension tout &agrave; la fois patrimoniale, culturelle, scientifique et touristique.</p>
', 'fr_FR', 0, '2012-03-01 18:59:52', '2012-03-01 19:07:49');
INSERT INTO ch_page VALUES (15, 'ausgangsituation', 'Ausgangsituation', 1, 1, '<p>
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	<u>Ausgangsituation</u></p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Die Grundidee des Projekts ist es, die wissenschaftlichen arch&auml;ologischen Daten, die beiderseits des Rheins verf&uuml;gbar sind, zusammenzufassen. Es ist in der Praxis sehr kompliziert, die entsprechenden Informationen zu finden, da diese selten ver&ouml;ffentlicht werden.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Bis heute existieren keine aktuellen Karten, die den arch&auml;ologischen Forschungsstand zu beiden Seiten des Rheins darstellen. Es ist jedoch n&ouml;tig, sich nicht mehr mit Karten zu den antiken Kulturverh&auml;ltnissen zu begn&uuml;gen, die am Rhein enden. Die geografische Besonderheit des Rheintals in seinem chronologischen und geomorphologischen Kontext muss auch von Arch&auml;ologen ber&uuml;cksichtigt werden: was wurde von der Erosion beseitigt oder durch Kolluvien &uuml;berdeckt und was k&ouml;nnen Geographen zur Beantwortung arch&auml;ologischer Fragen beitragen?</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Die Vernetzung arch&auml;ologischer und geographischer Forscher am Oberrhein ist durch mehrere Umstrukturierungen (Vereinigung der Stra&szlig;burger Universit&auml;ten, Schaffung der Regierungspr&auml;sidien, Aufkommen von private Arch&auml;ologen &hellip;) in den letzten Jahren in eine wichtige Entwicklungsphase gelangt.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	<u>Projektziele</u></p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Das Ziel des Projektes ist die Zusammenf&uuml;hrung der arch&auml;ologischen und historischen Informationen zum Rheintal (z.B. von Seiten der Universit&auml;ten, des CNRS, der Denkmalpflege&hellip;)</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Die Landesdenkmal&auml;mter werden Rohdaten zur Verf&uuml;gung stellen, und wissenschaftliche Hilfe zur Hierarchisierung bringen.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Diese Daten werden dann, durch ein aktualisiertes, grenz&uuml;berschreitendes und interaktives web-AIS (arch&auml;ologisches Informationssystem) mit wissenschaftlichen und geographischen Daten &uuml;ber den Rheintal verkn&uuml;pft.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Das anvisierte Ergebnis des Projekts ist ein aktualisierter &Uuml;berblick &uuml;ber die Geschichte des Rheintals. Als neues Instrument hierzu sollen neue thematische Karten des Rheintals auf der Basis des aktuellen Forschungsstandes entstehen.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Die Datenbank wird den verschiedenen Akteuren im Bereich der regionalen Arch&auml;ologie zur Verf&uuml;gung gestellt und wird schlie&szlig;lich zu einer verbesserten denkmalpflegerischen und wissenschaftlichen Verwaltung der Denkm&auml;ler beitragen. Sie wird ausserdem zur Verbesserung der wissenschaftlichen und technischen Zusammenarbeit zwischen den &Auml;mtern f&uuml;r Denkmalschutz, sowie Wisschenschaftlern an den Universit&auml;ten und anderen Forschungseinrichtungen beitragen.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	<u>Projektinhalt</u></p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Konkret soll ein zweisprachiges und sicheres online-AIS (Arch&auml;ologisches Informations System) entwickelt werden, das es den verschiedenen Projektpartnern erm&ouml;glicht, per EDV die arch&auml;ologischen Daten von der Sp&auml;tbronzezeit bis zum Ende der R&ouml;merzeit kartographisch darzustellen und online darauf zuzugreifen. Diese web-AIS wird zu Forschungszwecken und als p&auml;dagogisches Werkzeug benutzt werden.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Dieser online-AIS wird es erm&ouml;glichen:</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	- die existierenden Daten aufzuwerten, zu hierarchisieren und sie durch die Verbindung neu zu interpretieren</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	-Koh&auml;rente zweisprachige Pr&auml;sentationen von Fundstellen im Rheintal in Form von Karten zu erstellen, f&uuml;r Forscher, Studenten und f&uuml;r die &Ouml;ffentlichkeit.</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	-Erfahrungen unter Arch&auml;ologen auszutauschen</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	-Binationale Studieng&auml;nge zu f&ouml;rdern</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	-geographische Fragestellungen besser in der Arch&auml;ologie zu integrieren</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	&nbsp;</p>
<p lang="de-DE" style="margin-bottom: 0cm">
	Dieses Projekt wird so dazu beitragen, die arch&auml;ologischen Fundstellen des Rheintals dynamisch zu verwalten in ihrer denkmalpflegerischen, kulturellen, wissenschaftlichen und touristischen Dimension.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	<b>Projet B 27, b&eacute;n&eacute;ficiaire des fonds FEDER de l&rsquo;INTERREG IV Rhin Sup&eacute;rieur, Juin 2011-juin 2013 </b></p>
<p style="margin-bottom: 0cm">
	<b>&laquo;&nbsp;arkeoGIS&nbsp;: Entre Vosges et For&ecirc;t-Noire, arch&eacute;ologie et g&eacute;ographies antiques&nbsp;&raquo;</b></p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	<font color="#0000ff"><u><a href="http://www.interreg-rhin-sup.eu/priorite-b,10204,fr.html">http://www.interreg-rhin-sup.eu/priorite-b,10204,fr.html</a></u></font></p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	INTERREG &laquo;&nbsp;d&eacute;passer les fronti&egrave;res, projet apr&egrave;s projet&nbsp;&raquo;</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
', 'de_DE', 14, '2012-03-01 19:09:33', '2012-03-01 19:09:33');
INSERT INTO ch_page VALUES (5, 'historique', 'Historique', 1, 1, '<p>
	<b>Programme scientifique MISHA 2009-2012</b></p>
<p style="margin-bottom: 0cm">
	<b>Entre Vosges et For&ecirc;t-Noire&nbsp;: approches arch&eacute;ologiques et g&eacute;ographiques des dynamiques de peuplement et de communication de l&rsquo;&acirc;ge du Bronze au Moyen-&Acirc;ge autour du Rhin</b></p>
<p style="margin-bottom: 0cm">
	Coordination L. Bernard</p>
<p style="margin-bottom: 0cm">
	Ce programme s&#39;articule autour du Rhin sup&eacute;rieur, il a permis de f&eacute;d&eacute;rer un certain nombre de chercheurs en arch&eacute;ologie et en g&eacute;ographie travaillant dans la vall&eacute;e du Rhin au sein de diff&eacute;rentes structures&nbsp;: Universit&eacute;s, services r&eacute;gionaux de l&rsquo;arch&eacute;ologie et op&eacute;rateurs pr&eacute;ventifs en arch&eacute;ologie en Alsace et dans le pays de Bade. L&rsquo;id&eacute;e de base &eacute;tant de mettre en commun les bases inventaires et recherche des deux r&eacute;gions et d&rsquo;y inclure &agrave; terme des donn&eacute;es g&eacute;ographiques.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Un web-SIG (Syst&egrave;me d&rsquo;Informations G&eacute;ographique en ligne) propre a &eacute;t&eacute; d&eacute;velopp&eacute; qui permet d&#39;unifier sur une carte les informations arch&eacute;ologiques disponibles de part et d&#39;autre du fleuve, sur une zone test comprise entre Saverne et Baden-Baden. La fourchette chronologique prend en compte des sites depuis l&#39;&acirc;ge du Bronze jusqu&#39;au haut Moyen-&Acirc;ge.</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	Deux types de m&eacute;thodes ont &eacute;t&eacute; envisag&eacute;es&nbsp;: les outils arch&eacute;ologiques non-destructifs que sont le SIG ainsi que des outils g&eacute;ographiques et pal&eacute;oenvironnementaux. Le programme s&rsquo;attache &eacute;galement &agrave; d&eacute;velopper des travaux de terrain en arch&eacute;ologie, en Alsace et dans le Bade.</p>
<p style="margin-bottom: 0cm">
	L&rsquo;&eacute;tude arch&eacute;ologique repose pour l&rsquo;instant sur une cartographie des diff&eacute;rents sites des r&eacute;gions concern&eacute;es sur 125 communes alsaciennes pour l&rsquo;instant, &agrave; partir d&#39;une fiche simple mentionnant le type de site (habitat, fun&eacute;raire, sanctuaire) et sa chronologie. La datation de ces sites se fait par fourchettes. Sont &eacute;galement cartographi&eacute;s diff&eacute;rents mobiliers arch&eacute;ologiques qui peuvent t&eacute;moigner de circulations ou d&#39;un commerce, et apparaissent caract&eacute;ristiques pour chacune des p&eacute;riodes consid&eacute;r&eacute;es (exemple&nbsp;: &acirc;ge du Bronze moyen&nbsp;: hache de type Haguenau&nbsp;; La T&egrave;ne D&nbsp;: amphore Dressel 1, c&eacute;ramique campanienne).</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	<u>Bilan scientifique</u>&nbsp;:</p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	&nbsp;</p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	Dans le cadre du d&eacute;veloppement de l&rsquo;outil informatique arkeoGIS et de la mise en commun des donn&eacute;es arch&eacute;ologiques fran&ccedil;aises et allemandes (L. Bernard, G. Wieland, B. Rabold, M. Lasserre, D. Bonneterre, G. Triantafillidis)</p>
<p align="JUSTIFY" style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	- version b&ecirc;ta fonctionnelle d&rsquo;arkeoGIS en ligne, permettant d&rsquo;afficher des cartes fran&ccedil;aises et allemandes (L. Bernard)</p>
<p align="JUSTIFY" style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	-exploitation de cet outil dans le cadre de la licence d&rsquo;arch&eacute;ologie (L. Bernard)</p>
<p align="JUSTIFY" style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	-281 gisements arch&eacute;ologiques recens&eacute;s &agrave; ce jour dans la base de donn&eacute;es, en Alsace et dans le Bade (L. Bernard, G. Wieland, B. Rabold, M. Lasserre, D. Bonneterre)</p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	&nbsp;</p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	D&eacute;veloppement des activit&eacute;s de recherche en arch&eacute;ologie sur le terrain (L. Bernard, G. Wieland)</p>
<p style="margin-bottom: 0cm">
	<font face="Courier New, monospace"><font size="2"><font face="Times New Roman, serif"><font size="3">-campagne de prospections dans la vall&eacute;e du Rhin sur les communes de part et d&rsquo;autre d&rsquo;Iffezheim &ndash; d&eacute;couverte de nouveaux indices de peuplement antique du 31 ao&ucirc;t au 11 septembre 2009 (L. Bernard, G. Wieland, M. Lasserre)</font></font></font></font></p>
<p align="JUSTIFY" style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	-Fouille franco-allemande en partenariat avec le <i>Landesdenkmalamt</i> de Karlsruhe en Juin 2010 et 2011, 3 semaines pour chaque campagne &agrave; Neuenb&uuml;rg (RFA), ayant donn&eacute; lieu &agrave; une premi&egrave;re publication (Arch&auml;ologische Ausgrabungen in Baden-W&uuml;rttemberg 2010)</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	&nbsp;</p>
<p style="margin-bottom: 0cm">
	<font face="Courier New, monospace"><font size="2"><font face="Times New Roman, serif"><font size="3">Un &laquo;&nbsp;cluster&nbsp;&raquo; a &eacute;t&eacute; obtenu afin d&rsquo;h&eacute;berger le projet au sein du TGE Adonis, participation aux 2</font></font><sup><font face="Times New Roman, serif"><font size="3">e</font></font></sup><font face="Times New Roman, serif"><font size="3"> journ&eacute;es Universit&eacute; du TGE Adonis du 05 au 08 d&eacute;cembre 2010 &agrave; Lyon</font></font></font></font></p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	&nbsp;</p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	Pr&eacute;sentation de l&rsquo;outil et du programme dans un cadre scientifique (L. Bernard)</p>
<p style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	-pr&eacute;sentation d&rsquo;arkeoGIS et du programme dans le cadre du Collegium Beatus Rhenanus le 20-11-2009) (L. Bernard)</p>
<p style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	- &ldquo;Le SIG en arch&eacute;ologie, le projet arkeoGIS&rdquo; dans le cadre des R&eacute;flexions &eacute;pist&eacute;mologiques interdisciplinaires sur l&#39;usage de l&#39;outil informatique en SHS organis&eacute;es &agrave; la MISHA (11-12-2009) (L. Bernard)</p>
<p style="margin-bottom: 0cm; widows: 0; orphans: 0">
	&nbsp;</p>
<p style="margin-bottom: 0cm; widows: 0; orphans: 0">
	Publications et mise en valeur du projet (L. Bernard, D. Schwartz)</p>
<p align="JUSTIFY" style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	-sous presse <i>in</i> C. Marcigny et V. Carpentier (eds.), Presses Univ. Rennes (2010)&nbsp;: <i>&eacute;tudes actuelles sur un type de paysage agraire encore tr&egrave;s peu connu en Alsace&nbsp;: les paysages d&rsquo;enclos m&eacute;di&eacute;vaux Extension, typologie, &eacute;l&eacute;ments de datation</i>. Dominique SCHWARTZ, Damien ERTLEN, Julien BATTMANN, Mathilde CASPARD, Anne GEBHART, St&eacute;phanie GOEPP, Florian BASOGE, Laure KOUPALIANTZ, Bernhard METZ (D. Schwartz, A. Gebhardt, D. Ertlen)</p>
<p style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	- arkeoGIS : le nouveau Google Earth de la recherche ? <i>in</i> Savoir(s) n&deg;2, avril 2009, p.20) (L. Bernard)</p>
<p align="JUSTIFY" style="text-indent: 1.25cm; margin-bottom: 0cm; widows: 0; orphans: 0">
	-arkeoGIS, un nouveau programme MISHA <i>in</i> CBR EUCOR newsletter 12/2009, pp.10-11 (L. Bernard)</p>
<p style="text-indent: 1.25cm; margin-bottom: 0cm">
	-Pr&eacute;sentation du programme aux 2&deg; Journ&eacute;es d&rsquo;Informatique et Arch&eacute;ologie de Paris (JIAP 11-12/06-2010), un article a &eacute;t&eacute; envoy&eacute; pour l&rsquo;&eacute;dition de la journ&eacute;e &laquo;&nbsp;arkeoGIS, d&eacute;veloppement d&rsquo;un webSIG transfrontalier : contraintes et premiers r&eacute;sultats&nbsp;&raquo;&nbsp;</p>
<p align="JUSTIFY" style="margin-bottom: 0cm; widows: 0; orphans: 0">
	&nbsp;</p>
<p align="JUSTIFY" style="margin-bottom: 0cm">
	L&rsquo;int&eacute;gration de doctorants de l&rsquo;Universit&eacute; de Strasbourg sera un autre axe porteur du projet. En effet, la plupart des travaux actuels comportant un inventaire, g&eacute;n&eacute;ralement fait &agrave; l&rsquo;&eacute;cart des autres participants, leur int&eacute;gration dans ce projet leur permettra de disposer d&rsquo;un outil arch&eacute;ologique et g&eacute;ographique d&eacute;di&eacute;. Les travaux de doctorants en arch&eacute;ologie concernant les sites fortifi&eacute;s (Cl. F&eacute;liu), les formes c&eacute;ramiques celtiques et gallo-romaines et la circulation de ces produits artisanaux (B. Bonaventure, C. Fortun&eacute;) seront &eacute;galement int&eacute;gr&eacute;s &agrave; la cartographie.</p>
<p align="JUSTIFY" style="margin-bottom: 0cm">
	&nbsp;</p>
', 'fr_FR', 0, '2012-03-01 16:55:46', '2012-03-01 19:11:03');


--
-- PostgreSQL database dump complete
--

