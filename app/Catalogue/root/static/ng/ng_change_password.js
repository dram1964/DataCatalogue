angular.module('password', [])
  .controller('MainCtrl', [function() {
        var self = this;
        self.submit = function() {
          console.log('User clicked submit with ',
            self.username, self.password);
        };
        self.checkPassword = function() {
            return self.password1 == self.password2 ? 0 : 1;
        };
  }]);
