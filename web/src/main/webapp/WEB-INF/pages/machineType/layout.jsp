<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>

<script>
    Ext.onReady(function () {
        Ext.QuickTips.init();
        Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));
        var viewport = Ext.create('Ext.Viewport', {
            id: 'viewport',
            layout: 'border',
            padding: '55 0 50 0',
            items: [{
                    region: 'center',
                    html: '<div id="searchDiv"></div><div id="gridDiv"  style="margin-top: 10px;"></div>'
                }],
            listeners: {
                resize: function (width, height, oldWidth, oldHeight, eOpts) {
                    setTimeout(function () {
                        updateLayOut();
                    }, 1);
                },
            },
        });

        search.render('searchDiv');
        gridPanel.render('gridDiv');
    });

</script>