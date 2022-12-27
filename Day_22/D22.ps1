Function D22{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $A,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $B
    )
    Begin{

        switch ($PsCmdlet.ParameterSetName) {
            A {
                #Write-host "ParameterSet A"
                $data = Get-Content .\Day_22\Input_test.txt
            }
            B {
                #Write-host "ParameterSet B"
                $data = Get-Content .\Day_22\Input.txt
            }
            Default {}
        }

        $board = @{}
        $moves = @()
        $i = 0
        While($data[$i] -ne ""){
            #write-host "Map Found"
            #Write-host("{0}" -f $data[$i])
            $ta = $data[$i].tochararray()
            $x = 0
            foreach($v in $ta){
                $coord = ("{0},{1}" -f $x,$i)
                $board[$coord] = $v
                $x++
            }
            $i++
        }
        
        #$board
        
        #Build the Moves array
        [int]$boardmaxY = [int]$i -1 
        [int]$boardmaxX = 0


        $i++
        $Movedata = $data[$i]
        
        #$Movedata = "1R"
        #$Movedata = "1L1L1L1L"
        #write-host ("")
        #write-host ("{0}" -f $Movedata)
        $mda = $Movedata.tochararray()
        
        
        [int]$nstart = 0; [int]$ncount = 0
        foreach($c in $mda){
            
            switch($C){
                "R" {
                    $Steps = $mda[$nstart..($nstart + $ncount -1)] -join ("")
                    #write-host ("Steps: {0}" -f $Steps)
                    $moves += $Steps
                    [int]$nstart = [int]$nstart + [int]$ncount + 1
                    [int]$ncount = 0
                    #write-host "Turn Right"
                    $moves += "Turn Right"
                }
                "L" {
                    $Steps = $mda[$nstart..($nstart + $ncount -1)] -join ("")
                    #write-host ("Steps: {0}" -f $Steps)
                    $moves += $Steps
                    [int]$nstart = [int]$nstart + [int]$ncount + 1
                    [int]$ncount = 0
                    
                    #write-host "Turn Left"
                    $moves += "Turn Left"
                }
                Default {
                    $ncount++
                    #write-host "Must be part of a number"
                }
            }#Switch
        }#move array characters
    #moves array built
    #moves Test scenarios
    #$moves = ("1","Turn Right")
    

    #find starting postition (leftmost open spot in top row)
    $x = 0
    While ($board[("{0},{1}" -f $x,0)] -ne "."){$x++}
    $StartingCoord = "{0},{1}" -f $x,0
    $startingDirection = "East"
    
    $P = [PSCustomObject]@{
        x = [int]$x
        y = 0
        Coord = $StartingCoord
        Facing = $startingDirection
    }

    [int]$boardmaxX = 0
    [int]$boardmaxY = 0
    foreach($sqkey in $board.keys){
        [int]$tx = $sqkey.split(",")[0]
        [int]$ty = $sqkey.split(",")[1]
        if($tx -gt $boardmaxX){[int]$boardmaxX = $tx}
        if($ty -gt $boardmaxY){[int]$boardmaxY = $ty}
    }

    #Pad the board 
    for($ty = 0;$ty -le $boardmaxY;$ty++){
        for($tx = 0;$tx -le $boardmaxX;$tx++){
            $tc = ("{0},{1}" -f $tx,$ty)
            if($board.ContainsKey($tc)){
                #board spot exists -- do nothing
            }
            else{
                $board[$tc] = " "
            }
        }
    }

    #$board

    #Write-host ("Status: {0} Facing: {1}" -f $p.Coord, $p.Facing)
Draw-Board -bor $board -cp $P
$moveit = $true
    #Move it
    if($moveit){
        [int]$moveind = 0
    foreach ($m in $moves  ){
       #Write-host ("Move {0}" -f $moveind)
        Write-host ("`nMove Index: {0}  Move: {1}" -f $moveind,$m)
        switch($m){
            "Turn Left" {
                $p.Facing = Get-NewDirection -currentHeading $p.Facing -TurnDirection $m
                #Draw-Board -bor $board -cp $P 
                #Write-host (" -Turning Left")
                break
            }
            "Turn Right" {
                $p.Facing = Get-NewDirection -currentHeading $p.Facing -TurnDirection $m
                #Draw-Board -bor $board -cp $P    
                #Write-Host (" -Turning Right")
                break
            }   
            default {
                #write-verbose (" -Moving {0}" -f $m)
                [int]$mm = 1
                $donewithmove = $false
                [int]$tempx = $p.x; [int]$tempy = $p.y
                While( ($mm -le [int]$m) -and !$donewithmove){ 
                    switch ($p.Facing) {
                        "North" {
                            $tempy--;break
                        }
                        "East" {
                            $tempx++;break
                        }
                        "South" {
                            $tempy++;break
                        }
                        "West" {
                            $tempx--;break
                        }
                        Default {}

                    }
                    $target = ("{0},{1}" -f $tempx ,$tempy)
                    
                    $exists = $board.ContainsKey($target)
                    if(!$exists){
                        switch($p.Facing){
                            "North" {
                                [int]$tempy = $boardmaxY ;break
                            }
                            "East" {
                                [int]$tempx = 0;break
                            }
                            "South" {
                                [int]$tempy = 0;break
                            }
                            "West" {
                                [int]$tempx = $boardmaxx;break
                            }
                        }
                        $target = ("{0},{1}" -f $tempx ,$tempy)
                    }

                    switch($board[$target]){
                        " " {
                            #need to keep looking for a valid spot
                            #fast forward
                            switch($p.Facing){
                                "North" {
                                    $tc = ("{0},{1}" -f $tx,$ty)
                                    while($board[$tc] -eq " "){
                                        $ty--
                                        $tc = ("{0},{1}" -f $tx,$ty)
                                    }
                                    #back up 1 spot
                                    $ty++
                                    break
                                }
                                "East" {
                                    $tc = ("{0},{1}" -f $tx,$ty)
                                    while($board[$tc] -eq " "){
                                        $tx++
                                        $tc = ("{0},{1}" -f $tx,$ty)
                                    }
                                    #back up 1 spot
                                    $tx--
                                    break
                                }
                                "South" {
                                    $tc = ("{0},{1}" -f $tx,$ty)
                                    while($board[$tc] -eq " "){
                                        $ty++
                                        $tc = ("{0},{1}" -f $tx,$ty)
                                    }
                                    #back up 1 spot
                                    $ty--
                                    break
                                }
                                "West" {
                                    $tc = ("{0},{1}" -f $tx,$ty)
                                    while($board[$tc] -eq " "){
                                        $tx--
                                        $tc = ("{0},{1}" -f $tx,$ty)
                                    }
                                    #back up 1 spot
                                    $tx++
                                    break
                                }
                            }
                            
                            
                            
                            $donewithmove = $false
                            break
                        }
                        "." {
                            #valid space - move there
                            $p.Coord = $target
                            $p.x = $target.split(",")[0]
                            $p.y = $target.split(",")[1]
                            $mm++
                            #Draw-Board -bor $board -cp $P
                            break
                        }
                        "#" {
                            #We've hit a wall... stop moving and go to next move
                            $donewithmove = $true
                            #Draw-Board -bor $board -cp $P
                            break
                        }
                    }
                }

            }
        }
        Write-host ("   -Status: {0} Facing: {1}" -f $p.Coord, $p.Facing)
        #Draw-Board -bor $board -cp $P 
    $moveind++
    } 
}#moveit 
if($true){  
    Draw-Board -bor $board -cp $P
    write-host ""
    [int]$fr = [int]$p.y + 1
    Write-host ("Final Row:{0}" -f $fr)
    [int]$fc = [int]$p.x + 1
    write-host ("Final Col:{0}" -f $fc)

    switch($p.Facing){
        "North" {[int]$fd = 3}
        "East" {[int]$fd = 0}
        "South" {[int]$fd = 1}
        "West" {[int]$fd = 2}
        }
    write-host ("Final Dir:{0} ({1})" -f $p.facing,$fd)
    
    $solPart1 = ([int]1000 * [int]$fr) + ([int]4 * [int]$fc) + [int]$fd
    Write-host ("Solution Part 1: {0}" -f $solPart1)
    }
}#begin

}#function 

