<!DOCTYPE html>
<meta charset="utf-8">
<style>
	.state{
		fill: none;
		stroke: #a9a9a9;
		stroke-width: 1;
	}
	.state:hover{
		fill-opacity:0.5;
	}
	#tooltip {   
		position: absolute;           
		text-align: center;
		padding: 20px;             
		margin: 10px;
		font: 12px sans-serif;        
		background: lightsteelblue;   
		border: 1px;      
		border-radius: 2px;           
		pointer-events: none;         
	}
	#tooltip h4{
		margin:0;
		font-size:14px;
	}
	#tooltip{
		background:rgba(0,0,0,0.9);
		border:1px solid grey;
		border-radius:5px;
		font-size:12px;
		width:auto;
		padding:4px;
		color:white;
		opacity:0;
	}
	#tooltip table{
		table-layout:fixed;
	}
	#tooltip tr td{
		padding:0;
		margin:0;
	}
	#tooltip tr td:nth-child(1){
		width:50px;
	}
	#tooltip tr td:nth-child(2){
		text-align:center;
	}
</style>
<body>
<div id="tooltip"></div><!-- div to hold tooltip. -->
<svg width="960" height="600" id="statesvg"></svg> <!-- svg to hold the map. -->
<script src="uStates.js"></script> <!-- creates uStates. -->
<script src="http://d3js.org/d3.v3.min.js"></script>
<script>

	function tooltipHtml(n, d){	/* function to create html content string in tooltip div. */
		return "<h4>"+n+"</h4><table>"+
			"<tr><td>Low</td><td>"+(d.low)+"</td></tr>"+
			"<tr><td>Average</td><td>"+(d.avg)+"</td></tr>"+
			"<tr><td>High</td><td>"+(d.high)+"</td></tr>"+
			"</table>";
	}
	
	var sampleData ={};	/* Sample random data. */	
	["HI", "AK", "FL", "SC", "GA", "AL", "NC", "TN", "RI", "CT", "MA",
	"ME", "NH", "VT", "NY", "NJ", "PA", "DE", "MD", "WV", "KY", "OH", 
	"MI", "WY", "MT", "ID", "WA", "DC", "TX", "CA", "AZ", "NV", "UT", 
	"CO", "NM", "OR", "ND", "SD", "NE", "IA", "MS", "IN", "IL", "MN", 
	"WI", "MO", "AR", "OK", "KS", "LS", "VA"]
		.forEach(function(d){ 
			var low=Math.round(100*Math.random()), 
				mid=Math.round(100*Math.random()), 
				high=Math.round(100*Math.random());
			sampleData[d]={low:d3.min([low,mid,high]), high:d3.max([low,mid,high]), 
					avg:Math.round((low+mid+high)/3), color:d3.interpolate("#ffffcc", "#800026")(low/100)}; 
		});
	
	/* draw states on id #statesvg */	
	uStates.draw("#statesvg", sampleData, tooltipHtml);
	
	d3.select(self.frameElement).style("height", "600px"); 
</script>

</body>