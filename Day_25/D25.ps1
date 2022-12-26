Function D25{
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
                $data = Get-Content .\Day_25\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_25\Input.txt
            }
            Default {}
        }
        $runningtotal = 0
        #$data = $data | select -first 2
        #$data = $data | select -first 2
        
        $counter = 0
        $subhist = @()
        #$badlist = @()
        # foreach($item in $data){
        #     $counter ++
        #     $snafu0 = $item
        #     write-verbose ("`nItem #: {0}" -f $counter)
        #     Write-Verbose ("Snafu: {0}" -f $Item)

        #     $dec = Convert-FromSnafu -Snafu $item
        #     Write-Verbose ("Dec  : {0}" -f $dec)

        #     $snafu1 = Convert-toSnafu -number $dec
        #     write-verbose ("snafu: {0}" -f $snafu1)
        #     if($snafu0 -eq $snafu1){Write-Verbose "  = Good"}
        #     else{
        #         write-verbose ("**** Mismatch *****")
        #         $badlist += ($counter -1)
            
        #     }
        # }
        # $badlist
        
        
        foreach($item in $data){
            $counter++
            [double]$runningtotal +=  (Convert-FromSnafu -Snafu $item)
            
            #$sub = [bigint] (Convert-FromSnafu -Snafu $item)
            #$sub = (Convert-FromSnafu -Snafu $item)
            
            $subhist += $sub
            #Write-Verbose ("{0} : {1} --> {2}" -f $counter, $item, $sub)
            #$nt = $runningtotal + $sub
            #Write-Verbose ("{0}: {1} + {2} = {3}" -f $counter,$runningtotal, $sub, $nt )
            
            #$runningtotal = $nt
        }

        #foreach($item in $subhist){
        #    $runningtotal = $runningtotal + $item           
        #}
        Write-Verbose ("Total in decimal: {0}" -f $runningtotal)
        $inSnafu = Convert-toSnafu -number $runningtotal 
        Write-Verbose ("Solution Part One: {0}" -f $inSnafu)  
    }
}

function Convert-FromSnafu {
    [cmdletbinding()]
    param(
        [string] $Snafu 
    )

    begin{

        $chars = $snafu.ToCharArray()
        
        $total = 0
        for($i = 0; $i -lt $chars.count;$i++){
            switch($chars[$i]){
                "2" {[int]$v = 2;Break}
                "1" {[int]$v = 1;Break}
                "0" {[int]$v = 0;Break}
                "-" {[int]$v = -1;Break}
                "=" {[int]$v = -2;Break}
            }
            $sub = [bigint]::Pow(5,($chars.count - 1 - $i)) * $v
            $total = $total + $sub
        }
        $total
    }
}
        

Function Convert-toSnafu{
    [cmdletbinding()]
    param(
        [bigint] $number
    )
    begin{
        $q = @{}
        $r = @{}
        $sr = @{}
        $ind = -1
        [bigint]$tn = $number
        while ($tn -gt 0){
            $ind++
            [double]$F = $tn/5
            $q[$ind] = [double][math]::Truncate($f)
            #$ir = $tn % 5
            #$tr  = (($ir + 2)%5)-2
            $r[$ind] = $tn % 5
            #$sr[$ind] += (( ($tn %5) + 2)%5)-2
            #$sr[$ind] = (($sr[$ind] + 2) % 5) -2
            
            #if($sr[$ind] -lt 0){
            #    $sr[$ind + 1] += 1
            #}
            
            #Write-Verbose ("{0} / {1} -> {2} R {3}" -f $tn,5,$q[$ind],$sr[$ind])
            $tn = $q[$ind]
        }
        $outstrarr = @()
        for($i = 0 ;$i -lt $r.count ; $i++){
            switch($r[$i]){
                "3" {
                    $outstrarr += "="
                    $r[$i+1] = $r[$i +1] + 1
                    break
                }
                "4" {
                    $outstrarr += "-"
                    $r[$i+1] = $r[$i+1] + 1
                    break
                }
                "5"  {
                    $outstrarr += "0"
                    $r[$i+1] = $r[$i+1] + 1
                    break
                }
                "0"  {
                    $outstrarr += "0"
                    break
                }
                "1"  {
                    $outstrarr += "1"
                    break
                }
                "2"  {
                    $outstrarr += "2"
                    break
                }
            }
            #$outstrarr += $outstr
        }
        $outstr = @()
        for($i = $r.count -1; $i -ge 0;$i--){
             $outstr += $outstrarr[$i] 
        }
        $outstr -join ("")
    }
}
Function Convert-toSnafuold{
    [cmdletbinding()]
    param(
        [bigint] $number
    )
    begin{
        $q = @{}
        $r = @{}
        $sr = @{}
        $ind = -1
        [bigint]$tn = $number
        while ($tn -gt 0){
            $ind++
            [double]$F = $tn/5
            $q[$ind] = [double][math]::Truncate($f)
            #$ir = $tn % 5
            #$tr  = (($ir + 2)%5)-2
            $r[$ind] = $tn % 5
            $sr[$ind] += (( ($tn %5) + 2)%5)-2
            #$sr[$ind] = (($sr[$ind] + 2) % 5) -2
            
            #if($sr[$ind] -lt 0){
            #    $sr[$ind + 1] += 1
            #}
            Write-Verbose ("{0} / {1} -> {2} R {3}" -f $tn,5,$q[$ind],$sr[$ind])
            $tn = $q[$ind]
        }
        if($sr.ContainsKey($ind+1)){Write-Verbose("{0} / {1} -> {2} R {3}" -f "",5,$q[$ind+1],$sr[$ind+1])}
        [string] $outstr = ""
        for($i = $sr.count -1; $i -ge 0;$i--){
            switch($sr[$i]){
                "-2" {
                    $outstr += "="
                    #$sr[$i-1] = $sr[$i -1] + 1
                    break
                }
                "-1" {
                    $outstr += "-"
                    #$sr[$i-1] = $sr[$i-1] + 1
                    break
                }
                "0"  {
                    $outstr += "0"
                    break
                }
                "1"  {
                    $outstr += "1"
                    break
                }
                "2"  {
                    $outstr += "2"
                    break
                }
            }

            
        }
        $outstr
    }
}

function Validator {
    [cmdletbinding()]
    param()
    Begin{
        $bl = @()
        $bli = 0
        for($i = 0; $i -le 100;$i++){
            $dec0 = $i
            $Snaf0 = Convert-toSnafu -number $dec0
            $dec1 = Convert-FromSnafu -Snafu $snaf0
            $snaf1 = Convert-toSnafu -number $dec1

            if( ($dec0 -eq $dec1) -and ($Snaf0 -eq $snaf1)){
                Write-Verbose "All Good"
            }
            Else{
                $bl += [PSCustomObject]@{
                    Ind = $bli
                    Dec = $dec0
                    Sn0 = $Snaf0
                    Dec1 = $dec1
                    Sn1 = $snaf1
                }
            }
        }
    $bl
    }
}