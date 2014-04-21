app.views.Article = Backbone.View.extend({
        el: $("body"),
        initialize: function () {
            console.log("init:articleview");
            this.friends = new Friends({ view: this });
        },
        events: {
            "click #add-friend":  "showPrompt",
            "click .delete":  "delete_li"
        },
        delete_li: function(e) {
            $(e.currentTarget).parent().remove();
        },
        showPrompt: function () {
            var username = $("input[name=username]").val() || "";
            this.friend_model = new Friend({'name': username});
            this.friends.add(this.friend_model);
        },
        addFriendList: function (model) {
            $("#friends-list").append("<li style='margin-top:5px;'>Friend name: " + model.get('name') + " <button class='btn btn-danger delete'>Delete Friend</button></li>");
        }
    });