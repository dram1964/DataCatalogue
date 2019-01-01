google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawPopulationPieChart);

function drawPopulationPieChart() {

var data = google.visualization.arrayToDataTable(populationPie.ranges);

var options = {
  title: populationPie.myTitle
};

var chart = new google.visualization.PieChart(document.getElementById(populationPie.id));

chart.draw(data, options);
}
