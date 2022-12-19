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
       
        #hash for solids
        $shash = @{}
        foreach($dp in $data){
            $shash[$dp] = $true
        }

        #hash for water
        $whash = @{}

        #hash for Unknowns
        $Uhash = @{}

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
            if($z -lt $ymin){$zmin = $z}
            if($z -gt $ymax){$zmax = $z}
        }
        
        $xmin = 0
        $ymin = 0

        Write-Verbose ("X: {0} to {1}" -f $xmin, $xmax)
        Write-Verbose ("Y: {0} to {1}" -f $ymin, $ymax)
        Write-Verbose ("Z: {0} to {1}" -f $zmin, $zmax)

        #dev with Z=1
        #$zmin = 0;$zmax = 0

        #seed the first water
        $whash["0,0,0"] = $true
        
        for($i = $xmin;$i -le $xmax;$i++){
            for($j=$ymin;$j -le $ymax;$j++){
                for($k = $zmin;$k -le $zmax;$k++){
                    $coord = ("{0},{1},{2}" -f $i,$j,$k)
                    Write-Verbose ("{0}" -f $coord)
                    if(!$shash.ContainsKey($coord)){$Uhash[$coord] = $true}
                }
            }
        }
        $changed = $false
        While($changed -eq $false){
            $changed = $false
            $uhashKeysSnap = $uhash.keys
            Write-Verbose ("Uhash count: {0}" -f ($uhash.Keys.count))
            foreach($loc in $uhashKeysSnap){
                $i = $loc.split(",")[0]
                $j = $loc.split(",")[1]
                $k = $loc.split(",")[2]
            
                $coord = ("{0},{1},{2}" -f $i,$j,$k)
                Write-Verbose ("{0}" -f $coord)

                $North = ("{0},{1},{2}" -f ($i), ($j-1), ($k))
                $South = ("{0},{1},{2}" -f $i,($j+1),$k)
                $East = ("{0},{1},{2}" -f ($i+1),$j,$k)
                $West = ("{0},{1},{2}" -f ($i-1),$j,$k)
                $Up = ("{0},{1},{2}" -f $i,$j,($k+1))
                $Down = ("{0},{1},{2}" -f $i,$j,($k-1))
                #write-verbose (" - Not Solid")
                if($whash.containskey($North)){$waterflag = $true}
                if($whash.containskey($South)){$waterflag = $true}
                if($whash.containskey($East)){$waterflag = $true}
                if($whash.containskey($West)){$waterflag = $true}
                if($whash.containskey($Up)){$waterflag = $true}
                if($whash.containskey($Down)){$waterflag = $true}
                
                if($waterflag -eq $true){
                    Write-Verbose ("-Changed")
                    $changed = $true
                    $whash[$coord] = $true
                    $Uhash.remove($coord)
                }
    
            }
        Write-Verbose ("`nUHash size: {0} " -f $Uhash.count)
        }
    }
}





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