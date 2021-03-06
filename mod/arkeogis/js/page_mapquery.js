var map;
var queryNum = 0;
var layerMarkers = [];
var mapMarkers = [];
var layers = {};
var layersControl;
var layerType = 'simple';
var showLabels = false;

var select_savedqueries_inhib_selection_event = false;

window.addEvent('domready', function() {

    /* initialization of plusminus menus */
    arkeo_menu = {};

    /* pour traduction
       ch_t('arkeogis', 'inventory');
       ch_t('arkeogis', 'research');
    */

    var submenus = {};
    var pmmenu = new PlusMinusMenu();
    for (var i = 0; i < menus.db.length; i++) {
        if (!(menus.db[i]['da_type'] in submenus)) {
            var folder_item = new PlusMinusItem(ch_t('arkeogis', menus.db[i]['da_type']), null, null, {});
            folder_item.setSubMenu(new PlusMinusMenu());
            submenus[menus.db[i]['da_type']] = folder_item;
            pmmenu.addItem(folder_item);
        }
        //submenus[menus.db[i]['da_type']].addJsonItem(menus.db[i]);
        var item = new PlusMinusItem(menus.db[i].name, menus.db[i].id, null, {});
        var helpcontent = '';
        helpcontent += '<table>';
        helpcontent += '<tr>';
        helpcontent += '<td class="treecol"><b>' + ch_t('arkeogis', "Nom de l'Auteur") + '</b> :<br />' + menus.db[i]['full_name'] + '</td>';
        if (menus.db[i]['da_declared_modification'])
            helpcontent += '<td class="treecol"><b>' + ch_t('arkeogis', "Dernière mise à jour") + '</b> :<br />' + new Date(menus.db[i]['da_declared_modification'].substring(0, 10))
                .toLocaleDateString() + '</td>';
        helpcontent += '<td class="treecol"><b>' + ch_t('arkeogis', "Numéro ISSN") + '</b> :<br />' + menus.db[i]['da_issn'] + '</td>';
        helpcontent += '</tr><tr>';
        helpcontent += '<td class="treecol"><b>' + ch_t('arkeogis', "Échelle") + '</b> :<br />' + ch_t('arkeogis', menus.db[i]['da_scale_resolution']) + '</td>';
        helpcontent += '<td class="treecol"><b>' + ch_t('arkeogis', "Nombre de sites") + '</b> :<br />' + menus.db[i]['da_sites'] + '</td>';
        helpcontent += '<td class="treecol"><b>' + ch_t('arkeogis', "Nombre de lignes") + '</b> :<br />' + menus.db[i]['da_lines'] + '</td>';
        helpcontent += '</tr>';
        helpcontent += '<tr><td class="onecol" colspan="3"><b>' + ch_t('arkeogis', "Limites chronologiques") + '</b> : ' + menus.db[i]['period_start'] + ' - ' + menus.db[i]['period_end'] + '</td></tr>';
        helpcontent += '<tr><td class="onecol" colspan="3"><b>' + ch_t('arkeogis', "Limites géographiques") + '</b> : ' + ch_t('arkeogis', menus.db[i]['geographical_limit']) + '</td></tr>';
        helpcontent += '<tr><td class="onecol" colspan="3"><b>' + ch_t('arkeogis', "Description") + '</b> : ' + menus.db[i]['description'] + '</td></tr>';
        helpcontent += '</table>';
        item.setHelp(new PlusMinusHelp(helpcontent, {}));
        submenus[menus.db[i]['da_type']].submenu.addItem(item);
    }

    arkeo_menu.db = new PlusMinusItem(ch_t('arkeogis', "Choix de la base"), null, pmmenu);
    arkeo_menu.db.inject($('menu_db'));


    arkeo_menu.period = new PlusMinusItem(ch_t('arkeogis', "Choix de la période"), null, null);
    for (var i = 0; i < menus.period.length; i++)
        arkeo_menu.period.addJsonItem(menus.period[i]);
    arkeo_menu.period.inject($('menu_period'));

    arkeo_menu.area = new PlusMinusItem(ch_t('arkeogis', "Choix de l'aire de recherche"), null, new PlusMinusMenu([
 new PlusMinusItem(ch_t('arkeogis', 'Toute la carte'), 'all', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', 'Réctangle de sélection'), 'rect', null, {
            nominus: true,
            cssclass: 'pmmenu-crayon'
        }),
 new PlusMinusItem(ch_t('arkeogis', 'Disque de sélection'), 'circle', null, {
            nominus: true,
            cssclass: 'pmmenu-crayon'
        }),
 new PlusMinusItem(ch_t('arkeogis', 'Coordonnées de sélection'), 'coord', null, {
            nominus: true,
            cssclass: 'pmmenu-crayon'
        })
    ], {
        multiselect: false
    }));
    arkeo_menu.area.inject($('menu_area'));
    arkeo_menu.area.setSelection(['all'], []);

    arkeo_menu.production = new PlusMinusItem(ch_t('arkeogis', "Choix production"), null, null);
    for (var i = 0; i < menus.production.length; i++)
        arkeo_menu.production.addJsonItem(menus.production[i]);
    arkeo_menu.production.inject($('menu_production'));

    arkeo_menu.realestate = new PlusMinusItem(ch_t('arkeogis', "Choix immobilier"), null, null);
    for (var i = 0; i < menus.realestate.length; i++)
        arkeo_menu.realestate.addJsonItem(menus.realestate[i]);
    arkeo_menu.realestate.inject($('menu_realestate'));

    arkeo_menu.furniture = new PlusMinusItem(ch_t('arkeogis', "Choix mobilier"), null, null);
    for (var i = 0; i < menus.furniture.length; i++)
        arkeo_menu.furniture.addJsonItem(menus.furniture[i]);
    arkeo_menu.furniture.inject($('menu_furniture'));

    arkeo_menu.landscape = new PlusMinusItem(ch_t('arkeogis', "Choix paysage"), null, null);
    for (var i = 0; i < menus.landscape.length; i++)
        arkeo_menu.landscape.addJsonItem(menus.landscape[i]);
    arkeo_menu.landscape.inject($('menu_landscape'));


    /* initialization of menus centroid, knowledge, occupation */

    arkeo_menu.centroid = new PlusMinusItem(ch_t('arkeogis', "CENTROID"), null, new PlusMinusMenu([
 new PlusMinusItem(ch_t('arkeogis', "OUI"), 1, null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "NON"), 0, null, {
            nominus: true
        })
    ]));
    arkeo_menu.centroid.inject($('menu-centroid'));

    arkeo_menu.knowledge = new PlusMinusItem(ch_t('arkeogis', "CONNAISSANCE"), null, new PlusMinusMenu([
 new PlusMinusItem(ch_t('arkeogis', "Non renseigné"), 'unknown', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Littérature, prospecté"), 'literature', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Sondé"), 'surveyed', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Fouillé"), 'excavated', null, {
            nominus: true
        })
    ]));
    arkeo_menu.knowledge.inject($('menu-knowledge'));

    arkeo_menu.occupation = new PlusMinusItem(ch_t('arkeogis', "OCCUPATION"), null, new PlusMinusMenu([
 new PlusMinusItem(ch_t('arkeogis', "Non renseigné"), 'unknown', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Unique"), 'uniq', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Continue (plusieurs périodes contiguës)"), 'continuous', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Multiple (plusieurs périodes indépendantes)"), 'multiple', null, {
            nominus: true
        })
    ]));
    arkeo_menu.occupation.inject($('menu-occupation'));

    arkeo_menu.txtsearch_options = new PlusMinusItem(ch_t('arkeogis', "Choisir"), null, new PlusMinusMenu([
 new PlusMinusItem(ch_t('arkeogis', "Nom du site"), 'si_name', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Commune"), 'si_city_name', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Biblio"), 'sp_bibliography', null, {
            nominus: true
        }),
 new PlusMinusItem(ch_t('arkeogis', "Remarque"), 'sp_comment', null, {
            nominus: true
        })
    ]));
    arkeo_menu.txtsearch_options.inject($('menu_txtsearch_options'));
    arkeo_menu.txtsearch_options.setSelected('+', true);


    /* initialization of buttons "afficher la carte" and "afficher le tableur" */

    $('onglet')
        .addEvent('click', function() {
            show_menu(!menu_showing);
        });


    $('btn-show-the-map')
        .addEvent('click', function() {
            queryNum += 1;
            var form = buildSelectionObject();
            if ((form.db_include.length > 0 || form.db_exclude > 0) && (form.period_include.length > 0 || form.period_exclude.length > 0) && (form.area_include.length > 0 || form.area_exclude.length > 0) && (
                (form.production_include.length > 0 || form.production_exclude.length > 0 || form.realestate_include.length > 0 || form.realestate_exclude.length > 0 || form.furniture_include.length > 0 || form.furniture_exclude.length > 0 || form.landscape_include.length > 0 || form.landscape_exclude.length > 0)
            ) || (
                (form.txtsearch && form.txtsearch_options.getSelection('+')
                    .length > 0)
            )) {} else {
                CaptainHook.Message.show(ch_t('arkeogis', "Vous devez choisir au moins une base, une période, une aire de recherche ainsi qu'une caractérisation et/ou une recherche textuelle"));
                return;
            }

            showSpinner();
            new Request.JSON({
                'url': '/ajax/call/arkeogis/showthemap',
                'onSuccess': function(res) {
                    hideSpinner();
                    display_query(form);
                    if (res.mapmarkers.length < res.total_count && confirm(ch_t('arkeogis', "Seulement %d sites seront affiché sur %d au total. Souhaitez-vous télécharger la liste au format csv ? Cliquer sur le bouton Cancel affichera les 1500 premiers sites.", res.mapmarkers.length, parseInt(res.total_count)))) {

                        // download the sites as csv file
                        window.location.href = '/export_sheet/' + encodeURIComponent(JSON.encode(form));
                        return;
                    } else if (res.mapmarkers.length == 0) {
                        CaptainHook.Message.show(ch_t('arkeogis', 'Aucun résultat'));
                    }
                    $('map_sheet')
                        .setStyles({
                            'display': 'none'
                        });
                    show_menu(false);
                    mapMarkers[queryNum] = res.mapmarkers;
                    drawMarkers(queryNum);
                    updateControls();

                    delete res;

                }
            })
                .post({
                    search: form,
                    queryNum: queryNum
                });
        });

    $('btn-show-the-table')
        .addEvent('click', function() {
            queryNum += 1;
            var form = buildSelectionObject();
            if ((form.db_include.length > 0 || form.db_exclude > 0) && (form.period_include.length > 0 || form.period_exclude.length > 0) && (form.area_include.length > 0 || form.area_exclude.length > 0) && (form.production_include.length > 0 || form.production_exclude.length > 0 || form.realestate_include.length > 0 || form.realestate_exclude.length > 0 || form.furniture_include.length > 0 || form.furniture_exclude.length > 0 || form.landscape_include.length > 0 || form.landscape_exclude.length > 0)) {
                var form = buildSelectionObject();
            } else {
                CaptainHook.Message.show(ch_t('arkeogis', "Vous devez choisir au moins une base, une période et une caractérisation"));
                return;
            }
            showSpinner();
            new Request.JSON({
                'url': '/ajax/call/arkeogis/showthesheet',
                'onSuccess': function(res) {
                    hideSpinner();
                    if ((res.sites.length < res.total_count) && confirm(ch_t('arkeogis', "Seulement %d sites seront affiché sur %d au total. Souhaitez-vous plutôt télécharger la liste au format csv ?", res.sites.length, parseInt(res.total_count)))) {

                        // download as csv
                        window.location.href = '/export_sheet/' + encodeURIComponent(JSON.encode(form));
                    } else if (res.sites.length == 0) {
                        CaptainHook.Message.show(ch_t('arkeogis', 'Aucun résultat'));
                    } else {
                        show_menu(false);
                        display_sheet(res.sites);
                        $$('#map_sheet tr')
                            .addEvent('click', function(e, tr) {
                                var id = this.firstChild.get('html');
                                show_sheet(id);
                            });
                    }
                    display_query(form);
                }
            })
                .post(form);
        });



    /* initialization of buttons about query saving */
    populateSavedQueriesMenu();

    $('select-savedqueries')
        .addEvent('change', function(e) {
            new Request.JSON({
                'url': '/ajax/call/arkeogis/loadQuery',
                'onSuccess': function(res) {
                    res = JSON.decode(res);
                    var idx = $('select-savedqueries')
                        .selectedIndex;
                    if (idx == 0) return;
                    select_savedqueries_inhib_selection_event = true;
                    arkeo_menu.db.setSelection(res.db_include, res.db_exclude);
                    arkeo_menu.period.setSelection(res.period_include, res.period_exclude);
                    arkeo_menu.area.setSelection(res.area_include, res.area_exclude);
                    arkeo_menu.production.setSelection(res.production_include, res.production_exclude);
                    arkeo_menu.realestate.setSelection(res.realestate_include, res.realestate_exclude);
                    arkeo_menu.furniture.setSelection(res.furniture_include, res.furniture_exclude);
                    arkeo_menu.landscape.setSelection(res.landscape_include ? res.landscape_include : [],
                        res.landscape_exclude ? res.landscape_exclude : []);

                    arkeo_menu.centroid.setSelection(res.centroid_include, []);
                    arkeo_menu.knowledge.setSelection(res.knowledge_include, []);
                    arkeo_menu.occupation.setSelection(res.occupation_include, []);

                    $('ex_realestate')
                        .checked = res.realestate_exceptional == 1;
                    $('ex_furniture')
                        .checked = res.furniture_exceptional == 1;
                    $('ex_production')
                        .checked = res.production_exceptional == 1;
                    $('ex_landscape')
                        .checked = res.landscape_exceptional == 1;

                    $('caracterisation_mode')
                        .selectedIndex =
                        res.caracterisation_mode ? res.caracterisation_mode == 'OR' ? 0 : 1 : 0;

                    $('txtsearch')
                        .set('value', res.txtsearch);
                    arkeo_menu.txtsearch_options.setSelection(res.txtsearch_options_include ? res.txtsearch_options_include : [], []);

                    // display area selections
                    if (layer_selection_rect != null) {
                        map.removeLayer(layer_selection_rect);
                        layer_selection_rect = null;
                    }
                    if (layer_selection_circle != null) {
                        map.removeLayer(layer_selection_circle);
                        layer_selection_circle = null;
                    }
                    if (res.area_include && res.area_include.indexOf('circle') != -1) {
                        layer_selection_circle = new L.Circle([res.area_circle.lat, res.area_circle.lng], res.area_circle.radius, areaSelectionShapeOptions);
                        map.addLayer(layer_selection_circle);
                        layer_selection_circle.editing.enable();
                    }
                    if (res.area_include && res.area_include.indexOf('rect') != -1) {
                        var bounds = [[res.area_bounds._southWest.lat, res.area_bounds._southWest.lng], [res.area_bounds._northEast.lat, res.area_bounds._northEast.lng]];
                        layer_selection_rect = new L.Rectangle(bounds, areaSelectionShapeOptions);
                        map.addLayer(layer_selection_rect);
                        layer_selection_rect.editing.enable();
                    }
                    if (res.area_include && res.area_include.indexOf('all') != -1) {
                        //var bounds = [[res.area_map._southWest.lat, res.area_map._southWest.lng], [res.area_map._northEast.lat, res.area_map._northEast.lng]];
                        //map.fitBounds(bounds);
                        // we use the viewport set below
                    }

                    if (res.area_coords)
                        area_coords = res.area_coords;


                    // set map viewport
                    if (res.mapviewport.center)
                        map.setView(res.mapviewport.center, res.mapviewport.zoom);


                    setTimeout("select_savedqueries_inhib_selection_event=false", 500);
                    //$('select-savedqueries').selectedIndex=idx;
                }
            })
                .post({
                    'queryid': $('select-savedqueries')
                        .get('value')
                });
        });


    $$('.btn-reinit')[0].addEvent('click', function() {
        queryNum = 0;
        arkeo_query_displayed = 0;
        clearMarkers();
        $('select-savedqueries')
            .selectedIndex = 0;

        arkeo_menu.db.setSelection([], []);
        arkeo_menu.period.setSelection([], []);
        arkeo_menu.area.setSelection(['all'], []);
        arkeo_menu.production.setSelection([], []);
        arkeo_menu.realestate.setSelection([], []);
        arkeo_menu.furniture.setSelection([], []);
        arkeo_menu.landscape.setSelection([], []);

        arkeo_menu.centroid.setSelection([], []);
        arkeo_menu.knowledge.setSelection([], []);
        arkeo_menu.occupation.setSelection([], []);

        $('ex_realestate')
            .checked = false;
        $('ex_furniture')
            .checked = false;
        $('ex_production')
            .checked = false;
        $('ex_landscape')
            .checked = false;

        $('caracterisation_mode')
            .selectedIndex = 0;

        $('txtsearch')
            .set('value', '');
        arkeo_menu.txtsearch_options.setSelected('+', true);

        querys_tabs.tabs.each(function(tab) {
            querys_tabs.removeTab(tab);
        });

        // remove selections area
        if (layer_selection_rect != null) {
            map.removeLayer(layer_selection_rect);
            layer_selection_rect = null;
        }
        if (layer_selection_circle != null) {
            map.removeLayer(layer_selection_circle);
            layer_selection_circle = null;
        }

        // Remove control icons
        $$('.leaflet-control-hiddable')
            .forEach(function(el) {
                el.setStyle('display', 'none');
            });

    });

    /* initialize map */
    updateDrawLocales(L.drawLocal);
    layer_selection_rect = null;
    layer_selection_circle = null;
    area_coords = {
        'lat': 0.0,
        'lng': 0.0,
        'km': 0.0
    };

    map = new L.Map('map_canvas', {
        center: new L.LatLng(48.58476, 7.750576),
        zoom: 7,
        zoomControl: false
    });

    var cigalAttribution = '<a href="http://www.cigalsace.org" target="_blank">CIGAL</a>';

    layers.mapquest = new L.TileLayer('http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '<a href="http://www.mapquest.com">MapQuest</a>'
    });
    layers.osm = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '<a href="http://openstreetmap.org">OpenStreetMap</a>'
    });

    layers.cloudmade = L.tileLayer('http://{s}.tile.cloudmade.com/1fe47d515f2c4d0cafca5a67a0b1dc57/997/256/{z}/{x}/{y}.png', {
        attribution: 'Map data <a href="http://openstreetmap.org">OpenStreetMap</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>'
    });

    // n°4 BDZDH 2008 zones à dominante humide
    layers.cigal1 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_BD_ZDH_2008',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // ortho PIR 2011-12, orthophoto proche infrarouge
    layers.cigal2 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_OMBRAGE_COMPOSITE',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // ortho RVB, orthophoto vraies couleurs
    layers.cigal3 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_OMBRAGE_COMPOSITE_MNT',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // BDZDH 2007 au 50000
    layers.cigal4 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_BDOCSV22000_ALSACE_250000_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // BDZDH 2007 au 250000
    layers.cigal5 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_BDOCSV22000_ALSACE_50000_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // 42
    layers.cigal6 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_BDOCSV2202012_ALSACE_250000_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // 44
    layers.cigal7 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_BDOCSV2202012_ALSACE_50000_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // 46
    layers.cigal8 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_BdZDH2008_10000_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // 48
    layers.cigal9 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_BdZDH2008_250000_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // 50
    layers.cigal10 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_LignesFrontieres_250000_UTM32',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });
    // 52
    layers.cigal11 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_OMBRAGE_SRTM30_TIFLZW_WGS84',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 54
    layers.cigal12 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHOMNEOMB_2011_12_TIFJPEG_AL_C48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    //56
    layers.cigal13 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHOPIR_2011_12_ALS_ECW_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 58
    layers.cigal14 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHOPIR_2011_BR_ECW_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 60
    layers.cigal15 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHOPIR_2012_HR_ECW_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 62
    layers.cigal16 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHORVB_1997_ALSACE_TIF_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 64 
    layers.cigal17 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHORVB_1998_ALSACE_TIF_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 66
    layers.cigal18 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHORVB_2002_ALSACE_ECW_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 68
    layers.cigal19 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHORVB_2007_ALSACE_ECW_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 70
    layers.cigal20 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_ORTHORVB_2011_12_ALS_ECW_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 72
    layers.cigal21 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'CIGAL_SCAN25_2006_ALSACE_ECW_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 118
    layers.cigal22 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'IGN_bdTopo_chef_lieu',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 120
    layers.cigal23 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'IGN_bdTopo_chemin',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 138
    layers.cigal24 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'IGN_bdTopo_hydronyme',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 146
    layers.cigal25 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'IGN_bdTopo_ligne_orographique',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    // 148
    layers.cigal26 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/cigal/wms', {
        layers: 'IGN_bdTopo_oronyme',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true
    });

    layers.cg67 = L.tileLayer.wms('http://www.cigalsace.org/geoserver/CG67/wms', {
        layers: 'CG67_SCAN25_BR_2010_TIF_CC48',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true,
    });

    layers.ONF = L.tileLayer.wms('http://www.cigalsace.org/geoserver/ONF/wms', {
        layers: 'ONF_FORET_L93',
        format: 'image/png',
        attribution: cigalAttribution,
        transparent: true,
    });


    var allAttribution = '<a href="http://www.lubw.baden-wuerttemberg.de" target="_blank">RIPS-LUBW</a>';

    // LANDSAT 1975
    layers.all1 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000017900001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });

    // LANDSAT 1993
    layers.all2 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000013000001/MapServer/WMSServer', {
        format: 'image/png',
        layers: '0',
        attribution: allAttribution,
        transparent: true,
    });

    // LANDSAT 2000    
    layers.all3 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000018000001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });

    layers.all6 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000017400001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });

    layers.all7 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000016900001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });

    layers.all8 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000017300001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });
    
    layers.all9 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000017200001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });
    
    layers.all10 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000013500001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });
    
    layers.all11 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000013300001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });
    
    layers.all12 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000017100001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });
    
    layers.all13 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000013400001/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });
    
    layers.all15 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/badekarte_wms/MapServer/WMSServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });
    
    layers.all17 = L.tileLayer.wms('http://rips-gdi.lubw.baden-wuerttemberg.de/arcgis/services/wms/UIS_0100000001500001/MapServer', {
        layers: '0',
        format: 'image/png',
        attribution: allAttribution,
        transparent: true,
    });

    // Default layer
    layers.mapquest.addTo(map);

    // Layers control

    var wmsLayers;
    wmsLayers = {
            "FR-67 ORTHO RVB 1997-98": layers.cigal16,
            "FR-68 ORTHO RVB 1998": layers.cigal17,
            "FR-Alsace ORTHO RVB été 2002": layers.cigal18,
            "FR-Alsace ORTHO RVP 1998": layers.cigal19,
            "FR-Alsace ORTHO PIR 2012": layers.cigal20,
            "FR-67 ORTHO PIR 2011": layers.cigal14,
            "FR-68 ORTHO PIR 2011": layers.cigal15,
            "FR-Alsace SCAN 25 2006": layers.cigal21,
            "FR-Alsace SCAN 25 2010" : layers.cg67,
            "FR-Alsace ORTHO MNE ombragé 2011 2012": layers.cigal12,
            "FR-Alsace Ombragé composite MNT": layers.cigal2,
            "FR-Alsace Ombragé composite": layers.cigal3,
            "FR-Alsace BDZDH 2008 1/10000": layers.cigal1,
            "FR-Alsace BDOCS": layers.cigal5,
            "FR-Alsace Forêts publiques": layers.ONF,
            "DE LANDSAT 1975" : layers.all1,
            "DE LANDSAT 1993" : layers.all2,
            "DE LANDSAT 2000" : layers.all3,
            "DE Blattschnitt DGK5" : layers.all6,
            "DE Blattschnitt Flurkarte 1:1.500" : layers.all7,
            "DE Blattschnitt Flurkarte 1:2.500" : layers.all8,
            "DE Blattschnitt Orthophotos" : layers.all9,
            "DE Blattschnitt TK100" : layers.all10,
            "DE Blattschnitt TK25" : layers.all11,
            "DE Blattschnitt TK25 Quadrante" : layers.all12,
            "DE Blattschnitt TK50" : layers.all13,
            "DE EU-Badestellen in Baden-Württemberg" : layers.all15,
            "DE Fliessgewässer 1:10.000" : layers.all17,
        };

    layersControl = new L.control.layers({
        "MapQuest": layers.mapquest,
        "OpenStreetMap": layers.osm,
        "Google Sat": new L.Google(),
    }, wmsLayers , {
        collapsed: true
    });
    map.on('overlayadd', function(evt) {
        updateLabels();
    });
    layersControl.addTo(map);

    // Zoom control
    new L.Control.Zoom({
        position: 'topright'
    })
        .addTo(map);

    // Zoom to markers bounds control
    L.Control.ZoomMarkers = L.Control.extend({
        options: {
            position: 'topright',
        },

        onAdd: function(map) {
            var controlDiv = L.DomUtil.create('div', 'leaflet-control-custom leaflet-control-zoommarkers leaflet-control-hiddable');
            L.DomEvent
                .addListener(controlDiv, 'click', L.DomEvent.stopPropagation)
                .addListener(controlDiv, 'click', L.DomEvent.preventDefault)
                .addListener(controlDiv, 'click', function() {
                    map.fitBounds(getMarkersBounds());
                });

            var controlUI = L.DomUtil.create('div', 'leaflet-control-command-interior', controlDiv);
            controlUI.title = ch_t('arkeogis', 'Recadrer sur l\'emprise des icones');
            return controlDiv;
        }
    });

    new L.Control.ZoomMarkers({})
        .addTo(map);

    // Group control
    L.Control.GroupMarkers = L.Control.extend({
        options: {
            position: 'topright',
        },

        onAdd: function(map) {
            var controlDiv = L.DomUtil.create('div', 'leaflet-control-custom leaflet-control-groupmarkers leaflet-control-hiddable');
            L.DomEvent
                .addListener(controlDiv, 'click', L.DomEvent.stopPropagation)
                .addListener(controlDiv, 'click', L.DomEvent.preventDefault)
                .addListener(controlDiv, 'click', function() {
                    if (layerType == 'cluster') {
                        layerType = 'simple';
                        controlDiv.className = controlDiv.className.replace(' leaflet-control-active', '');
                    } else {
                        layerType = 'cluster';
                        L.DomUtil.addClass(controlDiv, 'leaflet-control-active');
                    }
                    redrawMarkers();
                });

            var controlUI = L.DomUtil.create('div', 'leaflet-control-command-interior', controlDiv);
            controlUI.title = ch_t('arkeogis', 'Recadrer sur l\'emprise des icones');
            return controlDiv;
        }
    });

    new L.Control.GroupMarkers({})
        .addTo(map);

    // Labels control
    L.Control.showLabels = L.Control.extend({
        options: {
            position: 'topright',
        },

        onAdd: function(map) {
            var controlDiv = L.DomUtil.create('div', 'leaflet-control-custom leaflet-control-showlabels leaflet-control-hiddable');
            L.DomEvent
                .addListener(controlDiv, 'click', L.DomEvent.stopPropagation)
                .addListener(controlDiv, 'click', L.DomEvent.preventDefault)
                .addListener(controlDiv, 'click', function() {
                    if (showLabels) {
                        showLabels = false;
                        controlDiv.className = controlDiv.className.replace(' leaflet-control-active', '');
                    } else {
                        showLabels = true;
                        L.DomUtil.addClass(controlDiv, 'leaflet-control-active');
                    }
                    redrawMarkers();
                });

            var controlUI = L.DomUtil.create('div', 'leaflet-control-command-interior', controlDiv);
            controlUI.title = ch_t('arkeogis', 'Recadrer sur l\'emprise des icones');
            return controlDiv;
        }
    });

    // Scale
    L.control.scale({
        width: 100,
        position: 'bottomright',
        imperial: false
    })
        .addTo(map);

    // Mouse position
    L.control.mousePosition({
        emptyString: ''
    })
        .addTo(map);

    new L.Control.showLabels({})
        .addTo(map);
    /* initialize draw for area selection */

    areaSelectionShapeOptions = {
        stroke: true,
        color: '#f06eaa',
        weight: 4,
        opacity: 0.5,
        fill: true,
        fillColor: null, //same as color by default
        fillOpacity: 0.2,
    };

    // Initialize the FeatureGroup to store editable layers
    var drawnItems = new L.FeatureGroup();
    map.addLayer(drawnItems);


    // Initialize the draw control and pass it the FeatureGroup of editable layers
    var drawControl = new L.Control.Draw({
        edit: {
            featureGroup: drawnItems
        }
    });
    //map.addControl(drawControl);

    map.on('draw:created', function(e) {
        var type = e.layerType,
            layer = e.layer;

        if (type == 'rectangle')
            layer_selection_rect = layer;
        else if (type == 'circle')
            layer_selection_circle = layer;

        drawnItems.addLayer(layer);
        layer.editing.enable();
        show_menu(true);
    });

    arkeo_menu.area.addEventOnLeafs('selection', function(ev) {
        if (select_savedqueries_inhib_selection_event) return;
        if (ev.value == 'rect') {
            if (layer_selection_rect != null) {
                map.removeLayer(layer_selection_rect);
                layer_selection_rect = null;
            }
            if (ev.selected == '+') {
                new L.Draw.Rectangle(map, areaSelectionShapeOptions)
                    .enable()
                ev.source.parent_menu.close();
                show_menu(false);
            }
        } else if (ev.value == 'circle') {
            if (layer_selection_circle != null) {
                map.removeLayer(layer_selection_circle);
                layer_selection_circle = null;
            }
            if (ev.selected == '+') {
                new L.Draw.Circle(map, areaSelectionShapeOptions)
                    .enable()
                ev.source.parent_menu.close();
                show_menu(false);
            }
        } else if (ev.value == 'coord') {
            if (ev.selected == '+') {
                ev.source.parent_menu.close();
                var html = $('win-coord')
                    .clone();
                html.setStyles({
                    display: ''
                });
                if (typeof(modalCoordsWin) == 'undefined')
                    modalCoordsWin = new Modal.Base(document.body, {
                        customclass: 'modal-coords'
                    });
                modalCoordsWin.setTitle(ch_t('arkeogis', "Coordonnées de sélection"));
                modalCoordsWin.setBody(html.innerHTML);
                modalCoordsWin.setFooter("<div><button onclick='setCoordsFromModal()'>Ok</button></div>");
                modalCoordsWin.show();
                $$('.modal-body .coord_lat [name=txtdec]')[0].value = area_coords.lat;
                $$('.modal-body .coord_lng [name=txtdec]')[0].value = area_coords.lng;
                $$('.modal-body [name=km]')[0].value = area_coords.km;
                decdms('coord_lat');
                decdms('coord_lng');
            }
        }
    });

    /* initialize tabbeds queries */
    querys_tabs = new UI.Tabs({
        container: 'querys',
        scrolling: 'auto',
        contextMenu: true,
        sortable: true
    });
    querys_tabs.addEvent('close', function(tab) {
        clearMarkers(tab.id.split('_')[1]);
    });


    /*
     * reset the selected saved query on query change
     */
    ['centroid', 'knowledge', 'occupation', 'db', 'period', 'area', 'production', 'realestate', 'furniture', 'landscape', 'txtsearch_options'].each(function(m) {
        arkeo_menu[m].addEventOnLeafs('selection', function() {
            if (!select_savedqueries_inhib_selection_event)
                $('select-savedqueries')
                    .selectedIndex = 0;
        })
    });
    ['ex_realestate', 'ex_furniture', 'ex_production', 'ex_landscape', 'caracterisation_mode', 'txtsearch'].each(function(m) {
        $(m)
            .addEvent('change', function() {
                if (!select_savedqueries_inhib_selection_event)
                    $('select-savedqueries')
                        .selectedIndex = 0;
            })
    });
    map.on('moveend', function() {
        if (!select_savedqueries_inhib_selection_event)
            $('select-savedqueries')
                .selectedIndex = 0;
    });

});

