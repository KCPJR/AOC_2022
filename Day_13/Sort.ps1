
Function Sort-Custom {
    [CmdletBinding()]
    Param(
        $list
    )
#$list= [Collections.Generic.List[string]]::new()

#$list.add(6)
#$list.add(2)
#$list.add(7)
#$list.add(4)
#$list.add(4)
#$list


for($j = 1; $j -lt $list.count;$j++){
    write-verbose("Ordering Element {0}" -f $j)
    $key = $list[$j]
    $i = $j -1
    
    #if(test-order -left $list[$i] -right $key){$comp = $true}else{$comp = $false}
    #Write-host ("{0} > {1} : {2}" -f $list[$i],$key,$comp)
    While($i -ge 0 -and (test-order -left $list[$i] -right $key)){
        $list[$i+1] = $list[$i]
        $i--
    }
    $list[$i+1] = $key
    #write-host ("swap complete")
    #Write-host ("List: {0}" -f ($list -join ","))
}

$list
}