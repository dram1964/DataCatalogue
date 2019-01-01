google.charts.load('current', {'packages':['bar']});
google.charts.setOnLoadCallback(drawSamplesBarChart);

function drawSamplesBarChart() {

var data = google.visualization.arrayToDataTable(samplePie.ranges);

var options = {
  title: samplePie.myTitle
};

var chart = new google.visualization.ColumnChart(document.getElementById(samplePie.id));

chart.draw(data, options);
}
