Function D15{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $A,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $B,

        [switch]$OutputSensors,
        [Switch]$OutputCuriousSensors 

    )
    Begin{

        switch ($PsCmdlet.ParameterSetName) {
            A {
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_15\Input_test.txt
                $targetline = 10
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_15\Input.txt
                $targetline = 2000000
            }
            Default {}
        }

        $sensors = @()
        $index = 0
        foreach($line in $data){
            #Write-Verbose ("{0}" -f $line)
            #$line = $data[0]
            #write-verbose ("{0}" -f $line)
            $tar = $line.split("=")
            $sx = $tar[1].substring(0,$tar[1].indexof(","))
            $sy = $tar[2].substring(0,$tar[2].indexof(":"))
            $bx = $tar[3].substring(0,$tar[3].indexof(","))
            $by = $tar[4]
            $scoord = ("{0},{1}" -f $sx,$sy)
            $bcoord = ("{0},{1}" -f $bx,$by)
            $d = Get-Distance -coordA $scoord -coordB $bcoord
            #Write-Verbose ("({0},{1}) to ({2},{3}) D = {4}" -f $sx,$sy,$bx,$by,$d)
            #Write-Verbose ("{0} to {1} D: {2}" -f $scoord,$bcoord,$d)
            $Sensors += [PSCustomObject]@{
                Index = $index
                coord = $scoord
                beacon = $bcoord
                X = $sx
                Y = $sy
                D = $d
            }
            $index++
        }
        
        if($OutputSensors){ $sensors}
        
        $index = 0
        $sets = @()
        foreach($sensor in $sensors){
            #$sensor = $sensors[0]
            $intersectioncoord = ("{0},{1}" -f $sensor.X,$targetline)
            $dtoline = Get-Distance -coordA $sensor.coord -coordB $intersectioncoord
            $isinreach = $sensor.D -ge $dtoline
            if($isinreach){$rangeonline = $sensor.d - $dtoline}else{$rangeonline = ""}

            #Write-Verbose ("[Sensor {0}] ({1}) Range:{2}" -f $index,$sensor.coord,$sensor.D)
            #write-verbose ("  Dist to target line: {0} Sensor Reach: {1}" -f $dtoline,$sensor.D)
            #write-verbose ("    -Taret line is in range of sensor {0}" -f $isinreach)
            
            if($isinreach){
                $startx = ([int]$sensor.x - [int]$rangeonline)
                $finishx = ([int]$sensor.x + [int]$rangeonline)
                #Write-Verbose ("     - Range on the target line: {0}" -f $rangeonline)
                #write-verbose ("        {0} - {1} = {2}" -f $sensor.x, $rangeonline, $startx)
                #write-verbose ("        {0} + {1} = {2}" -f $sensor.x, $rangeonline, $finishx)
                #Write-Verbose ("        {0} to {1}" -f $startx,$finishx)
                #($startx)..($finishx)|%{$set += ("{0},{1}" -f $_,$targetline)}
                $sets += ("{0},{1}" -f $startx, $finishx)
            }



            $index++
        }
        #count number of beacons on the line 
        $beaconsonline = @()
        foreach($sensor in $sensors){
            if($sensor.beacon.split(",")[1] -eq $targetline){
                $beaconsonline += $sensor.beacon}
            }
        $beaconsonline = ($beaconsonline|select -Unique).count
        #Write-Verbose ("Need to remove {0} beacons that are on the target line" -f $beaconsonline)
        
        $Merged = Merge-Ranges -SetsofRanges $sets
        #$solutionPartOne = $sets |select -Unique
        #Write-host ("Solution Part One: {0}" -f $solutionPartOne.count)
        $solution = 0
        foreach($range in $Merged){
            $dx = $range.Finish - $range.Start + 1 
            $Solution += $dx
        }
        $solution = $solution - $beaconsonline
        Write-Host ("Solution to Part One: {0}" -f $solution)
        #$Merged
    
        #Part two
        Write-Verbose ("")
        Write-verbose ("")
        if($true){
        $curiousSensors = @()
        for($i = 0;$i -lt $sensors.count;$i++){
            for($j = $i + 1; $j -lt $sensors.count; $j++){
                #Write-verbose("Sensor {0} and Sensor {1}" -f $i, $j)
                #if(($sensor[$i].D + $sensor[$j].d + 2) -eq (Get-Distance -coordA $sensor[$i].coord -coordB $sensor[$j].coord)){
                #    $curiousSensors += {$sensor[$i]} 
                $distbetween = Get-Distance -coordA $sensors[$i].coord -coordB $sensors[$j].coord
                $sumofreach = $sensors[$i].d + $sensors[$j].D
                switch ($distbetween - $sumofreach){
                    {$_ -le 0} {$status = "Overlap"}
                    {$_ -eq 1} {$status = "Abut"}
                    {$_ -eq 2} {$status = "Gap"}
                    default {$status = ""}
                }
                
                #write-verbose ("  -Dist between : {0} Sum of Reach: {1}" -f $distbetween,$sumofreach) 
                Write-Verbose ("[{0}][{1}] D: {2} R: {3} {4} -- {5} -- {6}" -f $i,$j,$distbetween, $sensors[$i].d, $sensors[$j].d, ($distbetween - $sensors[$i].d - $sensors[$j].d), $status)
                $delta = $distbetween - $sumofreach
                if( ($delta -le 2) -and ($delta -ge 0)){$flag = $true}else{$flag = $false}
                $curiousSensors += [PSCustomObject]@{
                    Pair = ("[{0}][{1}]" -f $i,$j)
                    S0 = $i
                    S1 = $j
                    Distance = $distbetween
                    Delta = $distbetween - $sumofreach
                    Status = $status    
                    Flag = $flag
                }
                
                if($distbetween -eq $sumofreach + 2){
                #    Write-verbose ("**** We've got a live one ****")
                    #Write-verbose("`tSensor {0} and Sensor {1}" -f $i, $j)
                    #write-verbose ("`t-Dist between : {0} Sum of Reach: {1}" -f $distbetween,$sumofreach)
                    #$curiousSensors += $sensors[$i]
                    #$curiousSensors += $sensors[$j]
                    #Write-Verbose ("{0} and {1}" -f $i,$j)
                }
            }#inner
            
        }#outer
    #$curiousSensors = $curiousSensors | sort Index 
        if($OutputCuriousSensors){ $curiousSensors}
    }#debug if

    
    
    }
}

