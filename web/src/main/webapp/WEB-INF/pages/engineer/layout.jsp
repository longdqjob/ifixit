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
            padding: '55 0 50 0',
            items: [{
                    region: 'west',
                    id: "westSide",
                    iconCls: 'navpn',
                    stateId: 'navigation-panel',
                    title: '<fmt:message key="grpEngineer"/>',
                    split: true,
                    width: 400,
                    minWidth: 175,
                    maxWidth: 400,
                    collapsible: true,
                    animCollapse: true,
                    margins: '0 0 0 5',
                    layout: 'accordion',
                    items: [{
                            contentEl: 'west',
                            id: "westPn",
//                            title: '<fmt:message key="grpEngineer"/>',
                            html: ' <div id="tree"></div>',
                        }],
                    listeners: {
                        resize: function (tree, width, height, oldWidth, oldHeight, eOpts) {
                            setTimeout(function () {
                                updateLayOut();
                            }, 1);
                        },
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
                    console.log("--resize:---");
                    setTimeout(function () {
                        updateLayOut();
                    }, 1);
                },
            },
        });
        tree.render('tree');
        Ext.getCmp("westPn").getHeader().hide();
        search.render('searchDiv');
        gridPanel.render('gridDiv');
    });

</script>