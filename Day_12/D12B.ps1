#something not right with d12b - iterates loooonnnnggg.... but found correct answer (414)
#did not complete iteration of loop.  Broke it and guessed correctly with the lowest at that time.

Function D12b{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $A,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $B,
        $start = 0
    )
    Begin{

        switch ($PsCmdlet.ParameterSetName) {
            A {
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_12\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_12\Input.txt
            }
            Default {}
        }

        #Process Input
        $mapwidth = $data[0].Length
        $mapheight = $data.count
        $mapsize = $mapwidth * $mapheight 

        Write-Verbose ("Map W:{0} H:{1} Size:{2}" -f $mapwidth, $mapheight,$mapsize)

        #$start = 0
        $ct = 0
        #$map = New-Object 'object[,]' $mapwidth,$mapheight
        $map = @()
        $yind = -1
        foreach($line in $data){
            $yind++
            $xind = -1
            $lineitems = $line.ToCharArray()
            foreach($point in $lineitems){
                $xind++
                if(($ct % $mapwidth) -lt (($ct + 1 ) % $mapwidth)){
                    $Eind = $ct + 1}Else{$Eind = $null}
                if(( ($ct + $mapwidth) % $mapwidth) -gt (($ct + $mapwidth- 1) % $mapwidth)){$Wind = $ct - 1}Else{$Wind = $null}
                if(($ct - $mapwidth) -ge 0) {$Nind = $ct - $mapwidth}else{$Nind = $null}
                if(($ct + $mapwidth) -le ($mapsize -1)){$Sind = $ct + $mapwidth}else{$Sind = $null}

                #$elevation = [byte][char]$point    

                #if($point -eq "E"){$elevation = 'z';$Finish = $ct}else{$elevation = $point}
                $modpoint = $point
                if($point -ceq "E"){$modpoint = 'z'
                    $Finish = $ct
                }
                if($point -ceq "S"){$modpoint = 'a'
                    #$Start = $ct
                }    
                $elevation = [byte][char]$modpoint - 97
                
                $map += [PSCustomObject]@{
                  Index = $ct
                    Elevation = $elevation
                  X = $xind
                  Y = $yind
                  Nind = $Nind
                  Nval = ""
                  Sind = $Sind
                  Sval = ""
                  Eind = $Eind
                  Eval = ""
                  Wind = $Wind
                  Wval = ""

                  CanGoUp = $false
                  UpMoves = @()
                  CanGoLevel = $false
                  LevelMoves = @()
                  CanGoDown = $false
                  DownMoves = @()
                  Moves = @()
                }
            
                $ct++
                #$map[$xind,$yind] = $point
                #write-verbose("({0},{1}) -- {2}" -f $xind,$yind,$map[$xind,$yind])
                #$map[$xind,$yind] = $point
            }
        }
        Write-Verbose ("Start: {0}  Finish: {1}" -f $start,$Finish)
        
        foreach($location in $map){
            #write-verbose ("{0} -- East: {1}" -f $location.Index, $location.Eind)
            if($location.Eind -ne $null){$map[$location.Index].eval= $map[$location.Eind].Elevation}
            if($location.wind -ne $null){$map[$location.Index].wval= $map[$location.wind].Elevation}
            if($location.sind -ne $null){$map[$location.Index].sval= $map[$location.sind].Elevation}
            if($location.nind -ne $null){$map[$location.Index].nval= $map[$location.nind].Elevation}

        }

        foreach($i in $map){
            if($i.Elevation +1 -in ($i.Nval,$i.Sval,$i.Eval,$i.Wval)){$map[$i.index].CanGoUp = $true}
            if($i.eval -eq $i.Elevation +1){$map[$i.Index].upmoves += $i.eind}
            if($i.nval -eq $i.Elevation +1){$map[$i.index].Upmoves += $i.nind}
            if($i.sval -eq $i.Elevation +1){$map[$i.index].UpMoves += $i.Sind}
            
            if($i.wval -eq $i.Elevation +1){$map[$i.Index].UpMoves += $i.wind}

            if($i.Elevation -in ($i.nval,$i.Sval,$i.Eval,$i.Wval)){$map[$i.index].CanGoLevel = $true}
            if($i.Nval -eq $i.Elevation){$map[$i.Index].LevelMoves += $i.nind}
            if($i.sval -eq $i.Elevation){$map[$i.Index].LevelMoves += $i.sind}
            if($i.eval -eq $i.Elevation){$map[$i.Index].LevelMoves += $i.eind}
            if($i.wval -eq $i.Elevation){$map[$i.Index].LevelMoves += $i.wind}

            if($i.Elevation -gt $i.nval){$map[$i.index].CanGoDown = $true;$map[$i.Index].downmoves += $i.Nind}
            if($i.Elevation -gt $i.sval){$map[$i.index].CanGoDown = $true;$map[$i.Index].downmoves += $i.sind}
            if($i.Elevation -gt $i.eval){$map[$i.index].CanGoDown = $true;$map[$i.Index].downmoves += $i.eind}
            if($i.Elevation -gt $i.wval){$map[$i.index].CanGoDown = $true;$map[$i.Index].downmoves += $i.wind}

            $map[$i.index].downmoves = @($map[$i.index].downmoves | ? {$null -ne $_})

            #build possible moves
            foreach($move in ($i.upmoves|sort) ){
                $i.moves += $move
            }
            foreach($move in $i.levelmoves|sort){
                $i.moves += $move
            }
            foreach($move in $i.DownMoves){
                $i.moves += $move
            }

        }
        
        #$map
        if(!$false){
        #start moving
        $m = @()
        $ind = 0
        0..($mapsize -1)| % {
            $m += [PSCustomObject]@{
                Index = $ind
                Dist = 10000
                Visited = $false
            }
            $ind++
        }
        $m[$start].dist = 0
        $unvisited = $m|?{$_.visited -eq $false}
        write-verbose ("Unvisited: {0}" -f $unvisited.count)
        $exit = $false
        while ( ($unvisited.count -ge 1) -and ($exit -eq $false)){
            $active = $unvisited|sort dist |select -ExpandProperty index -First 1

            $m[$active].visited = $true

            foreach($move in $map[$active].moves){
                if($m[$move].visited -eq $false){
                    $m[$move].dist = $m[$active].dist + 1
                }    
            }
            $unvisited = $m|?{$_.visited -eq $false}
            if($m[$Finish].Visited -eq $true){$exit = $true}
        }

        Write-host ("Solution: {0}" -f $m[$Finish].Dist)
        $solution = $m[$finish].dist
        #$m
    }
        #pick the next node not already in sptset with the lowest dist.
        #$next = $map[$active].moves | ? {$_ -notin $sptset}|select -first 1
        


        #output map
        #$map
         
        #write-verbose (" (0,0): {0}" -f $map[0][0])
        #write-verbose (" (1,0): {0}" -f $map[1][0])


    }
}

function _helper {
    $startingvalues = Get-Content .\Day_12\Lowpoints.txt
    $steps = @()
    for($q = 0;$q -le $startingvalues.count ;$q++){
        $steps += d12b -b -start $startingvalues[$q]
        Write-host ("Path {0} of {1} -- {2:p}" -f $q,$startingvalues.count,($q/$startingvalues.count))
    }
    $s = $steps|sort | select -First 1
    write-host ("solution: {0}" -f $s)
    $steps
}