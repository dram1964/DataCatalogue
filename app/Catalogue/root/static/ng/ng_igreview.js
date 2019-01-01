angular.module('igadmin', [])
  .controller('ScoreCard', [function() {
    var self = this;
    var res = rs;

    self.risks = [];

    var getColour = function(score) {
	    return score < 8 ? 'green' : score > 14 ? 'red' : 'yellow';
    }

    self.addRisk = function() {
	var suffix = self.risks.length + 1;
	self.risks.push({
	name : 'risk' + suffix,
	rating : {name : 'rating' + suffix, value : ''},
	likely : {name : 'likely' + suffix, value : ''},
	category : {name : 'category' + suffix, value : ''} 
	});
    };
    self.updateScore = function(risk) {
	    risk.score = risk.rating.value * risk.likely.value;
	    //risk.col = risk.score < 8 ? 'green' : risk.score > 14 ? 'red' : 'yellow';
	    risk.col = getColour(risk.score);
    };

    if (res.length > 0 ) {
        for (row in res) {
	    var suffix = self.risks.length + 1;
	    //row.col = res[row].score < 8 ? 'green' : res[row].score > 14 ? 'red' : 'yellow';
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
])
  .controller('Handling', [function() {
    var self = this;
    self.edit = 0;
    self.score = self.rating * self.likely;

    self.addScores = function() {
	self.edit = self.edit == 1 ? 0 : 1;
    };
    self.updateScore = function() {
	if (self.rating >= 1 && self.likely >= 1) {
	    self.score = self.rating * self.likely;
	}
    };
  }
]);
