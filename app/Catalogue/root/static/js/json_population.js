google.charts.setOnLoadCallback(drawPopulationBarChart);

function drawPopulationBarChart() {

    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Age Range');
    data.addColumn('number', 'Population');
    data.addRows(fact.ranges);

    var view = new google.visualization.DataView(data);
    view.setColumns([0, 1]);

    var options = {
      title: populationTitle
    };

    var tableOptions = {
      title: populationTitle,
      width: '100%',
      height: '100%',
    };

    var table = new google.visualization.Table(document.getElementById('table_chart_div'));
    table.draw(view, tableOptions);

    var chart = new google.visualization.ColumnChart(document.getElementById('population_column_chart_div'));
    chart.draw(view, options);

   google.visualization.events.addListener(table, 'sort', 
     function(event) {
       data.sort([{column: event.column, desc: !event.ascending}]);
       chart.draw(view, options);
     });
}
