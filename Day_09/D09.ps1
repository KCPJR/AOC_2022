Function D09{
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
                $data = Get-Content .\Day_09\Input_test.txt
                #$data = Get-Content .\Day_09\Input_test2.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_09\Input.txt
            }
            Default {}
        }

        $Hx = 0;$Hy = 0
        $Tx = 0;$Ty = 0
        $TailHistory = @()
        foreach($move in $data){
            $direction = $move.split(" ")[0]
            [int]$spaces = $move.split(" ")[1]
            Write-verbose ("`t== {0} {1} ==" -f $direction,$spaces)
            for($i = $spaces;$i -gt 0;$i--){
                switch ($direction) {
                    "R" { $Hx++ }
                    "L" { $HX--}
                    "U" { $Hy++}
                    "D" { $Hy--}
                    Default {}
                }
                Write-Verbose("H({0},{1})" -f $Hx,$Hy)
                $deltaY = $Hy - $Ty
                $deltaX =  $Hx - $Tx
                Write-verbose ("`tDeltaY: {0}  DeltaX: {1}" -f $deltaY,$deltaX)
                
                if( (($Hy - $Ty) -in (-1,0,1)) -and (($Hx -$Tx) -in  (-1,0,1)) ){
                    Write-verbose ("`tAdjacent - no movement needed")
                }
                else{
                    #You've got to move it.
                    switch($direction){
                        "R" {
                            $Tx++
                            if($Ty -ne $Hy){$Ty = $Hy}
                        }
                        "L" {
                            $Tx--
                            if($Ty -ne $Hy){$Ty = $Hy}
                        }
                        "U" {
                            $Ty++
                            if($Tx -ne $Hx){$Tx = $Hx}
                        }
                        "D" {
                            $Ty--
                            if($Tx -ne $Hx){$Tx = $Hx}
                        }    
                    }
                }
                Write-Verbose("T({0},{1})" -f $Tx,$Ty)
                $TailHistory += ("({0},{1})" -f $Tx,$Ty)
            }# Number of spaces loop

        }#foreach move

        $UniqueTailHistory = ($TailHistory | select -Unique ).count
        Write-Host "Solution: $uniqueTailhistory"
    }#begin
}#function

Function D09_2{
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
                $data = Get-Content .\Day_09\Input_test.txt
                $data = Get-Content .\Day_09\Input_test2.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_09\Input.txt
            }
            Default {}
        }

        $TailHistory = @()
        $S= @()
        for ($i = 0;$i -le 9;$i++){
            $S += [PSCustomObject]@{
                P = $i
                X = 0
                Y = 0
            }
        }

        Foreach($move in $data)
        {
            $direction = $move.split(" ")[0]
            #convert direction
                


            [int]$spaces = $move.split(" ")[1]
            Write-verbose ("`t== {0} {1} ==" -f $direction,$spaces)
            
            for($mi = $spaces;$mi -gt 0;$mi--){
                write-verbose ("`t {0} {1} of {2}" -f $direction,$mi,$spaces)
                
                
                for($si = 0;$si -le 9;$si++){
                    #write-verbose("S{0}: " -f $s[$si].p)
                    if($si -eq 0){
                        #$s[$si].X = $s[$si].X + $dm.X
                        #$s[$si].Y = $s[$si].Y + $dm.Y
                        switch($direction){
                            "R" {$dm = [PSCustomObject]@{X = 1;Y = 0}}
                            "L" {$dm = [PSCustomObject]@{X = -1;Y = 0}}
                            "U" {$dm = [PSCustomObject]@{X = 0;Y = 1}}
                            "D" {$dm = [PSCustomObject]@{X = 0;Y = -1}}
                        }
                        
                    }
                    else{
                        $HX = $s[$si-1].X
                        $HY = $s[$si-1].Y
                        $TX = $s[$si].X
                        $TY = $s[$si].Y
                        $DX = $HX - $TX
                        $DY = $HY - $TY
                        
                        $DistStr = ("({0},{1})" -f $DX, $DY)
                        #Write-Verbose ("Distance: {0}" -f $DistStr)
                        
                        switch ($DistStr){
                            "(0,2)" {$dm = [PSCustomObject]@{X = 0;Y = 1}}
                            "(1,2)" {$dm = [PSCustomObject]@{X = 1;Y = 1}}
                            "(2,2)" {$dm = [PSCustomObject]@{X = 1;Y = 1}}
                            "(2,1)" {$dm = [PSCustomObject]@{X = 1;Y = 1}}
                            "(2,0)" {$dm = [PSCustomObject]@{X = 1;Y = 0}}
                            "(2,-1)" {$dm = [PSCustomObject]@{X = 1;Y = -1}}
                            "(2,-2)" {$dm = [PSCustomObject]@{X = 1;Y = -1}}
                            "(1,-2)" {$dm = [PSCustomObject]@{X = 1;Y = -1}}
                            "(0,-2)" {$dm = [PSCustomObject]@{X = 0;Y = -1}}
                            "(-1,-2)" {$dm = [PSCustomObject]@{X = -1;Y = -1}}
                            "(-2,-2)" {$dm = [PSCustomObject]@{X = -1;Y = -1}}
                            "(-2,-1)" {$dm = [PSCustomObject]@{X = -1;Y = -1}}
                            "(-2,0)" {$dm = [PSCustomObject]@{X = -1;Y = 0}}
                            "(-2,1)" {$dm = [PSCustomObject]@{X = -1;Y = 1}}
                            "(-2,2)" {$dm = [PSCustomObject]@{X = -1;Y = 1}}
                            "(-1,2)" {$dm = [PSCustomObject]@{X = -1;Y = 1}}
                            default {$dm = [PSCustomObject]@{X = 0;Y = 0}}
                        }

                    }#end else ($i =0)
                    $s[$si].X = $s[$si].X + $dm.X
                    $s[$si].Y = $s[$si].Y + $dm.Y
                    write-verbose ("S{0}: ({1},{2})" -f $s[$si].p,$s[$si].x, $s[$si].Y)
                    #iterate through each segment with Segment index ($si)
                    if($si -eq 9){
                        $TailPosition = ("({0},{1})" -f $s[$si].x,$s[$si].y)
                        #Write-Verbose ("Tail Position: {0}" -f $TailPosition)
                        $TailHistory += ("({0},{1})" -f $s[$si].x,$s[$si].y)
                    }
                }

            }#spaces moved
        }# Each Line in Data

        $UniqueTailHistory = ($TailHistory | select -Unique ).count
        Write-Host "Solution: $uniqueTailhistory"

    }#begin
}#function