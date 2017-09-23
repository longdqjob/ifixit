<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function editUser(data) {
        console.log(data);
        userForm.reset();
        if (data) {
            userWindow.setTitle('<fmt:message key="user.edit"/>');
            userId.setValue(data.get("id"));
            userUserName.setValue(data.get("username"));
            userName.setValue(data.get("fullName"));
            userEmail.setValue(data.get("email"));
            userSystemId.setValue(data.get("systemId"));
            userSystemName.setValue(data.get("systemName"));
            userEngneerId.setValue(data.get("grpEngineerId"));
            userEngneerName.setValue(data.get("grpEngineerName"));
            userPassHint.setValue(data.get("passwordHint"));
            userLstRole.setValue(data.get("lstRole"));
        } else {
            userWindow.setTitle('<fmt:message key="user.add"/>');
        }

        userWindow.show();
    }

    function deleteUser(arrayList) {
        maskTarget(gridUser);
        Ext.Ajax.request({
            url: '../user/delete?' + arrayList,
            method: "POST",
            timeout: 10000,
            success: function (result, request) {
                unMaskTarget();
                jsonData = Ext.decode(result.responseText);
                if (jsonData.success == true) {
                    alertSuccess(jsonData.message);
                    searchUser();
                } else {
                    if (jsonData.message) {
                        alertError(jsonData.message);
                    } else {
                        alertSystemError();
                    }
                }
            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
                unMaskTarget();
                alertSystemError();
            }
        });
    }
    function saveUser() {
        var valid = userForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        if (hasUnicode(userUserName.getValue())) {
            userUserName.setActiveError('<fmt:message key="notUnicode"/>');
            alertError('<fmt:message key="notUnicode"/>');
            return false;
        }

        mask();
        Ext.Ajax.request({
            url: "/user/save",
            method: "POST",
            params: {
                id: userId.getValue(),
                username: userUserName.getValue(),
                name: userName.getValue(),
                email: userEmail.getValue(),
                systemId: userSystemId.getValue(),
                engineerId: userEngneerId.getValue(),
                password: userPass.getValue(),
                passwordHint: userPassHint.getValue(),
                lstRole: userLstRole.getValue(),
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                if ("usernameExits" == res.success) {
                    alertError(res.message);
                    userUserName.setActiveError(res.message);
                } else if ("userSystemRequired" == res.success) {
                    alertError(res.message);
                    userSystemName.setActiveError(res.message);
                } else if ("userEngRequired" == res.success) {
                    alertError(res.message);
                    userEngneerName.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    alertSuccess(res.message);
                    userWindow.hide();
                    searchUser();
                } else {
                    if (res.message) {
                        alertError(res.message);
                    } else {
                        alertSystemError();
                    }
                }
            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
                alertSystemError();
                unmask();
            },
        });
    }

    function choosegrpEngineer(record) {
        userEngneerId.setValue(record.get("id"));
        userEngneerName.setValue(record.get("name"));
    }
    function chooseCompany(record) {
        userSystemId.setValue(record.get("id"));
        userSystemName.setValue(record.get("name"));
    }
    
    function createDockedItems(fieldId) {
        return [{
            xtype: 'toolbar',
            dock: 'top',
            items: {
                text: 'Options',
                menu: [{
                    text: 'Get value',
                    handler: function(){
                        var value = Ext.getCmp(fieldId).getValue();
                        Ext.Msg.alert('Value is a split array', value.join(', '));
                    } 
                }, {
                    text: 'Set value (2,3)',
                    handler: function(){
                        Ext.getCmp(fieldId).setValue(['2', '3']);
                    }
                },{
                    text: 'Toggle enabled',
                    checked: true,
                    checkHandler: function(item, checked){
                        Ext.getCmp(fieldId).setDisabled(!checked);
                    }
                },{
                    text: 'Toggle delimiter',
                    checked: true,
                    checkHandler: function(item, checked) {
                        var field = Ext.getCmp(fieldId);
                        if (checked) {
                            field.delimiter = ',';
                            Ext.Msg.alert('Delimiter Changed', 'The delimiter is now set to <b>","</b>. Click Save to ' +
                                          'see that values are now submitted as a single parameter separated by the delimiter.');
                        } else {
                            field.delimiter = null;
                            Ext.Msg.alert('Delimiter Changed', 'The delimiter is now set to <b>null</b>. Click Save to ' +
                                          'see that values are now submitted as separate parameters.');
                        }
                    }
                }]
            }
        }, {
            xtype: 'toolbar',
            dock: 'bottom',
            ui: 'footer',
            defaults: {
                minWidth: 75
            },
            items: ['->', {
                text: 'Clear',
                handler: function(){
                    var field = Ext.getCmp(fieldId);
                    if (!field.disabled) {
                        field.clearValue();
                    }
                }
            }, {
                text: 'Reset',
                handler: function() {
                    Ext.getCmp(fieldId).up('form').getForm().reset();
                }
            }, {
                text: 'Save',
                handler: function(){
                    var form = Ext.getCmp(fieldId).up('form').getForm();
                    form.getValues(true);
                    if (form.isValid()){
                        Ext.Msg.alert('Submitted Values', 'The following will be sent to the server: <br />'+
                            form.getValues(true));
                    }
                }
            }]
        }];
    }
</script>