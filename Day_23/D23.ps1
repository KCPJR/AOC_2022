Function D23{
    [CmdletBinding(DefaultParameterSetName = 'A')]
    Param(
        [Parameter(ParameterSetName = "A")]
        [Switch] $Test1,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $Test2,

        # Parameter help description
        [Parameter(ParameterSetName = "C")]
        [Switch]
        $Real

    )
    Begin{

        switch ($PsCmdlet.ParameterSetName) {
            A {
                Write-host "ParameterSet A"
                $data = Get-Content .\Day_23\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_23\Input_test2.txt
            }
            C {
                Write-host "ParameterSet C"
                $data = Get-Content .\Day_23\Input.txt
            }
            Default {}
        }

        #The field
        $f = @{}
        
        #look List 
        #[system.collections.generic.list[str]] $LookList = @("North","South","West","East")
        [System.Collections.Generic.List[string]] $LookList = @("North","South","West","East")
        #Elves
        $Elves = @()
        $Eid = 0
        $ty = 0
        $ymax = 0
        foreach($line in $data){
            $lca = $line.ToCharArray()
            
            $tx = 0
            $xmax = $lca.Count
            if($ymax -lt $ty){$ymax = $ty}
            foreach($s in $lca){
                
                if($s -eq "#"){
                    $tc = ("{0},{1}" -f $tx,$ty)
                    $f[$tc] = $Eid
                    
                    $Elves += [PSCustomObject]@{
                        ID= $Eid
                        coord = $tc
                        X = $tx
                        Y = $ty
                        #NextDir = 0
                        #Phase = "Look"
                    }
                    $Eid++
                }
                $tx++
            }

            $ty++
            
        }
        $xmax--
        
        #Draw-Field -Elves $Elves -f $f -maxx $xmax -maxy $ymax

        #Start of the Turn Cycle
        $maxrounds = 100000000
        $roundcounter = 1
        $movesmade = -1
        while ( ($roundcounter -le $maxrounds) -and $movesmade -ne 0){

                Write-host ("Round: {0}" -f $roundcounter)
                $ProposedHash = @{}
                Foreach($Elv in $Elves){
                    $pm = StayorGo -f $f -elf $Elv
                    if($elv.coord -ne $pm){
                    $ProposedHash[$Elv.ID] = $pm}
                    #only adds to proposed moves if its not staying in place - should speed up things a little.
                    #should I stay or should I go?
                    
                }
                #Write-host ("Wait a minute")

                #Prevent elves from trying to move to the same space
                $Dups = $ProposedHash.Values | group | ? {$_.count -gt 1}|select -ExpandProperty Name
                $removelist = @()
                foreach($key in $ProposedHash.Keys){
                    if($ProposedHash[$key] -in $Dups){$removelist += $key}
                }
                foreach($rk in $removelist){
                    $ProposedHash.Remove($rk)
                }
                
                #Write-host "Proposed moves have been deduped"
                $movesmade = $ProposedHash.count
                write-host (" Moves made: {0}" -f $movesmade)

                foreach($mk in $ProposedHash.keys){
                    #Update Elf
                    $tc = $ProposedHash[$mk]
                    $oldcoord = $Elves[$mk].coord
                    $Elves[$mk].coord = $tc
                    $Elves[$mk].X = $tc.split(",")[0]
                    $elves[$mk].y = $tc.split(",")[1]

                    #update field - remove old
                    $f.remove($oldcoord)
                    #update field - add new position
                    $f[$tc] = $mk
                }
                #write-host "everyone should be in new spot"
                #update look list order
                $td = $LookList[0]
                $looklist.RemoveAt(0)
                $looklist.add($td)
                #write-host "That should end the round"

                #Draw-Field -Elves $Elves -f $f -maxx $xmax -maxy $ymax
                $roundcounter++
    }#bigloop
    #Write-host "Big Loop Done"
    $roundcounter--
    #Calculate the score
        $mox = $elves | Measure-Object -Property X -AllStats
        $moy = $elves | Measure-Object -Property Y -AllStats
        $maxxc = $mox.Maximum
        $minxc = $mox.Minimum
        $minyc = $moy.Minimum
        $maxyc = $moy.Maximum

        Write-host ("({0},{1})" -f $minxc,$minyc)
        Write-host ("({0},{1})" -f $maxxc, $maxyc)
        $DX = ([int]$maxxc - [int]$minxc) + 1
        $DY = ([int]$maxyc - [int]$minyc) + 1
        write-host ("DX = {0}..{1} = {2}" -f $minxc, $maxxc, $DX)
        write-host ("DY = {0}..{1} = {2}" -f $minyc, $maxyc, $DY)
        $area = [Int32]$dx  * [int32]$dy 
        write-host ("Area: {0}" -f $area)
        $sol = $area - [int]$elves.count
        write-host ("Solution: {0}" -f $sol)
        Write-host ("Rounds Taken: {0}" -f $roundcounter)
    }#begin
}#function



