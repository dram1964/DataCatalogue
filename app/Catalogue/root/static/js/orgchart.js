google.charts.setOnLoadCallback(orgChart);

function orgChart() {
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Name');
  data.addColumn('string', 'Parent');
  data.addColumn('string', 'ToolTip');
  
  data.addRows(orgchart.tree);

  var chart = new google.visualization.OrgChart(document.getElementById('org_chart'));
  chart.draw(data);
}