/* functions */


function buildSelectionObject() {
    var result = {};

    // get selections of plusminus menus

    result.db_include = arkeo_menu.db.getSelection('+');
    result.db_exclude = arkeo_menu.db.getSelection('-');
    result.period_include = arkeo_menu.period.getSelection('+');
    result.period_exclude = arkeo_menu.period.getSelection('-');
    result.area_include = arkeo_menu.area.getSelection('+');
    result.area_exclude = arkeo_menu.area.getSelection('-');
    result.production_include = arkeo_menu.production.getSelection('+');
    result.production_exclude = arkeo_menu.production.getSelection('-');
    result.realestate_include = arkeo_menu.realestate.getSelection('+');
    result.realestate_exclude = arkeo_menu.realestate.getSelection('-');
    result.furniture_include = arkeo_menu.furniture.getSelection('+');
    result.furniture_exclude = arkeo_menu.furniture.getSelection('-');
    result.landscape_include = arkeo_menu.landscape.getSelection('+');
    result.landscape_exclude = arkeo_menu.landscape.getSelection('-');


    // get selections of multiselect menus

    result.centroid_include = arkeo_menu.centroid.getSelection('+');
    result.knowledge_include = arkeo_menu.knowledge.getSelection('+');
    result.occupation_include = arkeo_menu.occupation.getSelection('+');
    result.centroid_exclude = arkeo_menu.centroid.getSelection('-');
    result.knowledge_exclude = arkeo_menu.knowledge.getSelection('-');
    result.occupation_exclude = arkeo_menu.occupation.getSelection('-');

    // get selections of exceptionals checkbox

    result.realestate_exceptional = $('ex_realestate')
        .checked ? 1 : 0;
    result.furniture_exceptional = $('ex_furniture')
        .checked ? 1 : 0;
    result.production_exceptional = $('ex_production')
        .checked ? 1 : 0;
    result.landscape_exceptional = $('ex_landscape')
        .checked ? 1 : 0;

    // get selection of caracterisation mode

    result.caracterisation_mode = $('caracterisation_mode')
        .get('value');

    // get selection of txtsearch
    result.txtsearch = $('txtsearch')
        .get('value');
    result.txtsearch_options_include = arkeo_menu.txtsearch_options.getSelection('+');
    result.txtsearch_options_exclude = arkeo_menu.txtsearch_options.getSelection('-');

    // get area selection
    result.area_map = map.getBounds();
    if (layer_selection_rect)
        result.area_bounds = layer_selection_rect.getBounds();
    else if (layer_selection_circle) {
        result.area_circle = layer_selection_circle.getLatLng();
        result.area_circle.radius = layer_selection_circle.getRadius();
    }
    result.area_coords = area_coords;

    // get map viewport
    result.mapviewport = {
        center: map.getCenter(),
        zoom: map.getZoom()
    }

    // get saved query
    var option = $('select-savedqueries')
        .getSelected();
    result.saved_query = {
        value: option.get('value')[0],
        index: $('select-savedqueries')
            .selectedIndex,
        name: option.get('text')[0]
    };

    return result;
}

