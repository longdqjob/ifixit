<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>

<script>
    Ext.onReady(function () {
        Ext.create('Ext.container.Viewport', {
            layout: 'border',
            renderTo: Ext.getBody(),
            items: [{
                    region: 'west',
                    collapsible: true,
                    title: 'Navigation',
                    padding: '55 0 0 0',
                    width: 350,
                    html: ' <div id="tree"></div>  ',
                    listeners: {
                        collapse: function () {
//                            Ext.getCmp("tabid").updateLayout();
//                            Ext.getCmp("gridId").updateLayout();
//                            Ext.getCmp("searchform").updateLayout();
                        },
                        expand: function () {
//                            Ext.getCmp("tabid").updateLayout();
//                            Ext.getCmp("gridId").updateLayout();
//                            Ext.getCmp("searchform").updateLayout();
                        }
                    }
                }, {
                    region: 'center',
                    html: '<div id="rightPanel"></div>' //rightPanel
                }],
            listeners: {
                resize: function (width, height, oldWidth, oldHeight, eOpts) {
                    setTimeout(function () {
//                        Ext.getCmp('tabid').setHeight($(window).height());
//                        Ext.getCmp('gridId').setHeight($(window).height() - 142 - search.getHeight());
                        Ext.getCmp('sidelefttree').setHeight($(window).height() - 142);

//                        Ext.getCmp("tabid").updateLayout();
//                        Ext.getCmp("gridId").updateLayout();
//                        Ext.getCmp("searchform").updateLayout();

                    }, 1);
                },
            },
        });
        
        tree.render('tree');
//        search.render('searchPanel');
    });//end of OnReady furnciotn

</script>