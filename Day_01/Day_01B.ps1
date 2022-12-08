
$input = get-content C:\Scripts\AOC2022\Input_D1.txt
#$input.count

$list = @()
$max = 0
$runningtotal = 0
foreach($line in $input){
    if($line -eq ""){
        $list += $runningtotal
        $runningtotal = 0
        }
        Else{
            $runningtotal += $line
            }
    }

Write-host "Top 3:"
$list | sort -Descending |select -First 3

Write-host "Answer:"
$sum = 0
$list | sort -Descending |select -First 3|% {$sum += $_}
$sum