function redrawMarkers() {
    for (var k in layerMarkers) {
        if (layerMarkers.hasOwnProperty(k)) {
            drawMarkers(k, true);
        }
    }
    updateControls();
}

function updateControls() {
    $$('.leaflet-control-hiddable')
        .forEach(function(el) {
            if (layerType == 'cluster' && el.hasClass('leaflet-control-showlabels')) {
                el.setStyle('display', 'none');
                el.removeClass('leaflet-control-active');
                showLabels = false;
            } else {
                el.setStyle('display', 'block');
            }
        });
}

function updateLabels() {
    if (!showLabels) return false;
    layerMarkers.forEach(function(l) {
        l.getLayers()
            .forEach(function(m) {
                m.showLabel();
            })
    });
}

function drawMarkers(queryNum, redraw) {

    var visible = true;

    if (redraw) {
        visible = (map.hasLayer(layerMarkers[queryNum])) ? true : false;
        layerMarkers[queryNum].clearLayers();
        map.removeLayer(layerMarkers[queryNum]);
        layersControl.removeLayer(layerMarkers[queryNum]);
    } else if (typeOf(layerMarkers[queryNum]) != 'array') {
        layerMarkers[queryNum] = [];
    }

    if (layerType == 'cluster') {
        layerMarkers[queryNum] = new L.markerClusterGroup({
            maxClusterRadius: 100
        });
    } else {
        layerMarkers[queryNum] = new L.FeatureGroup();
    }

    if (visible) {
        map.addLayer(layerMarkers[queryNum]);
    }

    mapMarkers[queryNum].each(function(marker) {
        if (marker.geometry) {
            var m = new L.marker([marker.geometry.coordinates[1], marker.geometry.coordinates[0]], {
                draggable: false
            });
            var icon = L.icon({
                iconUrl: marker.icon.iconUrl,
                iconSize: [marker.icon.iconSize[0], marker.icon.iconSize[1]],
                className: 'customIcon'
            });
            m.setIcon(icon);
            if (layerType != 'cluster') {
                m.bindLabel(marker.popup.title, {
                    noHide: true,
                    direction: 'auto'
                });
            }

            m.on('mouseover', function(evt) {
                new L.popup({
                    offset: new L.Point(0, -5),
                    closeOnClick: false,
                    maxWidth: 380
                })
                    .setLatLng([marker.geometry.coordinates[1], marker.geometry.coordinates[0]])
                    .setContent('<div style="width:500px">' + marker.popup.title + marker.popup.content + '</div>')
                    .openOn(map);
            })

            m.on('click', function(evt) {
                map.closePopup();
                show_sheet(marker.id);
            })

            layerMarkers[queryNum].addLayer(m);
            if (showLabels) {
                m.showLabel();
            }
        }
    });

    layersControl.addOverlay(layerMarkers[queryNum], ch_t('arkeogis', 'Requête') + ' ' + arkeo_query_displayed);

}

