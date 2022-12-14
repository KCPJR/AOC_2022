function Test-Order {
    [CmdletBinding()]
    param(
        $LeftData,
        $RightData
    )
    #returns -1 if left is smaller
    #returns 1 if right is smaller
    Begin{

        #open Bracket
        $openbracket = 91 
        $closedbracket = 93
        $digits = 48..58

        $L = [Collections.Generic.List[int]]::new([int[]]$LeftData.Replace('10',':').ToCharArray())
        $R = [collections.Generic.List[int]]::new([int[]]$RightData.Replace('10',':').ToCharArray())

        $shorterlistcount = ($L.count,$R.count)|sort | select -First 1
        #Write-host ("{0} is the shorter ({1},{2})" -f $shorterlistcount, $L.count, $R.count)

        for($i=0;$i-le$shorterlistcount;$i++){

            $Left = $L[$i]
            $Right = $R[$i]

            #Write-verbose ("L:{0} R:{1}" -f $Left,$Right)

            if($left -eq $right){Continue}
            
            if($Left -in (48..58) -and $right -in (48..58)){
                #Both are digits
                if($left -lt $right){
                    #Left is Smaller
                    Write-verbose ("--Correct Order")
                    Return $true
                }
                Else{
                    #Rigth is Smaller
                    Write-Verbose ("--Wrong Order")
                    Return $false
                }
            }

            #both are not digits so do we need to add a bracket to the non-digit
            if($left -eq $openbracket -and $right -in $digits){
                #left is open bracket and rigth is a number
                $R.Insert($i+1,$closedbracket)
                $R.Insert($i,$openbracket)
                #inserted the closed first so it wouldn't mess up the insert location for the open bracket
                Continue
                #will take us back to the for loop.
            }

            if($right -eq $openbracket -and $left -in $digits){
                $L.Insert($i+1,$closedbracket)
                $L.Insert($i,$openbracket)
                Continue
            }

            if($left -eq $closedbracket -and $right -ne $closedbracket){
                #Left is done, but right is not... so Left is shorter
                Write-verbose ("--Correct Order")
                Return $true
            }
            if($right -eq $closedbracket -and $left -ne $closedbracket){
                Write-Verbose ("--Wrong Order")
                Return $false
            }

            write-warning ("Oops something went wrong... unanticipated scenario")
        }
    }
}
