Function D08{
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
                $data = Get-Content .\Day_08\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_08\Input.txt
            }
            Default {}
        }

        $datah = $data.count
        $dataw = $data[0].length
        $TreeisSafe = 0
        $SafeTrees = 0
        $visibleTrees = 0
        $bestVis = 0
        for($r = 0;$r -lt $datah;$r++){
            for($c = 0;$c -lt $dataw;$c++){
                
                Write-Verbose ("Row:{0} Column:{1} Value:{2}" -f $r,$c,$data[$r][$c])

                $blockedNorth = $false
                $blockedSouth = $false
                $blockedEast = $false
                $blockedWest = $false

                #North
                    $y = $r -1
                    $exit = $false
                    $VisNorth = 0
                    while($y -ge 0 -and !$exit){
                        $VisNorth++
                        #Write-verbose ("`tNorth:{0} Current Tree:{1}" -f $data[$y][$c],$data[$r][$c])
                        if($data[$y][$c] -ge $data[$r][$c]){
                            $blockedNorth = $True
                            #write-verbose ("`t`tBlocked to the North")
                            $exit = $True
                        }
                        $y--
                    }

                #South
                    $VisSouth = 0
                    $y = $r +1
                    $exit = $false
                    While($y -lt $datah -and !$exit){
                        $VisSouth++
                        #Write-verbose ("`tSouth:{0} Current Tree:{1}" -f $data[$y][$c],$data[$r][$c])
                        if($data[$y][$c] -ge $data[$r][$c]){
                            $blockedSouth = $true
                            #Write-Verbose ("`t`tBlocked to the South")
                            $exit = $true
                        }
                        $y++
                    }

                #West    
                    $VisWest = 0
                    $x = $c -1
                    $exit = $false
                    #for($x = 0;$x -lt $c;$x++){
                    While($x -ge 0 -and !$exit){
                        $VisWest++
                        #write-verbose ("`tWest:{0} Current Tree:{1}" -f $data[$r][$x],$data[$r][$c])
                        if($data[$r][$x] -ge $data[$r][$c]){
                            $blockedWest = $True
                            Write-Verbose ("`t`tBlocked to the West")
                            $exit = $true
                        }
                        $x--
                    }

                #East
                    $VisEast = 0
                    $x = $c+1
                    $exit = $false
                    #for($x = $c+1;$x -lt $dataw;$x++){
                    while($x -lt $dataw -and !$exit){
                        $VisEast++
                        #Write-Verbose ("`tEast:{0} Current Tree:{1}" -f $data[$r][$x],$data[$r][$c])
                        if($data[$r][$x] -ge $data[$r][$c]){
                            $blockedEast = $True
                            #Write-Verbose ("`t`tBlocked to the East")
                            $exit = $true
                        }
                        $x++
                    }

                    if($blockedNorth -and $blockedSouth -and $blockedEast -and $blockedWest){
                        $TreeisSafe = $True;$SafeTrees++
                    }
                    else{
                        $visibleTrees++
                    }
                #write-verbose ("`tNorth: {0}" -f ($north -join ""))
            
                Write-Verbose ("`tVisibility N:{0} S:{1} W:{2} E:{3}" -f $VisNorth,$VisSouth,$VisWest,$VisEast)
                $viscore = $VisNorth * $VisSouth * $VisWest * $VisEast
                Write-Verbose ("`t`tVisibility Score: {0}" -f $viscore)
                if($viscore -gt $bestVis){$bestVis = $viscore}
            }


        }
   
        Write-host ("Safe Trees: {0}" -f $SafeTrees)
        Write-host ("Visible Trees: {0}" -f $visibleTrees)
        write-host ("Best Visibility Score: {0}" -f $bestVis)
    }
}