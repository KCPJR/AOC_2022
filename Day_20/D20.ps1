Function D20{
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


        $origdata = $data
        #Write-host ("Index Max: {0}" -f ($origdata.count -1))
        [System.Collections.Generic.List[int]] $list = @($data)
        
        #$curitem = $origdata[1]
        #Write-Verbose ("Current Item: {0}" -f $curitem)
        #$indxcuritem = $list.IndexOf($curitem)
        #write-verbose ("Index of Current Item: {0}" -f $indxcuritem)

        #$topi = $origdata.count -1
        
        #$target = $topi + ($curitem % $topi)
        $i = 0
        Foreach($curitem in $origdata){
           $i++
            $list =  Shift-List -tlist $list -item $curitem -positions $curitem
        }
        #Write-host ("Mmmmm.....")
        $poi = $list.IndexOf(0)
        #write-host ("Position of 0: {0}" -f $poi)
        $v1 = 1000
        $v2 = 2000
        $v3 = 3000
        $poiA = ($poi + 1000) % ($origdata.count)
        $poib = ($poi + 2000) % ($origdata.count)
        $poic = ($poi + 3000) % ($origdata.count)
        Write-host ("Position of 0: {0}"-f ($list.IndexOf(0)))
        Write-host ("Value at {0}th: {1}" -f $v1,$list[$poiA])
        Write-host ("Value at {0}th: {1}" -f $v2,$list[$poib])
        Write-host ("Value at {0}th: {1}" -f $v3,$list[$poic])
        
        $sol = $list[$poiA] + $list[$poib] + $list[$poic]
        Write-host ("Solution Part 1: {0}" -f $sol) 
        $list
    }
}

Function Shift-List {
    [cmdletbinding()]
    param(
        [System.Collections.Generic.List[int]] $tlist,
        [int]$item,
        [int]$positions
    )
    Begin{
        
        $adjustment = 0
        $curposition = $tlist.IndexOf($item)
        $itemcount = $tlist.Count
        
        #Write-Verbose ("Item Count: {0}" -f $itemcount)
        #Write-host ("Item: {0}  current position: {1}" -f $item, $curposition)
        $move = ((($positions % $itemcount)))
        #write-verbose ("  Move {0}" -f ($move) )
        
        switch($move){
            {$_ -lt 0} {
                #Write-Verbose "Negative Movement"
                $insertat = ($itemcount + $curposition + $move ) % $itemcount
                if($insertat -eq 0){$insertat = (($itemcount + $curposition + $move -1) % $itemcount)+1}
            }
            {$_ -eq 0} {
                #Write-Verbose "No movement"
                $insertat = $curposition
            }
            {$_ -gt 0} {
                #Write-Verbose "Positve Movement"
                $insertat = ($curposition + $move + 1) % $itemcount
            }
        }

        #$insertat = $curposition + $move + 1
        Write-Verbose ("Item:{0}  current position:{1} Move:{2} InsertAt:{3}" -f $item, $curposition,$move,$insertat)
        
        #write-host ("Original: {0}" -f ($tlist -join (", ")))
        $tlist.insert($insertat,$item)
        
        if($insertat -gt $curposition){
            # write-host ("Trap1")
            $tlist.removeat($curposition)
        }
        else{
            $tlist.removeat($curposition + 1)
           # write-host ("trap 2")
        }
        
        #Write-verbose ("Modified: {0}" -f ($tlist -join (", ")))
        return $tlist

        #$topi  = $tlist.count -1
        
        #$target = ($curposition + ($positions % $itemcount)) % $itemcount
        #$targeta  = $curposition + ($positions % $itemcount)
        
        
        #if($targeta -gt $topi){
        #    write-host "Looper"
        #    $adjustment = -1
        #}
        #if($target -lt 0){$insertat = (($target + $topi) % $topi) + 1}
        #elseif($target -gt 0){$insertat = (($target + $topi) % $topi) +1}
        
        #switch($target){
        #    {$_ -lt 0} {$insertat = (($target + $itemcount) % $itemcount) + 1 }
        #    {$_ -eq 0} {$insertat = $itemcount + 1}
        #    {$_ -gt 0} {$insertat = (($target + $itemcount) % $itemcount) +1 + $adjustment}
        #}


        #if($target -gt $curposition){$insertat = $target +1;write-host "Trap a"}
        #if($target -lt $curposition){$insertat = $target;write-host "Trap b"}
        
        
        #$insertat = ($insertat + $topi) % $topi
        #write-host("T:{0} Insert at {1}" -f $target, $insertat)
        #Write-host ("Item: {0}  current position: {1}" -f $item, $curposition)
        #write-host ("Target: {0}" -f $insertat)
        #Write-Host
        #write-host ("Original: {0}" -f ($tlist -join (", ")))
        #$tlist.insert($insertat,$item)
        #Write-host ("Modified: {0}" -f ($tlist -join (", ")))
        
        #if($insertat -gt $curposition){
            #write-host ("Trap1")
            #$tlist.removeat($curposition)
        #}
        #else{
            #$tlist.removeat($curposition + 1)
            #write-host ("trap 2")
        #}
        #Write-host ("Modified: {0}" -f ($tlist -join (", ")))
        #return $tlist
    }
}