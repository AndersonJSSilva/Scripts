# chart typed: Pie or Bar
Function Create-Chart() {
	
	Param(
	    [String]$ChartType,
		[String]$ChartTitle,
	    [String]$FileName,
		[String]$XAxisName,
	    [String]$YAxisName,
		[Int]$ChartWidth,
		[Int]$ChartHeight,
		[String[]]$NameArray, #Added by MVD
		[Int[]]$ValueArray #Added by MVD
	)
		
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
	
	Write-Host "          " Creating chart...
	
	#Create our chart object 
	$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
	$Chart.Width = $ChartWidth
	$Chart.Height = $ChartHeight
	$Chart.Left = 10
	$Chart.Top = 10

	#Create a chartarea to draw on and add this to the chart 
	$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
	$Chart.ChartAreas.Add($ChartArea) 
	[void]$Chart.Series.Add("Data") 

	$Chart.ChartAreas[0].AxisX.Interval = "1" #Set this to 1 (default is auto) and allows all X Axis values to display correctly
	$Chart.ChartAreas[0].AxisX.IsLabelAutoFit = $false;
	$Chart.ChartAreas[0].AxisX.LabelStyle.Angle = "-45"
	
	#Add the Actual Data to our Chart
	$Chart.Series["Data"].Points.DataBindXY($NameArray, $ValueArray) #Modified by MVD

	if (($ChartType -eq "Pie") -or ($ChartType -eq "pie")) {
		$ChartArea.AxisX.Title = $XAxisName
		$ChartArea.AxisY.Title = $YAxisName
		$Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie
		$Chart.Series["Data"]["PieLabelStyle"] = "Outside" 
		$Chart.Series["Data"]["PieLineColor"] = "Black" 
		$Chart.Series["Data"]["PieDrawingStyle"] = "Concave" 
		#($Chart.Series["Data"].Points.FindMaxByValue())["Exploded"] = $true
		$Chart.Series["Data"].Label = "#VALX = #VALY\n" # Give an X & Y Label to the data in the plot area (useful for Pie graph) 
		#(Display both axis labels, use: Y = #VALY\nX = #VALX)
	}
	
	elseif (($ChartType -eq "Bar") -or ($ChartType -eq "bar")) {
		#$Chart.Series["Data"].Sort([System.Windows.Forms.DataVisualization.Charting.PointSortOrder]::Descending, "Y")
		$ChartArea.AxisX.Title = $XAxisName
		$ChartArea.AxisY.Title = $YAxisName
		# Find point with max/min values and change their colour
		$maxValuePoint = $Chart.Series["Data"].Points.FindMaxByValue()
		$maxValuePoint.Color = [System.Drawing.Color]::Red
		$minValuePoint = $Chart.Series["Data"].Points.FindMinByValue()
		$minValuePoint.Color = [System.Drawing.Color]::Green
		# make bars into 3d cylinders
		$Chart.Series["Data"]["DrawingStyle"] = "Cylinder"
		$Chart.Series["Data"].Label = "#VALY" # Give a Y Label to the data in the plot area (useful for Bar graph)
	}
	
	else {
		Write-Host "No Chart Type was defined. Try again and enter either Pie or Bar for the ChartType Parameter. " `
					"The chart will be created as a standard Bar Graph Chart for now." -ForegroundColor Cyan
	}

	#Set the title of the Chart to the current date and time 
	$Title = new-object System.Windows.Forms.DataVisualization.Charting.Title 
	$Chart.Titles.Add($Title) 
	$Chart.Titles[0].Text = $ChartTitle

	#Save the chart to a file
	$FullPath = ((Get-Location).Path + "\" + $FileName + ".png")
	$Chart.SaveImage($FullPath,"png")
	#Write-Host "Chart saved to $FullPath" -ForegroundColor Green

	return $FullPath

}
Function Open-image($file){
[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

#$file = (get-item 'C:\Users\Public\Pictures\Sample Pictures\Chrysanthemum.jpg')
#$file = (get-item "c:\image.jpg")

$img = [System.Drawing.Image]::Fromfile($file);

# This tip from http://stackoverflow.com/questions/3358372/windows-forms-look-different-in-powershell-and-powershell-ise-why/3359274#3359274
[System.Windows.Forms.Application]::EnableVisualStyles();
$form = new-object Windows.Forms.Form
$form.Text = "Image Viewer"
$form.Width = $img.Size.Width;
$form.Height =  $img.Size.Height;
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width =  $img.Size.Width;
$pictureBox.Height =  $img.Size.Height;

$pictureBox.Image = $img;
$form.controls.add($pictureBox)
$form.Add_Shown( { $form.Activate() } )
$form.ShowDialog()
#$form.Show();
}


$query = "*datacenter*"

$result = $saida | ?{$_.displayname -like $query} | Group-Object displayname 
$result =  Get-ADComputer -Filter {OperatingSystem -like "*"} -Properties operatingsystem -SearchBase "OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root" | Group-Object OperatingSystem



$arrayname =$arrayvalue =@()
foreach($value in $result)
{
    $arrayname += $value.name
    $arrayvalue += $value.count
}

$file = Create-Chart -ChartType bar -ChartTitle "Gráfico" -FileName "Chart_file" -ChartWidth 650 -ChartHeight 400 -NameArray $arrayname -ValueArray $arrayvalue
Open-image -file $file