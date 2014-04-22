Friend = Backbone.Model.extend({
        name: null
    });


Friends = Backbone.Collection.extend({
        initialize: function (options) {
            this.bind("add", options.view.addFriendList);
        }
    });