function updateDrawLocales(e) {
    for (k in e) {
        if (typeof(e[k]) == 'object')
            updateDrawLocales(e[k]);
        else if (typeof(e[k]) == 'string')
            e[k] = ch_t('arkeogis', e[k]);
    }
    /* trads:
   ch_t('arkeogis', "Click and drag to draw circle.");
   ch_t('arkeogis', "Click and drag to draw rectangle.");
   ch_t('arkeogis', "Release mouse to finish drawing.");
*/
}

function getMenuById(menu, id) {
    for (var i = 0; i < menu.length; i++) {
        if (menu[i].id == id) return menu[i];
    }
    return null;
}

function buildFilterLines(section, menu, colnum, div, query) {
    menu.each(function(model) {
        var table = new Element('table');
        table.inject(div);

        var tr = new Element('tr');
        tr.inject(table);

        var text = model.text;

        // name of db author
        if (section == 'db' && model.value) {
            var m = getMenuById(menus.db, model.value);
            if (m) text += ch_t('arkeogis', "(by %s)", m.full_name);
        }

        var td1 = new Element('td', {
            'class': 'td1',
            'text': text
        });
        td1.set('html', td1.get('html')
            .replace(/\n/g, '<br />'));
        td1.inject(tr);

        if (model.selection) {
            td1.addClass(model.selection == '+' ? 'filter-plus' : 'filter-minus');
        } else if (model.submenu) {
            var td2 = new Element('td', {
                'class': 'td2'
            });
            td2.inject(tr);
            buildFilterLines(section, model.submenu, colnum + 1, td2);
        }

        if (section == 'area') {
            if (model.value == 'circle') {
                var td2 = new Element('td', {
                    'class': 'td2'
                });
                td2.innerHTML = '<div>' + ch_t('arkeogis', "Latitude") + " : " + query.area_circle.lat + '</div>' + '<div>' + ch_t('arkeogis', "Longitude") + " : " + query.area_circle.lng + '</div>' + '<div>' + ch_t('arkeogis', "Distance") + " : " + (parseInt(query.area_circle.radius) / 1000) + ' km</div>';
                td2.inject(tr);
            }
            if (model.value == 'coord') {
                var td2 = new Element('td', {
                    'class': 'td2'
                });
                td2.innerHTML = '<div>' + ch_t('arkeogis', "Latitude") + " : " + query.area_coords.lat + '</div>' + '<div>' + ch_t('arkeogis', "Longitude") + " : " + query.area_coords.lng + '</div>' + '<div>' + ch_t('arkeogis', "Distance") + " : " + query.area_coords.km + ' km</div>';
                td2.inject(tr);
            }
            if (model.value == 'rect') {
                var td2 = new Element('td', {
                    'class': 'td2'
                });
                td2.innerHTML = '<div>' + ch_t('arkeogis', "Latitude") + " 1 : " + query.area_bounds._northEast.lat + '</div>' + '<div>' + ch_t('arkeogis', "Longitude") + " 1 : " + query.area_bounds._northEast.lng + '</div>' + '<div>' + ch_t('arkeogis', "Latitude") + " 2 : " + query.area_bounds._southWest.lat + '</div>' + '<div>' + ch_t('arkeogis', "Longitude") + " 2 : " + query.area_bounds._southWest.lng + '</div>';
                td2.inject(tr);
            }
            if (model.value == 'all') {
                var td2 = new Element('td', {
                    'class': 'td2'
                });
                td2.innerHTML = '<div>' + ch_t('arkeogis', "Latitude") + " 1 : " + query.area_map._northEast.lat + '</div>' + '<div>' + ch_t('arkeogis', "Longitude") + " 1 : " + query.area_map._northEast.lng + '</div>' + '<div>' + ch_t('arkeogis', "Latitude") + " 2 : " + query.area_map._southWest.lat + '</div>' + '<div>' + ch_t('arkeogis', "Longitude") + " 2 : " + query.area_map._southWest.lng + '</div>';
                td2.inject(tr);
            }
        }
    });
}

