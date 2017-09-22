<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var searchUsermame = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="user.username"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        labelStyle: 'padding-left: 20px;'
    });

    var searchName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="user.name"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        labelStyle: 'padding-left: 20px;'
    });


    var search = new Ext.create('Ext.form.Panel', {
        xtype: 'form-hboxlayout',
        title: '<fmt:message key="button.search"/>' + " " + '<fmt:message key="user"/>',
        collapsible: true,
        collapsed: true,
        id: 'searchform',
        defaults: {
            border: false,
            flex: 0.2,
            layout: 'anchor'
        },
        layout: 'hbox',
        items: [searchUsermame, searchName],
        buttons: [{
                text: '<fmt:message key="button.search"/>',
                type: 'submit',
                handler: function () {
                    searchUser();
                }
            }, {
                text: '<fmt:message key="button.reset"/>',
                handler: function () {
                    search.reset();
                    searchUser();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        searchUser();
                    }
                });
            },
            'collapse': function (p, eOpts) {
                updateLayOut();
            },
            'expand': function (p, eOpts) {
                updateLayOut();
            }
        } //end of listeners
    });

</script>