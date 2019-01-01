google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawTptPieChart);

function drawTptPieChart() {
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Range');
  data.addColumn('number', 'Population');
  data.addRows(tptPie.ranges);
  var options = {
    title: tptPie.myTitle
  };
  var chart = new google.visualization.PieChart(document.getElementById(tptPie.id));

  function selectHandler() {
    var selectedItem = chart.getSelection()[0];
    if (selectedItem) {
      var range = data.getValue(selectedItem.row, 0);
      alert('The user selected ' + range);
    }
  }
  
  google.visualization.events.addListener(chart, 'select', selectHandler);
  chart.draw(data, options);
}