var arkeo_query_displayed = 0;

function display_query(query) {
    var tabname = 'unnamed';
    var html = $('query-display')
        .clone();
    html.setStyles({
        display: ''
    });

    tabname = ch_t('arkeogis', 'Query #%d', ++arkeo_query_displayed);
    ['centroid', 'knowledge', 'occupation', 'db', 'period', 'area', 'production', 'realestate', 'furniture', 'landscape', 'txtsearch_options'].each(function(m) {
        var result = [];
        var m_include = query[m + '_include'] ? query[m + '_include'] : [];
        var m_exclude = query[m + '_exclude'] ? query[m + '_exclude'] : [];
        if (arkeo_menu[m].submenu.buildPath(m_include, m_exclude, result)) {
            if (m == 'txtsearch_options' && !query.txtsearch) return;
            var queryfilter_html = $('query-filter')
                .clone();
            queryfilter_html.setStyles({
                display: ''
            });
            var title = m;
            if (m == 'production') title = ch_t('arkeogis', "Production");
            else if (m == 'realestate') title = ch_t('arkeogis', "Immobilier");
            else if (m == 'furniture') title = ch_t('arkeogis', "Mobilier");
            else if (m == 'landscape') title = ch_t('arkeogis', "Paysage");
            else if (m == 'centroid') title = ch_t('arkeogis', "Centroid");
            else if (m == 'knowledge') title = ch_t('arkeogis', "Connaissance");
            else if (m == 'occupation') title = ch_t('arkeogis', "Occupation");
            else if (m == 'db') title = ch_t('arkeogis', "Base de donnée");
            else if (m == 'period') title = ch_t('arkeogis', "Période");
            else if (m == 'area') title = ch_t('arkeogis', "Aire de recherche");
            else if (m == 'txtsearch_options') title = ch_t('arkeogis', 'Recherche "%s" dans', query.txtsearch);

            if (m == 'production' || m == 'realestate' || m == 'furniture' || m == 'landscape')
                if (query[m + '_exceptional'] == 1) title += ' ' + ch_t('arkeogis', '(exceptionals only)');
            queryfilter_html.getElement('div.filtername span')
                .set('text', title);

            div = new Element('div', {
                'class': 'filtercontent'
            });
            buildFilterLines(m, result, 0, div, query);
            div.inject(queryfilter_html);
            queryfilter_html.inject(html.getElement('.query-filters'));
        }
    });

    if (query.saved_query.value > 0) {
        tabname += ' (' + query.saved_query.name + ')';
        html.getElement('.input-save-query')
            .set('value', query.saved_query.name);
        html.getElement('.input-save-query')
            .set('disabled', true);
        html.getElement('.btn-delete-query')
            .setStyle('display', '');
    } else {
        html.getElement('.btn-save-query')
            .setStyle('display', '');
    }

    html.getElement('.btn-delete-query')
        .addEvent('click', function() {
            var option = $('select-savedqueries')
                .getSelected();
            if (!confirm(ch_t('arkeogis', "Souhaitez-vous vraiment effacer la requête '%s' ?", query.saved_query.name))) return;
            new Request.JSON({
                'url': '/ajax/call/arkeogis/deleteQuery',
                'onSuccess': function(res) {
                    populateSavedQueriesMenu();
                    if (res == 'ok') {
                        CaptainHook.Message.show(ch_t('arkeogis', "Requête '%s' effacée", query.saved_query.name));
                        html.getElement('.input-save-query')
                            .set('disabled', false);
                        html.getElement('.btn-delete-query')
                            .setStyle('display', 'none');
                        html.getElement('.btn-save-query')
                            .setStyle('display', '');
                    } else alert('problem');
                    return;
                }
            })
                .post({
                    'queryid': query.saved_query.value
                });
        });

    html.getElement('.btn-save-query')
        .addEvent('click', function() {
            if (!html.getElement('.input-save-query')
                .get('value')
                .trim())
                return alert(ch_t('arkeogis', "Donnez un nom à votre requête."));
            new Request.JSON({
                'url': '/ajax/call/arkeogis/saveQuery',
                'onSuccess': function(res) {
                    populateSavedQueriesMenu();
                    if (res == 'ok') {
                        CaptainHook.Message.show(ch_t('arkeogis', "Requête enregistrée"));
                        html.getElement('.input-save-query')
                            .set('disabled', true);
                        html.getElement('.btn-delete-query')
                            .setStyle('display', '');
                        html.getElement('.btn-save-query')
                            .setStyle('display', 'none');
                    } else if (res == 'duplicate')
                        alert(ch_t('arkeogis', "Une requête '%s' existe déjà sous ce nom",
                            html.getElement('.input-save-query')
                            .get('value')));
                    else alert('problem');
                }
            })
                .post({
                    'name': html.getElement('.input-save-query')
                        .get('value'),
                    'query': JSON.encode(query)
                });
        });

    html.getElement('.btn-print')
        .addEvent('click', function() {
            var win = window.open('/print_sheet#' + encodeURI(JSON.encode(query)), 'sheet print');
        });

    html.getElement('.btn-export')
        .addEvent('click', function() {
            window.location.href = '/export_sheet/' + encodeURIComponent(JSON.encode(query));
        });


    querys_tabs.addTab({
        id: 't_' + arkeo_query_displayed,
        label: tabname,
        content: html,
        closable: true,
        sortable: true
    });

    //html.inject($('querys'));
}

