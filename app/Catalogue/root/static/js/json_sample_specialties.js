google.charts.setOnLoadCallback(specDashboard);

function specDashboard() {
	var specDashboard = new google.visualization.Dashboard(
	    document.getElementById('spec_dashboard_div'));
	var spec_data = google.visualization.arrayToDataTable(sampleSpecFact.specialties);

	var specTypeFilter = new google.visualization.ControlWrapper({
	  'controlType': 'CategoryFilter',
	  'containerId': 'spec_filter_div',
	  'options' : {
	    'filterColumnLabel': 'Specialty',
	  }
	});
	var specPieChart = new google.visualization.ChartWrapper({
	  'chartType': 'PieChart',
	  'containerId': 'spec_piechart_div',
	  'options': {
            'is3D': false,
	    'pieSliceText': 'percentage',
	    'legend': 'none'
	  }, 'view' : {'columns' : [0,1]}
	});

	var specTableChart = new google.visualization.ChartWrapper({
	  'chartType': 'Table',
	  'containerId': 'spec_tablechart_div',
	  'options': {
	  }, 'view' : {'columns' : [0, 1]}
	});

	specDashboard.bind(specTypeFilter, [specPieChart, specTableChart] );

	specDashboard.draw(spec_data);

}
