<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    Ext.override(Ext.LoadMask, {
        onComponentAdded: function (owner) {
            var me = this;
            delete me.activeOwner;
            me.floatParent = owner;
            if (!owner.floating) {
                owner = owner.up('[floating]');
            }
            if (owner) {
                me.activeOwner = owner;
                me.mon(owner, 'move', me.sizeMask, me);
            } else {
                me.preventBringToFront = true;
            }
            owner = me.floatParent.ownerCt;
            if (me.rendered && me.isVisible() && owner) {
                me.floatOwner = owner;
                me.mon(owner, 'afterlayout', me.sizeMask, me, {single: true});
            }
        }
    });

    var maxSpecification = 40;
    Ext.onReady(function () {
        //        myMask = new Ext.LoadMask({
        //            msg: "Please wait...",
        //            target: Ext.getBody()
//        });

//        var myPanel = new Ext.panel.Panel({
        //            renderTo: document.body,
        //            height: 100,
//            width: 200,
        //            title: 'Foo'
//        });
//
        //        var myMask = new Ext.LoadMask({
        //            msg: 'Please wait...',
        //            target: myPanel
//        });
        // //        myMask.show();
    });

    var showMask;
    function maskTarget(target, message) {
        if (message) {
            showMask = new Ext.LoadMask({
                msg: message,
                target: target
            });
        } else {
            showMask = new Ext.LoadMask({
                msg: '<fmt:message key="loading"/>',
                target: target
            });
        }
        showMask.show();
    }

    function unMaskTarget() {
        if (showMask) {
            showMask.hide();
        }
    }


    function mask(message) {
        if (message) {
            Ext.getBody().mask(message);
        } else {
            Ext.getBody().mask('<fmt:message key="loading"/>');
        }
    }
    function unmask() {
        Ext.getBody().unmask();
    }

    function trimTextInForm(form) {
        Ext.ComponentQuery.query('[xtype=textfield]', form).forEach(function (entry) {
            entry.addListener({blur: function () {
                    this.setValue(this.getValue().trim());
                }});
        });
    }

    function alertError(msgr) {
        var messagebox = Ext.MessageBox.show({
            title: 'Error',
            msg: msgr,
            buttons: Ext.MessageBox.OK,
            icon: Ext.Msg.ERROR
        });

        Ext.Function.defer(function () {
            messagebox.zIndexManager.bringToFront(messagebox);
        }, 100);
        return;
    }

    function alertSystemError() {
        alertError('<fmt:message key="systemError"/>');
    }

    function alertInfo(msgr) {
        var messagebox = Ext.MessageBox.show({
            title: 'Information',
            msg: msgr, buttons: Ext.MessageBox.OK,
            icon: Ext.Msg.INFO});

        Ext.Function.defer(function () {
            messagebox.zIndexManager.bringToFront(messagebox);
        }, 100);
        return;
    }
    function alertSuccess(msgr) {
        var messagebox = Ext.MessageBox.show({
            title: 'Success', msg: msgr,
            buttons: Ext.MessageBox.OK,
            icon: 'success-icon',
        });
        Ext.Function.defer(function () {
            messagebox.zIndexManager.bringToFront(messagebox);
        }, 100);
        return;
    }
    function alertWarning(msgr) {
        var messagebox = Ext.MessageBox.show({
            title: 'Warning',
            msg: msgr,
            buttons: Ext.MessageBox.OK,
            icon: Ext.Msg.WARNING
        });
        Ext.Function.defer(function () {
            messagebox.zIndexManager.bringToFront(messagebox);
        }, 100);
        return;
    }
    function alertConfirm(msgr, callback) {
        var messagebox = Ext.Msg.confirm("Confirmation", msgr, callback);
        Ext.Function.defer(function () {
            messagebox.zIndexManager.bringToFront(messagebox);
        }, 100);
    }

    function isFunction(functionToCheck) {
        var getType = {};
        return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    }

    function setReadOnlyForAll(form, bReadOnly, sfieldIdex) {
        if (sfieldIdex) {
            sfieldIdex = "," + sfieldIdex + ",";
            form.getForm().getFields().each(function (field) {
                if (!sfieldIdex.indexOf("," + field.getId() + ",") >= 0) {
                    field.setReadOnly(bReadOnly);
                }
            });
        } else {
            form.getForm().getFields().each(function (field) {
                field.setReadOnly(bReadOnly);
            });
        }
    }


    var urlLogin = "http://localhost:8080/login";
    function redirectIfNotAuthen(response) {
        if (response.status == 401) {
            window.location.replace(urlLogin);
        }
    }

    function storeRedirectIfNotAuthen(operation) {
        if (operation.error && operation.error.status && operation.error.status == 401) {
            window.location.replace(urlLogin);
        }
    }
    function treeRedirectIfNotAuthen(options) {
        if (options.error && options.error.status && options.error.status == 401) {
            window.location.replace(urlLogin);
        }
    }

    function eleWithRequired(ele, show) {
        if (show) {
            ele.allowBlank = false;
            ele.show();
        } else {
            ele.allowBlank = true;
            ele.hide();
        }
    }

    function hasUnicode(str) {
        for (var i = 0; i < str.length; i++) {
            if (str.charCodeAt(i) > 127)
                return true;
        }
        return false;
    }
</script>