function populateSavedQueriesMenu() {
    new Request.JSON({
        'url': '/ajax/call/arkeogis/listQueries',
        'onSuccess': function(res) {
            var sel = $('select-savedqueries');
            var id = sel.getSelected()
                .get('value');
            sel.set('html', '');
            sel.adopt(new Element('option', {
                'value': '0',
                'text': ch_t('arkeogis', "Requêtes archivées")
            }));
            /*Array.push(sel.options, (new Element('option', {
		'value': '0',
		'text': ch_t('arkeogis', "Requêtes archivées")
	    })));*/
            var index = 1;
            res.each(function(line) {
                sel.adopt(new Element('option', {
                    'value': line.id,
                    'text': line.name
                }));
                /*Array.push(sel.options, (new Element('option', {
		    'value': line.id,
		    'text': line.name
		})));*/
                if (typeOf(line) != undefined && line.id == id) {
                    sel.selectedIndex = index;
                }
                index++;
            });
        }
    })
        .get();
}

var menu_showing = true;

function show_menu(show) {
    menu_showing = show;
    if (menu_showing) {
        $$('div[id=onglet] i', document.body)[0].removeClass('icon-chevron-right')
            .addClass('icon-chevron-left');
        $('onglet')
            .setStyle('left', '');
        $('map_menu')
            .setStyle('display', '');
    } else {
        $$('div[id=onglet] i', document.body)[0].removeClass('icon-chevron-left')
            .addClass('icon-chevron-right');
        $('onglet')
            .setStyle('left', 0);
        $('map_menu')
            .setStyle('display', 'none');
    }
}


