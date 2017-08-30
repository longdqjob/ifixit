<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>

<script>
    var search = new Ext.create('Ext.form.Panel', {
        xtype: 'form-hboxlayout',
        title: 'Search',
        collapsible: true,
        id: 'searchform',
        fullscreen: true,
        padding: '5 5 5 5',
        fieldDefaults: {
            labelAlign: 'top',
            msgTarget: 'side'
        },
        defaults: {
            border: false,
            xtype: 'panel',
            flex: 1,
            layout: 'anchor'
        },
        layout: 'hbox',
        items: [{
                items: [{
                        xtype: 'textfield',
                        fieldLabel: 'First Name',
                        anchor: '-5',
                        name: 'first'
                    }, {
                        xtype: 'textfield',
                        fieldLabel: 'Company',
                        anchor: '-5',
                        name: 'company'
                    }]
            }, {
                items: [{
                        xtype: 'textfield',
                        fieldLabel: 'Last Name',
                        anchor: '100%',
                        name: 'last'
                    }, {
                        xtype: 'textfield',
                        fieldLabel: 'Email',
                        anchor: '100%',
                        name: 'email',
                        vtype: 'email'
                    }]
            }],
        buttons: ['->', {
                text: 'Search'
            }, {
                text: 'Cancel'
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        searchServer();
                    }
                });
            },
//            'collapse': function (p, eOpts) {            
//                Ext.getCmp("searchform").updateLayout();
//                Ext.getCmp("gridId").setHeight(Ext.getCmp("rightPanel").getHeight() - Ext.getCmp("searchform").getHeight());
//                Ext.getCmp("gridId").updateLayout();
//            },
//            'expand': function (p, eOpts) {
//                Ext.getCmp("searchform").updateLayout();
//                Ext.getCmp("gridId").setHeight(Ext.getCmp("rightPanel").getHeight() - Ext.getCmp("searchform").getHeight());
//                Ext.getCmp("gridId").updateLayout();
//            }
        } //end of listeners
    });

</script>