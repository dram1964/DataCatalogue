google.charts.load('current', {'packages':['corechart', 'controls']});
google.charts.setOnLoadCallback(drawPopulationBarChart);

function drawPopulationBarChart() {

var data = google.visualization.arrayToDataTable(populationBar.ranges);

var options = {
  title: populationBar.myTitle
};

var chart = new google.visualization.ColumnChart(document.getElementById(populationBar.id));

chart.draw(data, options);
}
