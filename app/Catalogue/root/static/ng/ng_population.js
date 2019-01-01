angular.module('datasetsApp', [])
    .controller('MainCtrl', [function() {
	var self = this;
	self.fact = populationData;
    }]);
