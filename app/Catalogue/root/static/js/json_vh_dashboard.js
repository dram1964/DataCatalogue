google.charts.setOnLoadCallback(vhDashboard);

function vhDashboard() {
	var data = google.visualization.arrayToDataTable( vhData.dashboard);

	var dashboard = new google.visualization.Dashboard(
	    document.getElementById('dashboard_div'));

	var virusFilter = new google.visualization.ControlWrapper({
	  'controlType': 'CategoryFilter',
	  'containerId': 'virus_filter_div',
	  'options' : {
	    'filterColumnLabel': 'Virus',
	  }
	});

	var genderFilter = new google.visualization.ControlWrapper({
	  'controlType': 'CategoryFilter',
	  'containerId': 'gender_filter_div',
	  'options' : {
	    'filterColumnLabel': 'Gender'
	  }
	});

	var pieChart = new google.visualization.ChartWrapper({
	  'chartType': 'PieChart',
	  'containerId': 'piechart_div',
	  'options': {
            'is3D': true,
	    'pieSliceText': 'percentage',
	    'legend': 'none'
	  }, 'view' : {'columns' : [0,2]}
	});

	var tableChart = new google.visualization.ChartWrapper({
	  'chartType': 'Table',
	  'containerId': 'tablechart_div',
	  'options': {
	  }, 'view' : {'columns' : [0, 1, 2]}
	});

	dashboard.bind([virusFilter, genderFilter], 
		[pieChart, tableChart] );

	dashboard.draw(data);
}

