Function D18{
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
        #$b = @()
        $h = @{}
        foreach($dp in $data){
            $h[$dp] = $true
            
        }
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

        foreach($k in $h.Keys){
            Write-Verbose ("{0}" -f $k)
            <# $c = 6
            [int]$x = $k.split(",")[0]
            [int]$y = $k.split(",")[1]
            [int]$z = $k.split(",")[2]
            $t1 = ("{0},{1},{2}" -f ($x-1),($y),($z))
            $t2 = ("{0},{1},{2}" -f ($x+1),($y),($z))   
            $t3 = ("{0},{1},{2}" -f ($x),($y-1),($z))   
            $t4 = ("{0},{1},{2}" -f ($x),($y+1),($z))   
            $t5 = ("{0},{1},{2}" -f ($x),($y),($z-1))   
            $t6 = ("{0},{1},{2}" -f ($x),($y),($z+1)) 
            
            if($h.ContainsKey($t1)){$c--}
            if($h.ContainsKey($t2)){$c--}
            if($h.ContainsKey($t3)){$c--}
            if($h.ContainsKey($t4)){$c--}
            if($h.ContainsKey($t5)){$c--}
            if($h.ContainsKey($t6)){$c--}

            if($x -lt $xmin){$xmin = $x}
            if($x -gt $xmax){$xmax = $x}
            if($y -lt $ymin){$ymin = $y}
            if($y -gt $ymax){$ymax = $y}
            if($z -lt $ymin){$zmin = $z}
            if($z -gt $ymax){$zmax = $z} #>
            
            [int]$x = $k.split(",")[0]
            [int]$y = $k.split(",")[1]
            [int]$z = $k.split(",")[2]
            
            if($x -lt $xmin){$xmin = $x}
            if($x -gt $xmax){$xmax = $x}
            if($y -lt $ymin){$ymin = $y}
            if($y -gt $ymax){$ymax = $y}
            if($z -lt $ymin){$zmin = $z}
            if($z -gt $ymax){$zmax = $z}
            
            $expsides = Get-ExposedSideCount -coord $k -ht $h


            Write-Verbose ("  - Sides Exposed: {0}" -f $expsides)
            $GT = $GT + $expsides
        }
        write-host ("Grand Total: {0}" -f $GT)

        #Part 2 
       
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