function clearMarkers(num) {
    if (!num) {
        layerMarkers.each(function(l) {
            map.removeLayer(l);
            layersControl.removeLayer(l);
        });
    } else {
        map.removeLayer(layerMarkers[num]);
        layersControl.removeLayer(layerMarkers[num]);
    }
}

function showSpinner() {
    $('arkeospinner')
        .setStyle('display', 'block');
}

function hideSpinner() {
    $('arkeospinner')
        .setStyle('display', 'none');
}


function dmsdec(section) {
    var degres = 0;
    var minutes = 0;
    var seconds = 0;

    car = $$('.modal-body .' + section + ' [name=txtdeg]')[0].value;
    car = car.replace(/-/g, "");
    car = $$('.modal-body .' + section + ' [name=txtdeg]')[0].value = car;

    degres = parseInt($$('.modal-body .' + section + ' [name=txtdeg]')[0].value * 1.0);
    minutes = parseInt($$('.modal-body .' + section + ' [name=txtmin]')[0].value * 1.0);
    secondes = parseFloat($$('.modal-body .' + section + ' [name=txtsec]')[0].value * 1.0);

    var orientation = $$('.modal-body .' + section + ' [name=orientation]')[0].value;
    if (orientation == 'N' || orientation == 'E')
        orientation = 1;
    else
        orientation = -1;
    var calcul = degres + (minutes * (1.0 / 60.0)) + (secondes * (1.0 / 3600.0));
    $$('.modal-body .' + section + ' [name=txtdec]')[0].value = calcul * orientation;
}