function Get-Distance {
    [cmdletbinding()]
    param(
        $coordA,
        $coordB
    )
    Begin{
        $Ax = $coordA.split(",")[0]
        $Ay = $coordA.split(",")[1]
        $Bx = $coordB.split(",")[0]
        $By = $coordB.split(",")[1]

        $dx = [math]::abs($Ax - $Bx)
        $dy = [math]::abs($Ay - $By)
        $d = $dx + $dy
        $d


    }
}

function Merge-Ranges2 {
    [cmdletbinding()]
    param(
        $A,
        $B
        )
    Begin{
        $results = @()
        [int]$Astart = [int]$A.split(",")[0]
        [int]$Afinish = [int]$A.split(",")[1]
        [int]$Bstart = [int]$B.split(",")[0]
        [int]$Bfinish = [int]$B.split(",")[1]

        if($astart -gt $bstart){
            #swap A and B
            $ts = [int]$Astart; $tf = [int]$Afinish
            $Astart = [int]$Bstart; [int]$Afinish = $Bfinish
            [int]$Bstart = $ts; [int]$Bfinish = $tf
        }

        Write-Verbose ("A: {0} to {1}" -f $Astart, $Afinish)
        Write-Verbose ("B: {0} to {1}" -f $Bstart, $Bfinish)
        Write-Verbose ("")

        if($Bstart -gt $Afinish){
            write-verbose("{0}"-f ($Afinish + 1))
            if(($Afinish + 1) -eq $Bstart){
                #Adjacent
                Write-verbose ("Discrete Adjacent")
                $results += ("{0},{1}" -f $Astart,$Bfinish)
            }
            else{
                #not adjacent
                Write-verbose ("Discrete")
                $results += ("{0},{1}" -f $Astart,$Afinish)
                $results += ("{0},{1}" -f $Bstart,$Bfinish)
            }
        }
        Else{
            #some overlap
            if($Bfinish -le $Afinish){
                #B is in A
                Write-verbose ("B is a subset of A")
                $results += ("{0},{1}" -f $Astart,$Afinish)
            }
            else{
                #There is overlap and B is not in A
                Write-verbose ("The sets overlap")
                $results += ("{0},{1}" -f $Astart,$Bfinish)
            }
        }
        $results
    }
}

