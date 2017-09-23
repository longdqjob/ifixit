<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    Ext.onReady(function () {
        Ext.QuickTips.init();
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
                    title: '<fmt:message key="company"/>',
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
            ],
            listeners: {
                resize: function (width, height, oldWidth, oldHeight, eOpts) {
                    setTimeout(function () {
                        updateLayOut();
                    }, 1);
                },
            },
        });
        treeSystem.render('tree');
        Ext.getCmp("westPn").getHeader().hide();
        search.render('searchDiv');
        gridUsePanel.render('gridDiv');
    });

</script>