function decdms(section) {
    var degres = 0;
    var degresTemp = 0.0;
    var minutes = 0;
    var minutesTemp = 0.0;
    var secondes = 0;
    var secondesTemp = 0.0;

    var txtdec = parseFloat($$('.modal-body .' + section + ' [name=txtdec]')[0].value * 1.0);

    if (txtdec < 0) {
        degresTemp = txtdec * -1.0;
        $$('.modal-body .' + section + ' [name=orientation]')[0].value = (section == 'coord_lat' ? 'S' : 'W');
    } else {
        degresTemp = txtdec;
        $$('.modal-body .' + section + ' [name=orientation]')[0].value = (section == 'coord_lat' ? 'N' : 'E');
    }

    degres = Math.floor(degresTemp);
    minutesTemp = degresTemp - degres;
    minutesTemp = 60.0 * minutesTemp;
    minutes = Math.floor(minutesTemp);
    secondesTemp = minutesTemp - minutes;
    secondesTemp = 60.0 * secondesTemp;
    secondes = Math.round(secondesTemp * 1000) / 1000;

    if (txtdec == 'NaN') {
        degres = '0';
        minutes = '0';
        secondes = '0';
    }

    $$('.modal-body .' + section + ' [name=txtdeg]')[0].value = degres;
    $$('.modal-body .' + section + ' [name=txtmin]')[0].value = minutes;
    $$('.modal-body .' + section + ' [name=txtsec]')[0].value = secondes;
}

function setCoordsFromModal() {
    var lat = parseFloat($$('.modal-body .coord_lat [name=txtdec]')[0].value * 1.0);
    var lng = parseFloat($$('.modal-body .coord_lng [name=txtdec]')[0].value * 1.0);
    var km = parseFloat($$('.modal-body .coord_lng [name=km]')[0].value * 1.0);

    area_coords = {
        'lat': lat,
        'lng': lng,
        'km': km
    };

    setTimeout("modalCoordsWin.setBody('')", 500);
    modalCoordsWin.hide();
}

function getMarkersBounds() {
    var bounds = new L.LatLngBounds();
    layerMarkers.forEach(function(l) {
        bounds.extend(l.getBounds());
    });
    return bounds;
}