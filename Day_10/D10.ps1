Function D10{
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
                #$data = Get-Content .\Day_10\Input_test.txt
                $data = Get-Content .\Day_10\Input_test2.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_10\Input.txt
            }
            Default {}
        }

        $i = 0
        $x = 1
        $h = @()
        $h += [PSCustomObject]@{
            Index = 0
            Start = 1
            Middle = 1
            End = 1
         }
        $i++ 
        foreach ($op in $data)
        {
            switch -wildcard ($op) {
                "noop" {
                    $start = $x
                    $middle = $x
                    $end = $x
                    $h += [PSCustomObject]@{
                       Index = $i
                       Start = $start
                       Middle = $middle
                       End = $end
                    }
                    $i++   
                }
                "addx*" {
                    $start = $x
                    $middle  = $x
                    $end = $x
                    $h += [PSCustomObject]@{
                        index = $i
                        Start = $start
                        Middle = $middle
                        End = $end
                    }
                    
                    $i++
                    $start = $x
                    $middle = $x
                    $x = $x + [int]$op.split(" ")[1]
                    $end = $x
                    $h += [PSCustomObject]@{
                        index = $i
                        Start = $start
                        Middle = $middle
                        End = $end
                    }
                    $i++    
                }
                Default {}
            }
        }

        $h
        $solution = 0
        $j = -20
        for($k = 1;$k -le 6;$k++){
            $j = $j + 40
            write-host ("{0}: {1} -- {2}" -f $j,$h[$j].middle,($h[$j].middle * $j))
            $solution = $solution + ($h[$j].middle * $j) 
        }
       
        write-host ("Solution: {0}" -f $solution)
    }
}


Function D10_2{
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
                Write-verbose "ParameterSet A"
                #$data = Get-Content .\Day_10\Input_test.txt
                $data = Get-Content .\Day_10\Input_test2.txt
            }
            B {
                Write-verbose "ParameterSet B"
                $data = Get-Content .\Day_10\Input.txt
            }
            Default {}
        }

        $i = 0
        $x = 1
        $h = @()
        $h += [PSCustomObject]@{
            Index = 0
            Start = 1
            Middle = 1
            End = 1
         }
        $i++ 
        foreach ($op in $data)
        {
            switch -wildcard ($op) {
                "noop" {
                    $start = $x
                    $middle = $x
                    $end = $x
                    $h += [PSCustomObject]@{
                       Index = $i
                       Start = $start
                       Middle = $middle
                       End = $end
                    }
                    $i++   
                }
                "addx*" {
                    $start = $x
                    $middle  = $x
                    $end = $x
                    $h += [PSCustomObject]@{
                        index = $i
                        Start = $start
                        Middle = $middle
                        End = $end
                    }
                    
                    $i++
                    $start = $x
                    $middle = $x
                    $x = $x + [int]$op.split(" ")[1]
                    $end = $x
                    $h += [PSCustomObject]@{
                        index = $i
                        Start = $start
                        Middle = $middle
                        End = $end
                    }
                    $i++    
                }
                Default {}
            }
        }

        $CRTx = 0
        [string]$crtstr = @()
        $h = $h[1..($h.count + 1)]
        $out = @()

        Foreach($cycle in $h){
            write-verbose ""
            Write-verbose ("Start Cycle`t{0}:" -f $cycle.index)
            $CRTx = ($cycle.index  -1)% 40
            #$sprite = (($cycle.Middle) -1, $cycle.Middle, ($cycle.middle)+1)
            $sprite= @()
            $spritestart = ($cycle.middle) -1
            $spritefinish = ($cycle.Middle) + 1
            #write-host ("sprite start: {0}  sprite finish: {1}" -f $spritestart,$spritefinish)
            $sprite += $cycle.Middle - 1
            $sprite += $cycle.Middle
            $sprite += $cycle.middle + 1
            $dissprstr = ""
            for($z = 0;$z -lt $spritestart;$z++){
                $dissprstr += "."
            }
            $dissprstr += "XXX"
            for($z = $spritefinish + 1;$z -le 39;$z++){
                $dissprstr += "."
            }
            #write-host ($dissprstr)
            if($crtx -in $sprite){$crtchar = "#"}else{$crtchar = "."}

            Write-verbose ("During Cycle`t{0}: CRT draws pixel ({1}) in position {2}" -f $cycle.index , $crtchar, $crtx)
            $crtstr = $crtstr + $crtchar
            write-verbose ("Current CRT row  : {0}" -f $crtstr -join"" )
            Write-verbose ("End of Cycle`t{0}:`t Register X is now {1}" -f $cycle.index,$cycle.end)
            
            #$sprite= @()
            $spritestart = ($cycle.end) -1
            $spritefinish = ($cycle.end) + 1
            #write-host ("sprite start: {0}  sprite finish: {1}" -f $spritestart,$spritefinish)
            #$sprite += $cycle.end - 1;$sprite
            #$sprite += $cycle.end; $sprite
            #$sprite += $cycle.end + 1;$sprite
            $dissprstr = ""
            for($z = 0;$z -lt $spritestart;$z++){
                $dissprstr += "."
            }
            $dissprstr += "XXX"
            for($z = $spritefinish + 1;$z -le 39;$z++){
                $dissprstr += "."
            }
            write-verbose ("Sprite position  : {0}" -f $dissprstr -join "")
            #write-host ("Cycle: {0}" -f $cycle.index)
            #write-host ("`tSprite: {0}" -f $cycle.middle)
            #write-host ("`tSprite: {0}" -f ($sprite -join ",") )
            #$sprite = @( [int]($cycle.middle) -1,[int]($cycle.Middle))
            #$CRTx = $cycle.index % 40
            #write-host ("`tCRT Position: {0}" -f $CRTx)
            #if($crtx -in $sprite){$crtstr += "#"}else{$crtstr += "."}
            #write-host ("{0}" -f $crtstr -join "" )
            if($crtx -eq 39){
                ($crtstr -join "")
                $crtstr = ""
            }
        }

    }
}