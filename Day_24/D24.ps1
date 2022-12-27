Function D24{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $Test1,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $Real
    )
    Begin{

        switch ($PsCmdlet.ParameterSetName) {
            A {
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_24\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_24\Input.txt
            }
            Default {}
        }
        
        Clear-Content .\day_24\map.txt

        #Field Hash
        $hash = @{}
        #Bliz Array
        $obj = @()
        [int] $y = 0
        $ID = 0
        foreach($line in $Data){
            $arr = $line.ToCharArray()
            $x = 0
            foreach($p in $arr){
                $coord = ("{0},{1}" -f $x,$y)
                $hash[$coord] = $p
                if($p -ne "."){
                    $obj += [PSCustomObject]@{
                        ID = $ID
                        Coord = $coord
                        Value = $p
                        X = $x
                        Y = $Y
                    }
                    $ID++
                }

                $x++
                }    
            $y++
            }
            
        

        #field built
        #objects identified and built   
        #Set initial position and move counter
        #$EHist = @()
        $E = "1,0"
        #$EHist += $E
        
        $lastrowind = $data.count -1
        $lastrow = $data[$lastrowind]
        $Exitx = $lastrow.indexof(".")
        $target = ("{0},{1}" -f $ExitX, $lastrowind)
        Write-Verbose ("Exit = {0}" -f $exit)

        $XMax = $data[0].length -1
        $Xmin = 0
        $YMax = $data.count -1
        $Ymin = 0
        Write-Verbose ("X: {0}..{1}" -f $Xmin, $XMax)
        Write-Verbose ("Y: {0}..{1}" -f $Ymin, $YMax)
        $w = $XMax - $xmin - 1
        $h = $YMax - $Ymin - 1
        #$b.value -join ("")

        #draw initial field
        #Draw-Field -F $hash -E $E
        write-host "The table is set"

        #$obj

        $InitState = Get-FutureState -obj $obj -N 0 -h $h -w $w

        $MoveInd = 0
        $FS = @()
        $FS += [PSCustomObject]@{
            Ind = $MoveInd
            Positions = @{("{0}"-f $e) = $false}
            FSobj = $InitState
        }
        #seed the first possible positions (with starting position)
        #$FS[0].positions[$E] = $false    
        #$FS[0].Postions.Add($E,$false)

        $Done = $false
        $legcounter = 1
        While ($legcounter -le 3){
            if($legcounter -gt 1){
                $temppoint = $E
                $E = $target
                $target = $temppoint
                $fs[$MoveInd].Positions = @{}
                $Fs[$moveind].Positions[$E] = $false
                $done = $false
                #Draw-Field -F $FS[$moveind].FSobj -E $FS[$moveind].Positions.keys
                Write-host "Turning around.."
            }

            While ($FS[$moveind].positions.count -gt 0 -and !$Done){
                $MoveInd++
                #if the next FS hasn't been created then create it.
                if($fs.count -ge $MoveInd){
                    $FS += [PSCustomObject]@{
                        Ind = $MoveInd
                        Positions = @{}
                        FSobj = Get-FutureState -obj $obj -N ($MoveInd) -h $h -w $w
                    }
                }

                foreach($pm in $FS[$MoveInd -1].Positions.keys){
                    $somemoves = Get-Moves -FutureStates $FS -curloc $pm -MoveNo ($MoveInd)
                    foreach($move in $somemoves){
                        if(!$FS[$MoveInd].positions.containskey($move)){
                            $FS[$MoveInd].positions[$move] = $false
                        }
                        if($move -eq $target){
                            $Done = $true
                        }
                    }
                }
                #draw the map for troubleshooting
                #Draw-Field -F $FS[$moveind].FSobj -E $FS[$moveind].Positions.keys
                Write-Host ("Move {0} Complete." -f $MoveInd)
                write-host ""
            }
            write-host ("Leg {0} Complete" -f $legcounter)

            $legcounter++

        }

        Write-Host ("Solution Part 2: {0}" -f $MoveInd)
        
    }#begin
}#function

Function Get-Moves {
    [cmdletbinding()]
    param(
        $FutureStates,
        $curloc,
        $MoveNo
    )
    Begin{
        $movelist = @()
        $bd = $FutureStates[$MoveNo].FSobj
        #$fbd = $FutureStates[$MoveNo + 1].FSobj

        $Ex = $curloc.split(",")[0]
        $Ey = $curloc.split(",")[1]
        $ME = "{0},{1}" -f ([int]$Ex + 1),($Ey)
        $MW = "{0},{1}" -f ([int]$Ex -1),($Ey)
        $MN = "{0},{1}" -f ($Ex),([int]$Ey -1)
        $MS = "{0},{1}" -f ($Ex),([int]$Ey +1)
    
        
        if((Test-InBounds $ME) -and !$bd.containskey($ME)){$movelist += $ME}
        if((Test-InBounds $MW) -and !$bd.containskey($MW)){$movelist += $MW}
        if((Test-InBounds $MN) -and !$bd.containskey($MN)){
            if($MN -ne "1,-1"){$movelist += $MN}}
        if((Test-InBounds $MS) -and !$bd.containskey($MS)){
            if($MS -ne "6,6"){$movelist += $MS}}
        #check if we can stay in place
        if(!$bd.containskey($curloc)){
            if($moveno -ne 1){$movelist += $curloc}}
        #Remove out of bounds 
        
        return $movelist
    }
}

