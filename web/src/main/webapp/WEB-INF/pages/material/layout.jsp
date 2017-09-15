<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>
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
                    stateId: 'navigation-panel',
                   // title: 'System',
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
                            title: '<fmt:message key="itemType"/>',
                            html: ' <div id="tree"></div>',
                            iconCls: 'navpn',
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
                            console.log("-----collapse:--");
                            updateLayOut();
                        },
                        expand: function () {
                            console.log("-----expand:--");
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
        tree.render('tree');
        search.render('searchDiv');
        gridPanel.render('gridDiv');
    });

</script>