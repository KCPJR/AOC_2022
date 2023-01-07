Function D16{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $Test,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $Real
    )
    Begin{

        switch ($PsCmdlet.ParameterSetName) {
            A {
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_16\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_16\Input.txt
            }
            Default {}
        }

        #Parse the input
        $nodes = @()

        Foreach($node in $data){
            $splitspace = $node.split(" ")
            $name = $splitspace[1]
            $rateraw = $splitspace[4]
            
            $rate = $rateraw.Substring(5,($rateraw.Length -6))
            $connections = $splitspace | Select-Object -Skip 9
            $connections = $connections -join ("")
            $connections = @($connections.split(","))

            $nodes += [PSCustomObject]@{
                Name = $name
                Rate = $rate
                Connections = $connections
                ValveOn = $false
                Earning = 0
                Potential = $rate
            }
        }


        #generate shortest paths to each node matrix
        $DistMatrixH = @{}
        $DistMatrix = @()
        Foreach($BigloopKey in $nodes.name){
            $m = @{}
            Foreach($node in $nodes){
                $m[$node.Name] += [PSCustomObject]@{
                    Dest = $node.Name
                    Dist = 10000
                    Visited = $false
                    Path = @()
                }
            }

            

            $start = $BigloopKey
            $m[$start].dist = 0
            $unvisited = $m.values | ? {$_.visited -eq $false}


            While ($unvisited.count -ge 1){
                #$active = $unvisited.values|sort dist |select -First 1 -ExpandProperty Dest
                #$active = $unvisited.values
                #$active = $active|sort Dist
                #$active = $active | select -first 1 
                $active = $unvisited|sort dist |select -First 1 -ExpandProperty Dest
                $m[$active].visited = $true
                $activeNode = $nodes | ?{$_.name -eq $active}
                $connections = $activeNode.Connections
                foreach($connection in $connections){
                    if($m[$connection].visited -eq $false){
                        $m[$connection].dist = $m[$active].dist +1
                        $m[$connection].Path = $m[$active].Path
                        $m[$connection].Path += $m[$connection].Dest
                    }
                

                }
                $unvisited = $m.values | ? {$_.visited -eq $false}
            }
            foreach($mkey in $m.keys){
                $Key = ("{0},{1}" -f $start,$m[$mkey].Dest)
                #if($start -ne $m[$mkey].Dest)
                #{
                    $DistMatrixH[$Key] = $m[$mkey].Path
                    $tpath = $m[$mkey].Path
                    #Write-Verbose ("Path: {0}" -f ($tpath -join " -> "))
                    $Pot = $nodes|?{$_.name -eq $mkey}|select -first 1 -ExpandProperty Potential
                    $DistMatrix += [PSCustomObject]@{
                        Orig = $start
                        Dest = $m[$mkey].Dest
                        Path = @($m[$mkey].path)
                        Dist = $tpath.count
                        Pot = $Pot
                    }
                #}
            }
        }
        
        #$DistMatrix
        $Time = 0

        $currentnode = "AA"
        $totalReleased = 0
        while ($Time -le 29){
            $time++
            Write-Verbose ("`n == Minute {0} ==" -f $Time)
            $maxdist = $DistMatrix|?{$_.Orig -eq $currentnode}|sort Dist -Descending | select -ExpandProperty Dist -First 1
            #Write-Verbose("Max dist from {0}: {1}" -f $node.name, $maxdist)
            #Write-Verbose ("")
            $proj = @()
            $earningsthisturn = $nodes | measure -Property earning -Sum |select -ExpandProperty sum
            Write-Verbose ("Earnings this turn: {0}" -f $earningsthisturn)
            $totalReleased += $earningsthisturn
            Write-Verbose ("Total Released: {0}" -f $totalReleased)
            ForEach ($node in $nodes){    
                
                $destnode = $DistMatrix | ? {($_.orig -eq $currentnode) -and ($_.Dest -eq $node.name)}
                $dist = $destnode.Dist
                $pot = $destnode.Pot
                if($dist -eq 0){$RelativePot = [int]$pot * ($maxdist)}Else{ $RelativePot = ($maxdist - $dist) * $Pot / $dist }
                $Proj += [PSCustomObject]@{
                    Dest = $node.Name
                    RPot = [int]$RelativePot
                    Pot = $Pot
                    Dist = $dist
                    Path = $destnode.Path
                }
            }
            $hipot = $proj | sort rpot -Descending | select -First 1
            $hipotDest = $hipot.Dest
            
            $hipotct = @($proj| ?{$_.RPot -eq $hipot.RPot}).Count
            if($hipotct -gt 1) {Write-Warning -Message "Lucy - We've got a problem..."}
            $newobjective = $hipot.Dest


            if($newobjective -eq $currentnode){
                $indofcur = $nodes.name.indexof($currentnode)
                $nodes[$indofcur].ValveOn = $true
                $nodes[$indofcur].Earning = $nodes[$indofcur].Rate
                Write-Verbose ("Turning on valve: {0}" -f $currentnode)
                $nodes[$indofcur].Potential = 0
                $DistMatrix | ? {$_.Dest -eq $currentnode}|%{$_.pot = 0}
            }
            else{
                $currentnode = $hipot.Path[0]
                Write-Verbose ("Moving to Valve: {0}" -f $currentnode)
            }
            #Start-Sleep -Seconds 1
        }
        #$proj
        
    }
}