Function Get-FutureState{
    [cmdletbinding()]
    param(
        $obj,
        [int]$N,
        $h,
        $w
    )
    Begin{
        $fh = @{}#future hash
        $dirs = ">","<","^","v"
        foreach($o in $obj){
            switch($o.value){
                "#" {
                    #position stays the same (its a wall)
                    $fc = $o.Coord
                    [string] $v = "#"
                    break
                }
                ">" {
                    #[int] $fx = ($o.x + $N) % $w
                    [int] $fx = (($o.x -1 + $n) % $w) + 1
                    [int] $fy = $o.Y
                    $fc = ("{0},{1}" -f $fx, $fy)
                    [string]$v = ">"
                }
                "<" {
                    #[int] $fx = ($w + (($o.x -$n) % $w)) % $w
                    #($pa + $m - ($n%$m))%$m
                    [int] $fx = ($o.x -1 + $w -($n%$w))%$w + 1 
                    #[int] $fx = ($o.x -1 ) + ($m -($n%5))%5 + 1 
                    [int] $fy = $o.Y
                    $fc = ("{0},{1}" -f $fx, $fy)
                    [string]$v = "<"
                }
                "^" {
                    [int] $fx = $o.X
                    #[int] $fy = ($h + (($o.y -1 -$n) % $h)) % $h
                    #[int] $fy = (($o.y -1 -$n) % $h) + 1
                    [int] $fy = ($o.y -1 + $h -($n%$h))%$h + 1 
                    $fc = ("{0},{1}" -f $fx, $fy)
                    [string]$v = "^"
                }
                "v" {
                    [int] $fx = $o.X
                    [int] $fy = (($o.y - 1 + $n ) % $h) + 1
                    $fc = ("{0},{1}" -f $fx, $fy)
                    [string]$v = "v"
                }
            }
            if($fh.containskey($fc)){
                if($fh[$fc] -in $dirs){
                    [int] $v = 2
                }
                else{
                    $v  = [int] $fh[$fc] + 1
                }
            }
            $fh[$fc] = $v
                
        }
        return $fh

    }#begin
} #function


Function Draw-Field {
    [cmdletbinding()]
    param(
    $F,
    [string[]]$E
    )
    Begin{

        $yp = $Ymin..$YMax
        $xp = $xmin..$XMax
        Add-content -Value "" -Path .\day_24\map.txt
        #Clear-Content .\Day_24\map.txt
        foreach($y in $yp){
            [string] $lstr = ""
            foreach($x in $xp){
                $tc = ("{0},{1}" -f $x, $y)
                if($f.ContainsKey($tc)){
                    $ch = $f[$tc]
                }
                else{
                    if($tc -in $E){
                        $ch = "E"
                    }
                    Else{
                    #No entry so display .
                    $ch = "."
                    }
                }
                
                $lstr += $ch
            }
        Add-Content -Value $lstr -Path .\Day_24\map.txt
        }

    }#begin
}#function

function Get-West {
    [cmdletbinding()]
    param(
        [int]$P, #initial position (not offset)
        [int]$N, #number of moves to the west
        [int]$m # mod of the system (inner dimension) east / west 
    )
    $pa = $p -1
    $west = ($pa + $m - ($n%$m))%$m
    $west = $west + 1 #readjust for Boarder
    $west
}

Function Test-InBounds {
    [cmdletbinding()]
    param(
        $TCoord

    )
    Begin{
        $xmin = 0
        $XMax = 121
        $ymin = 0
        $YMax = 26
        
        [int]$tcx = $TCoord.split(",")[0]
        [int]$tcy = $TCoord.split(",")[1]
        $Inbounds = $true
        if($tcx -lt $xmin){$Inbounds = $false}
        if($tcx -gt $XMax){$Inbounds = $false}
        if($tcy -lt $ymin){$Inbounds = $false}
        if($tcy -gt $YMax){$Inbounds = $false}
        return $Inbounds
    }
}


Function Get-PositionDetails {
    [cmdletbinding()]
    param(
        $Boardobj,
        $N,
        $coord,
        $h = 4,
        $w = 6
    )
    Begin{
        $fu = Get-FutureState -obj $Boardobj -N $n 
        # Not done - questioning its worth now..

    }
}