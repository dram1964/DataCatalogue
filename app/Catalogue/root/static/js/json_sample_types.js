google.charts.setOnLoadCallback(typeDashboard);

function typeDashboard() {
	var typeDashboard = new google.visualization.Dashboard(
	    document.getElementById('type_dashboard_div'));
	var typeData = google.visualization.arrayToDataTable(sampleTypeFact.types);

	var typeFilter = new google.visualization.ControlWrapper({
	  'controlType': 'CategoryFilter',
	  'containerId': 'type_filter_div',
	  'options' : {
	    'filterColumnLabel': 'Sample Type',
	  }
	});
	var typePieChart = new google.visualization.ChartWrapper({
	  'chartType': 'PieChart',
	  'containerId': 'type_piechart_div',
	  'options': {
            'is3D': false,
	    'pieSliceText': 'percentage',
	    'legend': 'none'
	  }, 'view' : {'columns' : [0,1]}
	});

	var typeTableChart = new google.visualization.ChartWrapper({
	  'chartType': 'Table',
	  'containerId': 'type_tablechart_div',
	  'options': {
	  }, 'view' : {'columns' : [0, 1]}
	});

	typeDashboard.bind(typeFilter, [typePieChart, typeTableChart] );

	typeDashboard.draw(typeData);

}
