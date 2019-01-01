angular.module('igadmin', [])
  .controller('ScoreCard', [function() {
    var self = this;
    var res = rs;

    self.risks = [];
    var getColour = function(score) {
	    return score < 8 ? 'green' : score > 14 ? 'red' : 'yellow';
    };

    if (res.length > 0 ) {
        for (row in res) {
	    var suffix = self.risks.length + 1;
	    self.risks.push({
	  	name : 'risk' + suffix,
	  	rating : {name : 'rating' + suffix, value : res[row].rating},
		likely : {name : 'likely' + suffix, value : res[row].likelihood},
		category : {name : 'category' + suffix, value : res[row].risk_category},
		score : res[row].score,
		col : getColour( res[row].score)
		});
	    console.log(suffix + ") Added a row: " + res[row]);
	};
    } else {
        self.risks = [{ 
	  name : 'risk1',
	  rating : {name : 'rating1', value : ''}, 
	  likely : {name : 'likely1', value : ''},
	  category : {name : 'category1', value : ''},
	  score : ''
        }];
    };
  }
]).config(['$httpProvider', function($httpProvider) {
 $httpProvider.interceptors.push('noCacheInterceptor');
}]).factory('noCacheInterceptor', function () {
            return {
                request: function (config) {
                    console.log(config.method);
                    console.log(config.url);
                    if(config.method=='GET'){
                        var separator = config.url.indexOf('?') === -1 ? '?' : '&';
                        config.url = config.url+separator+'noCache=' + new Date().getTime();
                    }
                    console.log(config.method);
                    console.log(config.url);
                    return config;
               }
           };
  });
