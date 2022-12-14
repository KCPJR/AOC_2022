

Function D11_1test{
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
                $data = Get-Content .\Day_11\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_11\Input.txt
            }
            Default {}
        }


        $monkey = @()
        #monkey0
        $monkey += ,(79,98)

        #monkey1
        $monkey += ,(54,65,75,74)

        #monkey2
        $monkey += ,(79,60,97)
        
        #monkey3
        $monkey += ,@(74)

        $mkind = 0
        foreach($mk in $monkey){
            $outstr = ("Monkey {0}: {1}" -f $mkind,($mk -join ", "))
            Write-Verbose ($outstr)
            $mkind++
        }
        Write-Verbose ("")    
        $MkScore = 0,0,0,0
        for($round = 1;$round -le 20;$round++){
        #monkey Loop
        for($i = 0;$i -le 3;$i++){
            Write-Verbose ("Monkey {0}:" -f $i)

            foreach($item in $Monkey[$i]){
                Write-Verbose ("  Monkey inspects an item with a worry level of {0}" -f $item)
            
            switch($i) {
                0 {
                    $new = $item * 19
                    $divisor = 23
                    $targetmonkeytrue = 2
                    $targetmonkeyfalse = 3
                    write-verbose ("`tWorry level is multiplied by 19 to {0}" -f $new)
                }#monkey 0

                1 {
                    $new = $item + 6
                    $divisor = 19
                    $targetmonkeytrue = 2
                    $targetmonkeyfalse = 0
                    write-verbose ("`tWorry level increased by 6 to {0}" -f $new)

                }#monkey 1

                2 {
                    $new = $item * $item
                    $divisor = 13
                    $targetmonkeytrue = 1
                    $targetmonkeyfalse = 3
                    write-verbose ("`tWorry level multiplied by itself to {0}" -f $new)
                }#monkey 2
                
                3 {
                    $new = $item + 3
                    $divisor = 17
                    $targetmonkeytrue = 0
                    $targetmonkeyfalse = 1
                    write-verbose ("`tWorry level is increased by 3 to {0}" -f $new)
                }#monkey 3

            }#switch

            $new = [int][Math]::Floor($new / 3)
            Write-Verbose ("`tMonkey gets board with item. Worry level is divided by 3 to {0}" -f $new)
            
            $remainder = $new % $divisor
            
            if( $remainder -eq 0){
                #true
                Write-Verbose ("`tCurrent worry level is divisible by {0}" -f $divisor)
                Write-verbose ("`tItem with worry level {0} is thrown to {1}" -f $new, $targetmonkeytrue)
                $monkey[$targetmonkeytrue] += ,$new
            }
            else {
                #false
                Write-Verbose ("`tCurrent worry level is not divisible by {0}" -f $divisor)
                Write-verbose ("`tItem with worry level {0} is thrown to {1}" -f $new, $targetmonkeyfalse)
                $monkey[$targetmonkeyfalse] += ,$new
            }
            $MkScore[$i]++
        
        }#foreach item monkey has
        $monkey[$i] = @()

        
        Write-Verbose ("")    
    }#monkey loop
    write-verbose ("After round {0}, the monkeys are holding items with these worry levels:" -f $round)
        $mkind = 0
        foreach($mk in $monkey){
            $outstr = ("Monkey {0}: {1}" -f $mkind,($mk -join ", "))
            Write-Verbose ($outstr)
            $mkind++
        }
    }#round loop
        $z = 0
        foreach($score in $MkScore){
            Write-Verbose ("Monkey {0} inspected items {1} times" -f $z,$MkScore[$z])
            $z++
        }

        $toptwo = $MkScore | sort -Descending | select -first 2
        $solution = $toptwo[0] * $toptwo[1]
        write-verbose("")
        write-Host ("Solution: {0}" -f $solution)
    }#begin
    
}#function

