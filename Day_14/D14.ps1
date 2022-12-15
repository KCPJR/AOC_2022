Function D14{
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
                $data = Get-Content .\Day_14\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_14\Input.txt
            }
            Default {}
        }
        #hash
        $h = @{}
        [int]$minx = $null
        $maxx = $null
        $miny = $null
        $maxy = $null

        foreach($line in $data){
            Write-verbose ("Line: {0}" -f $line)
            $verts = $line.split(" -> ")
            $vertsindexmax = $verts.count -1
            Write-Verbose ("Vertindmax: {0}" -f $vertsindexmax)

            $i = 0
            While(($i + 1) -le $vertsindexmax){
                write-host ("{0} to {1}" -f $verts[$i],$verts[$i+1])
                $s = [PSCustomObject]@{
                    X = $verts[$i].split(",")[0]
                    Y = $verts[$i].split(",")[1]
                    }

                $f = [PSCustomobject]@{
                    X = $verts[$i+1].split(",")[0]
                    Y = $verts[$i+1].split(",")[1]
                    }
                
                #North/South 
                if($s.x -eq $f.x){
                    $dy = ($s.y)..($f.y)
                    $dy|%{("{0},{1}" -f $s.x, $_)}|%{$h[$_] = 'Rock'}
                    $rmin = $dy|sort | select -First 1
                    $rmax = $dy|sort -Descending| select -First 1
                    if(($null -eq $miny) -or ($rmin -lt $miny)){$miny = $rmin}
                    if(($null -eq $maxy) -or ($rmax -gt $maxy)){$maxy = $rmax}
                }
                #East/West
                if($s.y -eq $f.y){
                    $dx = ($s.x)..($f.x)
                    $dx|%{("{0},{1}" -f $_, $s.y)}|%{$h[$_] = 'Rock'}
                    $rmin = $dx|sort | select -First 1
                    $rmax = $dx|sort -Descending| select -First 1
                    if(($null -eq $minx) -or (($rmin) -lt $minx)){$minx = ($rmin)}
                    if(($null -eq $maxx) -or (($rmax) -gt $maxx)){$maxx = ($rmax)}
                }
                
                $i++
            } #while loop
                
                
            }# foreach line in data
            $xs = $h.keys | % {[int]($_.split(","))[0]}
            $ys = $h.keys | % {[int]($_.split(","))[1]}
            $xmin = $xs|sort | select -first 1
            $xmax = $xs|sort -Descending | select -First 1
            $ymin = $ys|sort | select -First 1
            $ymax = $ys|sort -Descending | select -First 1

                Write-Verbose ("X Range: {0} to {1} ({2})" -f $xmin,$xmax,($xmax - $xmin))
                Write-Verbose ("Y Range: {0} to {1} ({2})" -f $ymin,$ymax,($ymax - $ymin))
            
            
            #$h
        #drop the sand

        $time = 0
        $exit = $false
        $gameover = $false
        $SandCounter = 0
        while (!$gameover){    
            Write-Verbose ("Dropping Sand {0}" -f ($SandCounter + 1))
            $stopped = $false
            $sand = "500,0"
            $x = [int]$sand.split(",")[0]
            $y = [int]$sand.split(",")[1]            
            $currentCoord = ("{0},{1}" -f $x,$y)
            $h[$currentCoord] = "Sand"
            
            while(!$stopped -and !$gameover){
                $currentCoord = ("{0},{1}" -f $x,$y)

                #down 
                $newx = $x; $newy = $y+1
                $newcoord = ("{0},{1}" -f $newx,$newy)    
                if($h.ContainsKey($newcoord)){
                    #spot is occupied
                    $moved = $false
                }
                else{
                    #move grain of sand out of old spot into new spot and advance time.
                    $h[$newcoord] = "Sand"
                    $h.Remove($currentCoord)
                    $moved = $true
                    $time++
                    $x = $newx; $y = $newY
                    if($y -gt $maxy){$gameover = $true}
                    Continue
                }

                #left
                $newx = $x-1; $newy = $y+1
                $newcoord = ("{0},{1}" -f $newx,$newy) 
                if($h.ContainsKey($newcoord)){
                    #spot is occupied
                    $moved = $false
                }
                else{
                    #move grain of sand out of old spot into new spot and advance time.
                    $h[$newcoord] = "Sand"
                    $h.Remove($currentCoord)
                    $moved = $true
                    $time++
                    $x = $newx; $y = $newY
                    if($y -gt $maxy){$gameover = $true}
                    Continue
                }

                #right
                $newx = $x + 1 ; $newy = $y + 1
                $newcoord = ("{0},{1}" -f $newx,$newy) 
                if($h.ContainsKey($newcoord)){
                    #spot is occupied and no other options sand stops and stays put
                    $SandCounter++
                    $moved = $false
                    $stopped = $true
                }
                else{
                    #move grain of sand out of old spot into new spot and advance time.
                    $h[$newcoord] = "Sand"
                    $h.Remove($currentCoord)
                    $moved = $true
                    $time++
                    $x = $newx; $y = $newY
                    if($y -gt $maxy){$gameover = $true}
                }

                

            }#moving grain of sand loop

        }   #sand loop
        
        write-host ("Sand counter: {0}" -f $SandCounter)
        } #begin
} #function