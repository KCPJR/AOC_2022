Function D4A {
    [cmdletbinding()]
    param()
    Begin{

        #$data = get-content .\Day_04\Input_Test.txt
        $data = get-content .\Day_04\Input.txt

        $counter = 0

        foreach($line in $data){

            $elf1 = $line.split(",")[0]
            $elf2 = $line.split(",")[1]
       
            
            [int]$e1s = $elf1.split("-")[0]
            [int]$e1f = $elf1.split("-")[1]
            [int]$e2s = $elf2.split("-")[0]
            [int]$e2f = $elf2.split("-")[1]

            $flag = $false
            
            if(($e1s -le $e2s) -and ($e1f -ge $e2f)){$flag = $true}
            if(($e2s -le $e1s) -and ($e2f -ge $e1f)){$flag = $true}

            if($flag){$counter++}
        }
        Write-host ("Solution: {0}" -f $counter)

    }#begin

}#function



Function D4B {
    [cmdletbinding()]
    param()
    Begin{

        #$data = get-content .\Day_04\Input_Test.txt
        $data = get-content .\Day_04\Input.txt

        $counter = 0

        foreach($line in $data){

            $elf1 = $line.split(",")[0]
            $elf2 = $line.split(",")[1]
       
            
            [int]$e1s = $elf1.split("-")[0]
            [int]$e1f = $elf1.split("-")[1]
            [int]$e2s = $elf2.split("-")[0]
            [int]$e2f = $elf2.split("-")[1]

            $flag = $false
            if(($e1s -le $e2s) -and ($e1f -ge $e2s)){$flag = $true}
            if(($e1s -le $e2f) -and ($e1f -ge $e2f)){$flag = $true}
            if(($e2s -le $e1s) -and ($e2f -ge $e1s)){$flag = $true}
            if(($e2s -le $e1f) -and ($e2f -ge $e1f)){$flag = $true}

            If($flag){$counter++}

        }
        Write-host ("Solution: {0}" -f $counter)

    }#begin

}#function



Function ALT_D4A {
    [cmdletbinding()]
    param()
    Begin{

        #$data = get-content .\Day_04\Input_Test.txt
        $data = get-content .\Day_04\Input.txt

        $counter = 0

        foreach($line in $data){

            $elf1 = $line.split(",")[0]
            $elf2 = $line.split(",")[1]
       
            
            [int]$e1s = $elf1.split("-")[0]
            [int]$e1f = $elf1.split("-")[1]
            [int]$e2s = $elf2.split("-")[0]
            [int]$e2f = $elf2.split("-")[1]

            $R1 = $e1s..$e1f
            $R2 = $e2s..$e2f

            $flag = $false
            if(($e2s -in $R1) -and ($e2f -in $R1)){$flag = $true}
            if(($e1s -in $R2) -and ($e1f -in $R2)){$flag = $true}

            #if(($e1s -le $e2s) -and ($e1f -ge $e2f)){$flag = $true}
            #if(($e2s -le $e1s) -and ($e2f -ge $e1f)){$flag = $true}

            if($flag){$counter++}
        }
        Write-host ("Solution: {0}" -f $counter)

    }#begin

}#function


Function ALT_D4B {
    [cmdletbinding()]
    param()
    Begin{

        #$data = get-content .\Day_04\Input_Test.txt
        $data = get-content .\Day_04\Input.txt

        $counter = 0

        foreach($line in $data){

            $elf1 = $line.split(",")[0]
            $elf2 = $line.split(",")[1]
       
            
            [int]$e1s = $elf1.split("-")[0]
            [int]$e1f = $elf1.split("-")[1]
            [int]$e2s = $elf2.split("-")[0]
            [int]$e2f = $elf2.split("-")[1]

            $R1 = $e1s..$e1f
            $R2 = $e2s..$e2f

            $flag = $false
            if(($e2s -in $R1) -or ($e2f -in $R1)){$flag = $true}
            if(($e1s -in $R2) -or ($e1f -in $R2)){$flag = $true}

            If($flag){$counter++}

        }
        Write-host ("Solution: {0}" -f $counter)

    }#begin

}#function
