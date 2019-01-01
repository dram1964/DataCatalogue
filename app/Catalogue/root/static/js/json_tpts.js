google.charts.setOnLoadCallback(tptDashboard);

function tptDashboard() {
	var tptDashboard = new google.visualization.Dashboard(
	    document.getElementById('tpt_dashboard_div'));
	var tpt_data = google.visualization.arrayToDataTable(tptFact.ranges);

	var tptTypeFilter = new google.visualization.ControlWrapper({
	  'controlType': 'CategoryFilter',
	  'containerId': 'tpt_filter_div',
	  'options' : {
	    'filterColumnLabel': 'Range',
	  }
	});
	var tptPieChart = new google.visualization.ChartWrapper({
	  'chartType': 'PieChart',
	  'containerId': 'tpt_piechart_div',
	  'options': {
            'is3D': false,
	    'pieSliceText': 'percentage',
	    'legend': 'none'
	  }, 'view' : {'columns' : [0,1]}
	});

	var tptTableChart = new google.visualization.ChartWrapper({
	  'chartType': 'Table',
	  'containerId': 'tpt_tablechart_div',
	  'options': {
	  }, 'view' : {'columns' : [0, 1]}
	});

	tptDashboard.bind(tptTypeFilter, [tptPieChart, tptTableChart] );

	tptDashboard.draw(tpt_data);

}
