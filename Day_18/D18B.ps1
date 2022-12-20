Function D18B{
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
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_18\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_18\Input.txt
            }
            Default {}
        }
        $EdgeFound = @()
        $exposedEdge = @()
        #hash for solids
        $shash = @{}
        foreach($dp in $data){
            $shash[$dp] = $true
        }

        #hash for water
        $whash = @{}

        $GT = 0
        [int]$x = $data[0].split(",")[0]
        [int]$y = $data[0].split(",")[1]
        [int]$z = $data[0].split(",")[2]
        
        $xmin = $x
        $xmax = $x
        $ymin = $y
        $ymax = $y
        $zmin = $z
        $zmax = $z

        foreach($k in $shash.Keys){
            #Write-Verbose ("{0}" -f $k)
            
            [int]$x = $k.split(",")[0]
            [int]$y = $k.split(",")[1]
            [int]$z = $k.split(",")[2]
            
            if($x -lt $xmin){$xmin = $x}
            if($x -gt $xmax){$xmax = $x}
            if($y -lt $ymin){$ymin = $y}
            if($y -gt $ymax){$ymax = $y}
            if($z -lt $zmin){$zmin = $z}
            if($z -gt $zmax){$zmax = $z}
        }
        
        #$xmin = 0
        #$ymin = 0
        $xmin--
        $xmax++
        $ymin--
        $ymax++
        $zmin--
        $zmax++

        Write-Verbose ("X: {0} to {1}" -f $xmin, $xmax)
        Write-Verbose ("Y: {0} to {1}" -f $ymin, $ymax)
        Write-Verbose ("Z: {0} to {1}" -f $zmin, $zmax)

        $toprocess = @()
            
        $whash["0,0,0"] = $true
        $i = 0
        $toprocess += [PSCustomObject]@{
            Index = $i
            Coord = ("0,0,1")
            X = 0
            Y = 0
            Z = 0
        }
        $SurfaceEdge = 0
        #$toprocess
        $j = 0
        While ($j -le $toprocess.count){
            Write-Verbose ("Processing: {0}" -f $toprocess[$j].Coord)
                $neighbors = @{}

                $X = $toprocess[$j].X
                $Y = $toprocess[$j].Y
                $Z = $toprocess[$j].Z

                #North
                $tx = $x; $ty = $y + 1; $tz = $z
                $Tcoord = ("{0},{1},{2}" -f $tx,$ty,$tz)
                    #is it in bounds?
                        if($tx -ge $xmin -and $tx -le $xmax -and $ty -ge $ymin -and $ty -le $ymax -and $tz -ge $zmin -and $tz -le $zmax){
                            Write-verbose (" North-Inbounds: {0}"-f $Tcoord)
                            $neighbors[$Tcoord] = $true
                        }
                        else{
                            #Write-Verbose(" Out of Bounds ({0})" -f $Tcoord)
                        }

                #South
                $tx = $x; $ty = $y - 1 ;$tz = $z
                $Tcoord = ("{0},{1},{2}" -f $tx,$ty,$tz)
                #is it in bounds?
                    if($tx -ge $xmin -and $tx -le $xmax -and $ty -ge $ymin -and $ty -le $ymax -and $tz -ge $zmin -and $tz -le $zmax){
                        Write-verbose (" South-Inbounds: {0}"-f $Tcoord)
                        $neighbors[$Tcoord] = $true
                    }
                    else{
                        #Write-Verbose(" Out of Bounds ({0})" -f $Tcoord)
                    }   

                #East
                $tx = $x + 1; $ty = $y ;$tz = $z
                $Tcoord = ("{0},{1},{2}" -f $tx,$ty,$tz)
                #is it in bounds?
                    if($tx -ge $xmin -and $tx -le $xmax -and $ty -ge $ymin -and $ty -le $ymax -and $tz -ge $zmin -and $tz -le $zmax){
                        Write-verbose (" East-Inbounds: {0}"-f $Tcoord)
                        $neighbors[$Tcoord] = $true
                    }
                    else{
                        #Write-Verbose(" Out of Bounds ({0})" -f $Tcoord)
                    }
                    
                #West
                $tx = $x - 1; $ty = $y ;$tz = $z
                $Tcoord = ("{0},{1},{2}" -f $tx,$ty,$tz)
                #is it in bounds?
                    if($tx -ge $xmin -and $tx -le $xmax -and $ty -ge $ymin -and $ty -le $ymax -and $tz -ge $zmin -and $tz -le $zmax){
                        Write-verbose (" West-Inbounds: {0}" -f $Tcoord)
                        $neighbors[$Tcoord] = $true
                    }
                    else{
                        #Write-Verbose(" Out of Bounds ({0})" -f $Tcoord)
                    }
                #Up
                $tx = $x; $ty = $y ;$tz = $z + 1
                $Tcoord = ("{0},{1},{2}" -f $tx,$ty,$tz)
                #is it in bounds?
                    if($tx -ge $xmin -and $tx -le $xmax -and $ty -ge $ymin -and $ty -le $ymax -and $tz -ge $zmin -and $tz -le $zmax){
                        Write-verbose (" UP-Inbounds: {0}"-f $Tcoord)
                        $neighbors[$Tcoord] = $true
                    }
                    else{
                        #Write-Verbose(" Out of Bounds ({0})" -f $Tcoord)
                    }
                
                #Down
                $tx = $x ; $ty = $y ;$tz = $z - 1
                $Tcoord = ("{0},{1},{2}" -f $tx,$ty,$tz)
                #is it in bounds?
                    if($tx -ge $xmin -and $tx -le $xmax -and $ty -ge $ymin -and $ty -le $ymax -and $tz -ge $zmin -and $tz -le $zmax){
                        Write-verbose (" Down-Inbounds: {0}"-f $Tcoord)
                        $neighbors[$Tcoord] = $true
                    }
                    else{
                        #Write-Verbose(" Out of Bounds ({0})" -f $Tcoord)
                    }

                Foreach($key in $neighbors.keys){

                    if($shash.ContainsKey($Key)){
                        $curx = $key.split(",")[0]
                        $cury = $key.split(",")[1]
                        $curz = $key.split(",")[2]

                        Write-Verbose ("  Edge on {0} found" -f $key)
                        if($toprocess[$j].x -lt $curx){$dir = "East"}
                        if($toprocess[$j].x -gt $curx){$dir = "West"}
                        if($toprocess[$j].y -lt $cury){$dir = "South"}
                        if($toprocess[$j].y -gt $cury){$dir = "North"}
                        if($toprocess[$j].z -lt $curz){$dir = "Down"}
                        if($toprocess[$j].z -gt $curz){$dir = "Up"}
                        
                        $EdgeFound += [PSCustomObject]@{
                            Coord = $key
                            Direction = $dir
                        }

                        $SurfaceEdge++
                    }
                    elseif(!$whash.ContainsKey($key)){
                    $whash[$key] = $true
                    $i++
                    $toprocess += [PSCustomObject]@{
                        Index = $i
                        Coord = $key
                        X = $key.split(",")[0]
                        Y = $key.split(",")[1]
                        Z = $key.Split(",")[2]
                        }
                    }
                }#neighbors

                $j++
            }#list of squares to process
         
        
            


        #Write-Host ("Surface Edges Found: {0}" -f $SurfaceEdge)    
        #$EdgeFound
        #$whash
            foreach($wk in $whash.keys){
                $expsides = Get-ExposedSideCount -coord $wk -ht $whash
                $GT = $GT + $expsides
            }
            write-host ("Water sides: {0}" -f $GT)

        $solidedgeexpostedtowater = 0
        foreach($sk in $shash.keys){
            $c = 6
            [int]$x = $sk.split(",")[0]
            [int]$y = $sk.split(",")[1]
            [int]$z = $sk.split(",")[2]
            $t1 = ("{0},{1},{2}" -f ($x-1),($y),($z))
            $t2 = ("{0},{1},{2}" -f ($x+1),($y),($z))   
            $t3 = ("{0},{1},{2}" -f ($x),($y-1),($z))   
            $t4 = ("{0},{1},{2}" -f ($x),($y+1),($z))   
            $t5 = ("{0},{1},{2}" -f ($x),($y),($z-1))   
            $t6 = ("{0},{1},{2}" -f ($x),($y),($z+1)) 
            if($whash.ContainsKey($t1)){
                $solidedgeexpostedtowater++
                $ee = "West"
                $exposedEdge += [PSCustomObject]@{
                    Coord = $sk
                    Direction = $ee
                }
            }
            if($whash.ContainsKey($t2)){
                $solidedgeexpostedtowater++
                $ee = "East"
                $exposedEdge += [PSCustomObject]@{
                    Coord = $sk
                    Direction = $ee
                }
            }
            if($whash.ContainsKey($t3)){
                $solidedgeexpostedtowater++
                $ee = "South"
                $exposedEdge += [PSCustomObject]@{
                    Coord = $sk
                    Direction = $ee
                }
            }
            if($whash.ContainsKey($t4)){
                $solidedgeexpostedtowater++
                $ee = "North"
                $exposedEdge += [PSCustomObject]@{
                    Coord = $sk
                    Direction = $ee
                }
            }
            if($whash.ContainsKey($t5)){
                $solidedgeexpostedtowater++
                $ee = "Down"
                $exposedEdge += [PSCustomObject]@{
                    Coord = $sk
                    Direction = $ee
                }
            }
            if($whash.ContainsKey($t6)){
                $solidedgeexpostedtowater++
                $ee = "Up"
                $exposedEdge += [PSCustomObject]@{
                    Coord = $sk
                    Direction = $ee
                }
            }
            
        }
        Write-host("Solid Edges exposed to water: {0}" -f $solidedgeexpostedtowater)
        $exposedEdge
    }#Begin
        
        
}#function






Function Get-ExposedSideCount {
    [cmdletbinding()]
    param(
    $ht,    
    $coord
    )

    #Write-Verbose ("{0}" -f $k)
            $c = 6
            [int]$x = $coord.split(",")[0]
            [int]$y = $coord.split(",")[1]
            [int]$z = $coord.split(",")[2]
            $t1 = ("{0},{1},{2}" -f ($x-1),($y),($z))
            $t2 = ("{0},{1},{2}" -f ($x+1),($y),($z))   
            $t3 = ("{0},{1},{2}" -f ($x),($y-1),($z))   
            $t4 = ("{0},{1},{2}" -f ($x),($y+1),($z))   
            $t5 = ("{0},{1},{2}" -f ($x),($y),($z-1))   
            $t6 = ("{0},{1},{2}" -f ($x),($y),($z+1)) 
            
            if($ht.ContainsKey($t1)){$c--}
            if($ht.ContainsKey($t2)){$c--}
            if($ht.ContainsKey($t3)){$c--}
            if($ht.ContainsKey($t4)){$c--}
            if($ht.ContainsKey($t5)){$c--}
            if($ht.ContainsKey($t6)){$c--}


            return $c
}