Function StayorGo {
    [cmdletbinding()]
    param(
        $f,
        $elf
    )
    Begin{
        
        $N = $false
        $NE = $false
        $E  = $false
        $SE = $false
        $S = $false
        $SW = $false
        $W = $false
        $NW = $false
        
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x), ($elf.y - 1)))){$N = $true}
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x + 1), ([int]$elf.y - 1)))){$NE = $true}
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x + 1), ([int]$elf.y)))){$E = $true}
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x + 1), ([int]$elf.y + 1)))){$SE = $true}
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x), ([int]$elf.y + 1)))){$S = $true}
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x - 1), ([int]$elf.y + 1)))){$SW = $true}
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x - 1), ([int]$elf.y)))){$W = $true}
        if($f.ContainsKey(("{0},{1}" -f ([int]$elf.x - 1), ([int]$elf.y - 1)))){$NW = $true}
        
        If($N -or $NE -or $E -or $SE -or $S -or $SW -or $W -or $NW){
            #Need to Move
            $found = $false
            $searchdirindex = 0
            while(!$found -and ($searchdirindex -le 3)){
                switch($LookList[$searchdirindex]){
                    "North" {
                        if($NW -or $N -or $NE ){
                            #someone there - can't go there
                            Break
                        }
                        Else{
                            $Proposed = ("{0},{1}" -f ([int]$elf.x), ([int]$elf.y - 1))
                            $found = $true
                            Break
                        }
                    }
                    "South" {
                        if($SW -or $S -or $SE){
                            #someone is there - can't move there
                            break
                        }
                        else{
                            $Proposed = ("{0},{1}" -f ([int]$elf.x), ([int]$elf.y + 1))
                            $found = $true
                            Break
                        }
                    }
                    "West" {
                        if($SW -or $W -or $NW){
                            #someone is there - can't go there
                            break
                        }
                        else{
                            $Proposed = ("{0},{1}" -f ([int]$elf.x - 1), ([int]$elf.y))
                            $found = $true
                            Break
                        }
                    }
                    "East" {
                        if($NE -or $E -or $SE){
                            #someone is there - can't go there
                        }
                        else{
                            $Proposed = ("{0},{1}" -f ([int]$elf.x + 1), ([int]$elf.y))
                            $found = $true
                            Break
                        }
                    }

                }
                $searchdirindex++
            }
            if(!$found){
                #no safe move found - Don't move.
                $Proposed = $elf.coord
            }
        }
        Else{
            #No one around - stay put
            $Proposed = $elf.coord
        }
        
    Return $Proposed
    }

}

Function Draw-Field {
    [cmdletbinding()]
    param(
        $Elves,
        $f,
        [int] $maxx,
        [int] $maxy

    )
    Begin{
        #get max min values
        
        $minx = 0
        $miny = 0

        $mox = $elves | Measure-Object -Property X -AllStats
        $moy = $elves | Measure-Object -Property Y -AllStats
        $maxxc = $mox.Maximum
        $minxc = $mox.Minimum
        $minyc = $moy.Minimum
        $maxyc = $moy.Maximum

        if($minx -ge $minxc){$minx = $minxc}
        if($miny -ge $minyc){$miny = $minyc}
        if($maxx -lt $maxxc){$maxx = [int]$maxxc }
        if($maxy -lt $maxyc){$maxy = [int]$maxyc }
        
        Clear-Content .\Day_23\map.txt  
        for($y = $miny;$y -le $maxy;$y++){
            $linestr = ""
            for($x = $minx;$x -le $maxx;$x++){
                if($f.ContainsKey(("{0},{1}" -f $x,$y))){
                    $linestr += "#"
                }
                else{
                    $linestr += "."
                }
            }
        Add-Content -Value $linestr -Path .\Day_23\Map.txt

        }
    }
}