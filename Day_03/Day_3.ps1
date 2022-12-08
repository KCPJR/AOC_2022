function D3A {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $grandtotal = 0
        #$data = get-content .\Day_03\Input_test.txt
        $data = get-content .\Day_03\Input.txt

        Foreach($bag in $data){

            $pouch1 = ($bag.ToCharArray()|select -first ($bag.length /2 ) )|select -Unique
            $pouch2 = ($bag.ToCharArray()|select -last ($bag.length /2 ) )|select -Unique

            $baditem = Compare-Object -CaseSensitive -ReferenceObject $pouch1 -DifferenceObject $pouch2 -IncludeEqual | ? {$_.sideindicator -eq "=="} |select -ExpandProperty inputobject
            
            $ascii = [byte][char] $baditem
            switch ($ascii) {
                {$_ -ge 97 -and $_ -le 122} {$Score = $ascii - 96  }
                {$_ -ge 65 -and $_ -le 90} {$Score = $ascii -38}
                Default {}
            }
            $grandtotal += $Score   
            write-host ("Found: {0}  score: {1}  Running Total:{2}" -f $baditem, $Score, $grandtotal)
        }#bag
        write-host ("Final Score: {0}" -f $grandtotal)
    }
}#function


Function D3B {
    [cmdletbinding()]
    param()
    Begin{

        $grandtotal = 0
        #$data = get-content .\Day_03\Input_test.txt
        $data = get-content .\Day_03\Input.txt
        
        for($i = 0; $i -le $data.count -1 ; $i = $i+3){
            $Bag1 = $data[$i].ToCharArray()|select -Unique
            $bag2 = $data[$i+1].ToCharArray()|select -Unique
            $bag3 = $data[$i+2].ToCharArray()|select -Unique

            $comp1 = compare-object -CaseSensitive -ReferenceObject $bag1 -DifferenceObject $bag2 -IncludeEqual |? {$_.sideindicator -eq "=="}|select -ExpandProperty inputobject
            $badge = Compare-Object -CaseSensitive -ReferenceObject $comp1 -DifferenceObject $bag3 -IncludeEqual | ?{$_.sideindicator -eq "=="}|select -ExpandProperty inputobject

            $ascii = [byte][char] $badge
            switch ($ascii) {
                {$_ -ge 97 -and $_ -le 122} {$Score = $ascii - 96  }
                {$_ -ge 65 -and $_ -le 90} {$Score = $ascii -38}
                Default {}
            }
            $grandtotal += $Score
            write-host ("Found: {0}  score: {1}  Running Total: {2}" -f $badge, $Score, $grandtotal)
        }
        Write-host("Solution: {0}" -f $grandtotal)
    }
}    