function Merge-Ranges {
    [cmdletbinding()]
    param(
        $SetsofRanges
        )
    Begin{
        
        $rangeArray = @()
        $index = 0
        foreach($range in $SetsofRanges){
            $rangeArray += [PSCustomObject]@{
                #Index = $index
                RangeStr = $range
                Start = [int]$range.split(",")[0]
                Finish = [int]$range.split(",")[1]
            }
        $index++
        }

        $rangeArray = $rangeArray | sort Start
        $index = 0
        while ($index -lt ($rangeArray.count -1)){
            #merge $index and $index+1
                $results = @()
                $Astart = $rangeArray[$index].Start
                $Afinish = $rangeArray[$index].Finish
                $Bstart = $rangeArray[$index+1].Start
                $Bfinish = $rangeArray[$index+1].Finish

                #Write-Verbose ("A: {0} to {1}" -f $Astart, $Afinish)
                #Write-Verbose ("B: {0} to {1}" -f $Bstart, $Bfinish)
                #Write-Verbose ("")

                if($Bstart -gt $Afinish){
                    #write-verbose("{0}"-f ($Afinish + 1))
                    if(($Afinish + 1) -eq $Bstart){
                        #Adjacent
                        #Write-verbose ("Discrete Adjacent")
                        $results += ("{0},{1}" -f $Astart,$Bfinish)
                    }
                    else{
                        #not adjacent
                        #Write-verbose ("Discrete")
                        $results += ("{0},{1}" -f $Astart,$Afinish)
                        $results += ("{0},{1}" -f $Bstart,$Bfinish)
                    }
                }
                Else{
                    #some overlap
                    if($Bfinish -le $Afinish){
                        #B is in A
                        #Write-verbose ("B is a subset of A")
                        $results += ("{0},{1}" -f $Astart,$Afinish)
                    }
                    else{
                        #There is overlap and B is not in A
                        #Write-verbose ("The sets overlap")
                        $results += ("{0},{1}" -f $Astart,$Bfinish)
                    }
                }   
            
            #if results are one -
                if($results.count -eq 1){
                    #add the new set to the end of rangearray
                    
                    $newrange = [PSCustomObject]@{
                        RangeStr = $results[0]
                        Start = [int]$results[0].split(",")[0]
                        Finish = [int]$results[0].split(",")[1]
                    }
                    
                    $rangeArray += $newrange
                    #remove index and index + 1 from rangearray
                    $rangeArray = $rangeArray|select -Skip 2
                    #resort
                    $rangeArray = $rangeArray | sort Start
                    #leave index the same
                }
                if($results.count -eq 2){
                    #leave them as is in rangearray
                    #increment counter
                    $index++
                }
                
        }
        
        $rangeArray
    }
}

Function Get-Perimeter {
    [cmdletbinding()]
    Param(
        $sensorinput
    )
    Begin{
        #$sensorinput
        
        [int]$R = $sensorinput.D
        [int]$x = $sensorinput.X
        [int]$y = $sensorinput.Y
        $r = $r + 1
        Write-Verbose ("Sensor: ({0},{1})" -f $x, $y)
        $edges += @()
        for($g = 0;$g -le $r;$g++){
            $tx = ($x -$r -$g)
            $ty = ($y + $g)
            $edges += ("{0},{1}" -f ($x -$r +$g),($y + $g))
            $edges += ("{0},{1}" -f ($x -$r +$g),($y - $g))
            $edges += ("{0},{1}" -f ($x +$g),($y + ($r - $g)))
            $edges += ("{0},{1}" -f ($x +$g),($y - ($r - $g)))
            }
        
        $edges | select -Unique
    }
}
