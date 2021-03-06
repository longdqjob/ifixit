<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>

<script>
    Ext.onReady(function () {
        Ext.QuickTips.init();

        // NOTE: This is an example showing simple state management. During development,
        // it is generally best to disable state management as dynamically-generated ids
        // can change across page loads, leading to unpredictable results.  The developer
        // should ensure that stable state ids are set for stateful components in real apps.
        Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));

        function updateLayOut() {
            Ext.getCmp('gridId').setWidth(Ext.getCmp("tabCenter").getWidth());
            Ext.getCmp('gridId').setHeight(Ext.getCmp("tabCenter").getHeight() - 50);
            Ext.getCmp("gridId").updateLayout();
        }

        var viewport = Ext.create('Ext.Viewport', {
            id: 'border-example',
            layout: 'border',
            padding: '55 0 50 0',
            items: [{
                    xtype: 'tabpanel',
                    region: 'east',
                    title: 'East Side',
                    dockedItems: [{
                            dock: 'top',
                            xtype: 'toolbar',
                            items: ['->', {
                                    xtype: 'button',
                                    text: 'test',
                                    tooltip: 'Test Button'
                                }]
                        }],
                    animCollapse: true,
                    collapsible: true,
                    split: true,
                    width: 225, // give east and west regions a width
                    minSize: 175,
                    maxSize: 400,
                    margins: '0 5 0 0',
                    activeTab: 1,
                    tabPosition: 'bottom',
                    items: [{
                            html: '<p>A TabPanel component can be a region.</p>',
                            title: 'A Tab',
                            autoScroll: true
                        }, Ext.create('Ext.grid.PropertyGrid', {
                            title: 'Property Grid',
                            closable: true,
                            source: {
                                "(name)": "Properties Grid",
                                "grouping": false,
                                "autoFitColumns": true,
                                "productionQuality": false,
                                "created": Ext.Date.parse('10/15/2006', 'm/d/Y'),
                                "tested": false,
                                "version": 0.01,
                                "borderWidth": 1
                            }
                        })],
                    listeners: {
                        collapse: function () {
                            console.log("-----collapse:--");
                            updateLayOut();
                        },
                        expand: function () {
                            console.log("-----expand:--");
                            updateLayOut();
                        }
                    }
                }, {
                    region: 'west',
                    stateId: 'navigation-panel',
                    id: 'west-panel', // see Ext.getCmp() below
                    title: 'West',
                    split: true,
                    width: 200,
                    minWidth: 175,
                    maxWidth: 400,
                    collapsible: true,
                    animCollapse: true,
                    margins: '0 0 0 5',
                    layout: 'accordion',
                    items: [{
                            contentEl: 'west',
                            title: 'Navigation',
                            html: ' <div id="tree"></div>',
                            iconCls: 'navpn' // see the HEAD section for style used
                        }, {
                            title: 'Settings',
                            html: '<p>Some settings in here.</p>',
                            iconCls: 'settings'
                        }, {
                            title: 'Information',
                            html: '<p>Some info in here.</p>',
                            iconCls: 'info'
                        }],
                    listeners: {
                        collapse: function () {
                            console.log("-----collapse:--");
                            updateLayOut();
                        },
                        expand: function () {
                            console.log("-----expand:--");
                            updateLayOut();
                        }
                    }
                },
                // in this instance the TabPanel is not wrapped by another panel
                // since no title is needed, this Panel is added directly
                // as a Container
                Ext.create('Ext.tab.Panel', {
                    region: 'center', // a center region is ALWAYS required for border layout
                    deferredRender: false,
                    activeTab: 0, // first tab initially active
                    id: "tabCenter",
                    items: [{
                            contentEl: 'center1',
                            title: 'Close Me',
                            closable: true,
                            autoScroll: true
                        }, {
                            contentEl: 'center2',
                            title: 'Center Panel',
                            autoScroll: true
                        }]
                })],
            listeners: {
                resize: function (width, height, oldWidth, oldHeight, eOpts) {
                    setTimeout(function () {
                        updateLayOut();
                    }, 1);
                },
            },
        });
        // get a reference to the HTML element with id "hideit" and add a click listener to it
        Ext.get("hideit").on('click', function () {
            // get a reference to the Panel that was created with id = 'west-panel'
            var w = Ext.getCmp('west-panel');
            // expand or collapse that Panel based on its collapsed property state
            w.collapsed ? w.expand() : w.collapse();
        });
        tree.render('tree');
        gridPanel.render('center1');
    });

</script>