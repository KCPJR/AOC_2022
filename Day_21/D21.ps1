Function D21{
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
                $data = Get-Content .\Day_21\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_21\Input.txt
            }
            Default {}
        }

        $h = @{}
        foreach($line in $data){
        #$line = $data[0]
            $def = $line.Substring(0,($line.indexof(":")))
            #write-host ("Def: {0}" -f $def)
            $length = $line.Length
            #    write-host ("Lenght:{0}" -f $length)
            $Col = $line.IndexOf(":")
            #    write-host ("Col: {0}" -f $Col)
            $val = $line.Substring($col +2)
                #$val = $line.Substring(($col+ 1),($length - $col))
            #write-host ("Val: {0}" -f $val)
            $h[$def] = $val
        }
        #Write-host("*********")
        #$h
        $vars = @{}
        $expr = @{}
        Foreach($key in $h.keys){
        #    write-host ("Key: {0}  <-> Value: {1}" -f $key, $h[$key])
            if($h[$key].split(" ").count -gt 1 ){
        #        Write-host (" Expression")
                $expr[$key] = $h[$key]
            }
            Else{
                $vars[$key] = $h[$key]
            }
        }
        #Write-host ("****Vars****")
        #$vars
        #write-host ("****Expr****")
        #$expr
    
        $i = 0
        [system.Collections.Generic.List[string]] $keylist = @($expr.Keys)
        $rootfound = $false
        While ($keylist.count -gt 0 -or !$rootfound){
            $exprk = $keylist[$i]
            #Foreach($exprk in $expr.keys){
            $parts = $expr[$exprk].split(" ")
            $X = $parts[0]
            $op = $parts[1]
            $Y = $parts[2]
            #write-host ("Key: {0}  <-> Value: {1}" -f $exprk, $expr[$exprk])
            if($vars.ContainsKey($X) -and $vars.ContainsKey($Y)){
                #Write-host (" Both bits")
                switch($op){
                    "*" {
                        #Write-Host "  Multiplication"
                        [long]$temp = [long]$vars[$x] * [long]$vars[$y]
                        #write-host ("`t{0}({1}) * {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                        $vars[$exprk] = $temp
                        [void]$expr.remove($exprk)
                        [void]$keylist.remove($exprk)
                    }
                    "+" {
                        #Write-host "  Addition"
                        [long]$temp = [long]$Vars[$X] + [long]$vars[$y]
                        #write-host ("`t{0}({1}) + {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                        $vars[$exprk] = $temp
                        [void]$expr.remove($exprk)
                        [void]$keylist.remove($exprk)
                    }
                    "-" {
                        #Write-Host "  Subtraction"
                        [long]$temp = $Vars[$X] - $vars[$y]
                        #write-host ("`t{0}({1}) - {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                        $vars[$exprk] = $temp
                        [void]$expr.remove($exprk)
                        [void]$keylist.remove($exprk)
                    }
                    "/" {
                        #write-host "  Division"
                        [long]$temp = $Vars[$X] / $vars[$y]
                        #write-host ("`t{0}({1}) / {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                        $vars[$exprk] = $temp
                        [void]$expr.remove($exprk)
                        [void]$keylist.remove($exprk)
                    }
                    default {
                        Write-host "***UNKNOWN OP***"
                        Exit
                }

                }#switch
            
            }
            Else{
                #Write-host (" Don't have all the info yet")
                $temphashitemkey = $exprk
                $temphashvalue = $expr[$exprk]
                [void]$keylist.remove($exprk)
                [void]$keylist.add($exprk)
            }
            
            if($vars.ContainsKey("root")){$rootfound = $true}
                
                #Write-host ("****Vars****")
                #$vars
                #write-host ("****Expr****")
                #$expr
                
            }
            write-host ("Root: {0} " -f $vars["root"])
        }
    
    
    }


    Function D21B{
        [CmdletBinding(DefaultParameterSetName = 'A')]
        Param(
            [Parameter(ParameterSetName = "A")]
            [Switch] $A,
    
            # Parameter help description
            [Parameter(ParameterSetName = "B")]
            [Switch]
            $B,
            $guess
        )
        Begin{
    
            switch ($PsCmdlet.ParameterSetName) {
                A {
                    #Write-host "ParameterSet A"
                    $data = Get-Content .\Day_21\Input_test.txt
                }
                B {
                    #Write-host "ParameterSet B"
                    $data = Get-Content .\Day_21\Input.txt
                }
                Default {}
            }
    
            $h = @{}
            foreach($line in $data){
            #$line = $data[0]
                $def = $line.Substring(0,($line.indexof(":")))
                #write-host ("Def: {0}" -f $def)
                $length = $line.Length
                #    write-host ("Lenght:{0}" -f $length)
                $Col = $line.IndexOf(":")
                #    write-host ("Col: {0}" -f $Col)
                $val = $line.Substring($col +2)
                    #$val = $line.Substring(($col+ 1),($length - $col))
                #write-host ("Val: {0}" -f $val)
                $h[$def] = $val
            }
            #Write-host("*********")
            #$h
            $vars = @{}
            $expr = @{}
            Foreach($key in $h.keys){
            #    write-host ("Key: {0}  <-> Value: {1}" -f $key, $h[$key])
                if($h[$key].split(" ").count -gt 1 ){
            #        Write-host (" Expression")
                    $expr[$key] = $h[$key]
                }
                Else{
                    $vars[$key] = $h[$key]
                }
            }
            #Write-host ("****Vars****")
            #$vars
            #write-host ("****Expr****")
            #$expr
            #$guess = 0
            $vars["humn"] = $guess
            $rot = ("{0} = {1}" -f ($h["root"].split(" ")[0]),($h["root"].split(" ")[2]))
            $expr["root"] = $rot
            $i = 0
            [system.Collections.Generic.List[string]] $keylist = @($expr.Keys)
            $rootfound = $false
            While ($keylist.count -gt 0 -or !$rootfound){
                $exprk = $keylist[$i]
                #Foreach($exprk in $expr.keys){
                $parts = $expr[$exprk].split(" ")
                $X = $parts[0]
                $op = $parts[1]
                $Y = $parts[2]
                #write-host ("Key: {0}  <-> Value: {1}" -f $exprk, $expr[$exprk])
                if($vars.ContainsKey($X) -and $vars.ContainsKey($Y)){
                    #Write-host (" Both bits")
                    switch($op){
                        "=" {
                            #Write-Host "  Equality Check"
                            if([double]$vars[$x] -eq [double]$vars[$y]){
                                Write-Host "Bingo!" 
                                $sol2 = $vars["humn"]
                                write-host("Solution Part 2: {0}" -f $sol2)
                                $vars[$exprk] = $TRUE
                                [void]$expr.remove($exprk)
                                [void]$keylist.remove($exprk)
                            }
                            else {
                                $vars[$exprk] = $false
                                [void]$expr.remove($exprk)
                                [void]$keylist.remove($exprk)
                            }
                        }
                        "*" {
                            #Write-Host "  Multiplication"
                            [double]$temp = [double]$vars[$x] * [double]$vars[$y]
                            #write-host ("`t{0}({1}) * {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                            $vars[$exprk] = $temp
                            [void]$expr.remove($exprk)
                            [void]$keylist.remove($exprk)
                        }
                        "+" {
                            #Write-host "  Addition"
                            [double]$temp = [double]$Vars[$X] + [double]$vars[$y]
                            #write-host ("`t{0}({1}) + {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                            $vars[$exprk] = $temp
                            [void]$expr.remove($exprk)
                            [void]$keylist.remove($exprk)
                        }
                        "-" {
                            #Write-Host "  Subtraction"
                            [double]$temp = $Vars[$X] - $vars[$y]
                            #write-host ("`t{0}({1}) - {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                            $vars[$exprk] = $temp
                            [void]$expr.remove($exprk)
                            [void]$keylist.remove($exprk)
                        }
                        "/" {
                            #write-host "  Division"
                            [double]$temp = [double]$Vars[$X] / [double]$vars[$y]
                            #write-host ("`t{0}({1}) / {2}({3}) = {4}" -f $x,$vars[$x], $y,$vars[$y], $temp)
                            $vars[$exprk] = $temp
                            [void]$expr.remove($exprk)
                            [void]$keylist.remove($exprk)
                        }
                    default     {
                            Write-host "***UNKNOWN OP***"
                            Exit
                        }
                    
                    }#switch
                
                }
                Else{
                    #Write-host (" Don't have all the info yet")
                    $temphashitemkey = $exprk
                    $temphashvalue = $expr[$exprk]
                    [void]$keylist.remove($exprk)
                    [void]$keylist.add($exprk)
                }
                
                if($vars.ContainsKey("root")){$rootfound = $true}
                    
                    #Write-host ("****Vars****")
                    #$vars
                    #write-host ("****Expr****")
                    #$expr
                    
                }
                write-host ("Root: {0} " -f $vars["root"])
                [PSCustomObject]@{
                    Root = $vars["root"]
                    Guess = $guess
                    ($h["root"].split(" ")[0]) = $vars[$h["root"].split(" ")[0]]
                    ($h["root"].split(" ")[2]) =  $vars[$h["root"].split(" ")[2]]
                    Delta =  [long]$vars[$h["root"].split(" ")[0]] -  [long]$vars[$h["root"].split(" ")[2]]
                }

            }
        
        
        }

Function Helper {
    $found = $false
    $g = 0
    While($found -eq $false){
        $result = d21b -b -guess $g
        write-host("{0} : {1}" -f $g, $result)
        if($result){$found = $true}
        else{$g--}
    }
    Write-host ("Solution Part 2: {0}" -f $g)
}