<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
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
//
//        myMask.show();
    });

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
            entry.addListener({
                blur: function () {
                    this.setValue(this.getValue().trim());
                }
            });
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
            msg: msgr,
            buttons: Ext.MessageBox.OK,
            icon: Ext.Msg.INFO
        });

        Ext.Function.defer(function () {
            messagebox.zIndexManager.bringToFront(messagebox);
        }, 100);
        return;
    }
    function alertSuccess(msgr) {
        var messagebox = Ext.MessageBox.show({
            title: 'Success',
            msg: msgr,
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
</script>