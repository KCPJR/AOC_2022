Function D20v2{
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
                $data = Get-Content .\Day_20\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_20\Input.txt
            }
            Default {}
        }

        $List = New-Object System.Collections.Generic.List[object]
        $i = 0
        foreach($line in $data){
            $list.add([PSCustomObject]@{
                OrigInd = $i
                Value = $line
            })
            $i++
        }        

        for($i = 0;$i -lt $list.count;$i++){
            #$list[$i]
            $ind = $list.OrigInd.indexof($i)
            $pos = $list[$ind].Value
#            Write-Verbose ("Original Index:{0} Position:{1} Value: {2}" -f $i, $ind, $list[$ind].Value )
            $list = Shift-ObjList -tlist $list -itemind $ind -positions $pos 

        }#orig item loop
        $poi = $list.value.IndexOf(0)
#        Write-host ("Position of 0: {0}"-f ($list.Value.IndexOf(0)))


        $poiA = $list[($poi + 1000) % ($list.count)].value
        $poib = $list[($poi + 2000) % ($list.count)].value
        $poic = $list[($poi + 3000) % ($list.count)].value
        

        Write-host ("Value at {0} th: {1}" -f 1000,$poiA)
        Write-host ("Value at {0} th: {1}" -f 2000,$poib)
        Write-host ("Value at {0} th: {1}" -f 3000,$poic)
        
        $sol = [int]$poia + [int]$poib + [int]$poic
        Write-host ("Solution Part 1: {0}" -f $sol) 

    }#Begin
}#Function

Function D20v2B{
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
                $data = Get-Content .\Day_20\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_20\Input.txt
            }
            Default {}
        }

        $xfactor = 811589153
        #$xfactor = 1

        Write-Verbose ("Factor: {0}" -f $xfactor)
        $List = New-Object System.Collections.Generic.List[object]
        
        $i = 0
        foreach($line in $data){
            $list.add([PSCustomObject]@{
                OrigInd = $i
                Value = $xfactor * $line
            })
            $i++
        }        
#        Write-Verbose ("Orig: {0}" -f ($list.value -join (", ")))

    for($j = 1;$j -le 10;$j++){
        for($i = 0;$i -lt $list.count;$i++){
            #$list[$i]
            $ind = $list.OrigInd.indexof($i)
            $pos = $list[$ind].Value
#            Write-Verbose ("Original Index:{0} Position:{1} Value: {2}" -f $i, $ind, $list[$ind].Value )
            
            $shortenedpositionshift = ($list[$ind].value) % ($list.count -1 )
            $list = Shift-ObjList -tlist $list -itemind $ind -positions $shortenedpositionshift 

        }#orig item loop
#        Write-host("{0}" -f ($list.value -join(", ")))

    }#ten mixes
        $poi = $list.value.IndexOf(0)
#        Write-host ("Position of 0: {0}"-f ($list.Value.IndexOf(0)))



        $poiA = $list[($poi + 1000) % ($list.count)].value
        $poib = $list[($poi + 2000) % ($list.count)].value
        $poic = $list[($poi + 3000) % ($list.count)].value
        

        Write-host ("Value at {0} th: {1}" -f 1000,$poiA)
        Write-host ("Value at {0} th: {1}" -f 2000,$poib)
        Write-host ("Value at {0} th: {1}" -f 3000,$poic)
        
        $sol = [long]$poia + [long]$poib + [long]$poic
        Write-host ("Solution Part 2: {0}" -f $sol) 
        Write-host ("hmmmm")
    }#Begin
}#Function


Function Shift-ObjList {
    [cmdletbinding()]
    param(
        [System.Collections.Generic.List[object]] $tlist,
        [int32]$itemind,
        [int32]$positions
        
    )
    Begin{
        $val = $tlist[$itemind].Value
#        Write-Verbose ("  ItemInd: {0}  Val:{1}" -f $itemind,$val)
#        Write-Verbose ("    Orig: {0}" -f ($tlist.Value -join (", ")) )
        if($true){
            $tempobj = [PSCustomObject]@{
                OrigInd = $tlist[$itemind].OrigInd
                Value = $tlist[$itemind].Value
            }
            [void]$tlist.removeat($itemind)
#            Write-Verbose ("    Mod1: {0}" -f ($tlist.Value -join (", ")) )
            $itemcount = $tlist.Count
            $move = ($positions % $itemcount)
            $moveto = ( ($itemcount + $itemind + $move ) % $itemcount)
#            Write-Verbose ("  Move: {0} Moveto {1}" -f $move,$moveto)
            if($moveto -eq 0){$tlist.add($tempobj)}
            else{$tlist.insert($moveto,$tempobj)}
            
#            Write-Verbose ("    : {0}" -f ($tlist.Value -join (", ")) )
            return $tlist
        }
    }
}


Function Shift {
    [cmdletbinding()]
    param(
        [System.Collections.Generic.List[int]] $tlist,
        [int]$itemind,
        [int]$positions
        
    )
    Begin{
        $val = $tlist[$itemind]
        Write-Verbose ("ItemInd: {0}  Val:{1}" -f $itemind,$val)
        Write-Verbose ("Orig: {0}" -f ($tlist -join (", ")) )
        if($true){
            [void]$tlist.removeat($itemind)
            Write-Verbose ("Mod1: {0}" -f ($tlist -join (", ")) )
            $itemcount = $tlist.Count
            $move = ($positions % $itemcount)
            $moveto = ( ($itemcount + $itemind + $move ) % $itemcount)
            Write-Verbose (" Move: {0} Moveto {1}" -f $move,$moveto)
            $tlist.insert($moveto,$val)
            Write-Verbose ("Mod2: {0}" -f ($tlist -join (", ")) )
        }
    }
}