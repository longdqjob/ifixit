<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var searchCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="material.code"/>',
        name: 'code',
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
        fieldLabel: '<fmt:message key="material.name"/>',
        name: 'name',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        labelStyle: 'padding-left: 20px;'
    });


    var search = new Ext.create('Ext.form.Panel', {
        xtype: 'form-hboxlayout',
        id: "searchform",
        title: '<fmt:message key="button.search"/>',
        collapsible: true,
        collapsed: true,
        defaults: {
            border: false,
            flex: 0.2,
            layout: 'anchor'
        },
        layout: 'hbox',
        items: [searchCode, searchName],
        buttons: [{
                text: '<fmt:message key="button.search"/>',
                type: 'submit',
                handler: function () {
                    loadMaterial(0);
                }
            }, {
                text: '<fmt:message key="button.reset"/>',
                handler: function () {
                    search.reset();
                    loadMaterial(0);
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        loadMaterial(0);
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