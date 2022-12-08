
$input = get-content C:\Scripts\AOC2022\Input_D1.txt
$input.count

$max = 0
$runningtotal = 0
foreach($line in $input){
    if($line -eq ""){
        If($runningtotal -gt $max){
            $max = $runningtotal
            $runningtotal = 0
            }
            Else{
            $runningtotal = 0
            }
        }
        Else{
            $runningtotal += $line
            }
    }
Write-host ("Max: {0}" -f $max)

