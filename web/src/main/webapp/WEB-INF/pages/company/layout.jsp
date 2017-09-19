<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    Ext.onReady(function () {
        Ext.QuickTips.init();

        // NOTE: This is an example showing simple state management. During development,
        // it is generally best to disable state management as dynamically-generated ids
        // can change across page loads, leading to unpredictable results.  The developer
        // should ensure that stable state ids are set for stateful components in real apps.
        Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));

        var viewport = Ext.create('Ext.Viewport', {
            id: 'viewport',
            layout: 'border',
            padding: '50 0 0 0',
            items: [{
                    xtype: 'panel',
                    region: 'west',
                    id: "westSide",
                    iconCls: 'navpn',
                    stateId: 'navigation-panel',
                    title: '<fmt:message key="company"/>',
                    split: true,
                    width: 350,
                    minWidth: 350,
                    maxWidth: 350,
                    collapsible: true,
                    animCollapse: true,
                    margin: '0 0 0 0',
                    layout: 'accordion',
                    items: [{
                            contentEl: 'west',
                            id: "westPn",
                            html: ' <div id="tree"></div>',
                            margin: '0 0 0 -5',
                        },
//                        {
//                            title: 'Settings',
//                            html: '<p>Some settings in here.</p>',
//                            iconCls: 'settings'
//                        }, {
//                            title: 'Information',
//                            html: '<p>Some info in here.</p>',
//                            iconCls: 'info'
//                        }
                    ],
                    listeners: {
                        collapse: function () {
                            updateLayOut();
                        },
                        expand: function () {
                            updateLayOut();
                        }
                    }
                },
                {
                    region: 'center',
                    html: '<div id="searchDiv"></div><div id="gridDiv" style="margin-top: 10px;"></div>'
                }
                // in this instance the TabPanel is not wrapped by another panel
                // since no title is needed, this Panel is added directly
                // as a Container
//                Ext.create('Ext.tab.Panel', {
//                    region: 'center', // a center region is ALWAYS required for border layout
//                    deferredRender: false,
//                    activeTab: 0, // first tab initially active
//                    id: "tabCenter",
//                    items: [{
//                            contentEl: 'center1',
//                            closable: false,
//                            autoScroll: true
//                        }]
//                })
            ],
            listeners: {
                resize: function (width, height, oldWidth, oldHeight, eOpts) {
                    setTimeout(function () {
                        updateLayOut();
                    }, 1);
                },
            },
        });
        Ext.getCmp("westPn").getHeader().hide();
//        Ext.getCmp("westPn").getHeader().destroy();
        tree.render('tree');
        search.render('searchDiv');
        gridPanel.render('gridDiv');
    });

</script>