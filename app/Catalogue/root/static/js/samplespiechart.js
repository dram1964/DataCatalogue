google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawSamplesPieChart);

function drawSamplesPieChart() {

var data = google.visualization.arrayToDataTable(samplePie.ranges);

var options = {
  title: samplePie.myTitle
};

var chart = new google.visualization.PieChart(document.getElementById(samplePie.id));

chart.draw(data, options);
}
