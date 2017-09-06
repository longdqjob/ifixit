<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>

<script>

    function updateLayOut() {
        Ext.getCmp("sidelefttree").updateLayout();
        console.log(Ext.getCmp('sidelefttree').getWidth());
        console.log(Ext.getCmp('navigation').getWidth());
        Ext.getCmp('sidelefttree').setHeight($(window).height() - 142);
        Ext.getCmp('gridId').setHeight($(window).height() - 106);
        Ext.getCmp('gridId').setWidth($(window).width());

        Ext.getCmp("gridId").updateLayout();
    }
    Ext.onReady(function () {
        Ext.create('Ext.container.Viewport', {
            id: "viewport",
            layout: 'border',
            renderTo: Ext.getBody(),
            margin: '10 10 10 10',
            padding: '55 0 0 0',
            items: [{
                    region: 'west',
                    id: "navigation",
                    collapsible: true,
                    title: 'Navigation',
                    width: 350,
                    html: ' <div id="tree"></div>  ',
                    listeners: {
                        collapse: function () {
                            console.log("-----collapse:--");
                            this.up().doLayout();
//                            updateLayOut();
                        },
                        expand: function () {
                            console.log("-----expand:--");
                            this.up().doLayout();
//                            updateLayOut();
                        }
                    }
                }, {
                    region: 'center',
                    html: '<div id="rightPanel"></div>' //rightPanel
                }],
            listeners: {
                resize: function (width, height, oldWidth, oldHeight, eOpts) {
                    setTimeout(function () {
                        updateLayOut();
                    }, 1);
                },
            },
        });

        tree.render('tree');
        loadMachine(1);
        gridPanel.render('rightPanel');
    });//end of OnReady furnciotn

</script>