Function Get-NewDirection {
    [cmdletbinding()]
    param(
        $currentHeading,
        $TurnDirection
    )
    Begin{
        #Write-host ("Start Facing: {0}" -f $currentHeading)
        switch($currentHeading){
            "North" {[int]$d = 0;break}
            "East" {[int]$d = 1;break}
            "South" {[int]$d = 2;break}
            "West" {[int]$d = 3;break}
        }
        switch($TurnDirection){
            "Turn Left" {[int]$d = ([int]$d +3) % 4;break}
            "Turn Right" {[int]$d = ([int]$d + 5) % 4;break}
        }
        Switch($d){
            0 {$nd = "North";break}
            1 {$nd ="East";break}
            2 {$nd = "South";break}
            3 {$nd = "West";break}
        }
        $nd
    }
}

function Draw-Board {
    [cmdletbinding()]
    Param(
        $bor,
        $cp
    )
    Begin{
        #$bo.count
        [int]$My = 0
        [int]$mx = 0
        foreach($sqkey in $bor.keys){
            [int]$tx = $sqkey.split(",")[0]
            [int]$ty = $sqkey.split(",")[1]
            if($tx -gt $mx){[int]$mx = $tx}
            if($ty -gt $my){[int]$My = $ty}
        }
        clear-content -Path .\day_22\Mapoutput.txt
        #Write-Verbose ("Max X: {0}  Max Y: {1}" -f $mx, $My)
        for($i = 0;$i -le $my;$i++){
            $tstr = ""
            for($j = 0;$j -le $mx;$j++){
                $tc = ("{0},{1}" -f $j,$i)
                if($bor.ContainsKey($tc)){
                    if($tc -eq $cp.Coord){
                        switch($cp.facing){
                            "North" {$tstr += "^"}
                            "South" {$tstr += "V"}
                            "East" {$tstr += ">"}
                            "West" {$tstr += "<"}
                        }
                    }
                    else{
                        $tstr += $bor[$tc]
                    }
                }
                else{
                    $tstr += " "
                }
            }
            
            add-content -Value $tstr -Path .\day_22\Mapoutput.txt

        }
    }
}