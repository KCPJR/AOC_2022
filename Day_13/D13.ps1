Function D13{
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
                $data = Get-Content .\Day_13\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_13\Input.txt
            }
            Default {}
        }
        $datapairs = @()
        
        for($i = 0;$i -le $data.count;$i++){
            $Left = $data[$i]
            $i++
            $Rigth = $data[$i]
            $i++
            $datapairs += [PSCustomObject]@{
                Left = $Left
                Right = $Rigth
            }
            
        }    
    

        #Write-host ("Done")   
        #$datapairs
        #$pairind = 2
        #$leftList = [Collections.Generic.List[int]]::new([int[]]$p[$pairind].left.Replace('10',':').ToCharArray())
        #$rightList = [collections.Generic.List[int]]::new([int[]]$p[$pairind].right.Replace('10',':').ToCharArray())


        $shorterlistcount = ($leftlist.count,$rightlist.count)|sort | select -First 1
        #Write-host ("{0} is the shorter ({1},{2})" -f $shorterlistcount, $leftlist.count, $rightList.count)
        
        #good is a collection of good data pairs
        $good = @()
        $ind = 0
        foreach($pair in $datapairs){
            $ind++
            Write-Verbose ("")
            Write-verbose ("Pair Index: {0}" -f $ind)
            write-verbose("Left:  {0}" -f $pair.left)
            write-verbose("Right: {0}" -f $pair.right)
            
            if( (Compare-LeftRight -LeftData $pair.Left -RightData $pair.right) -lt 1 ){
                #pair was in the right order
                Write-Verbose("  --Pair was in the right order")
                $good += $ind
            }

        }
        write-host ("Number of Good:{0}" -f ($good -join ","))
        $solution = 0
        $good|%{$Solution += $_}
        write-host ("Solution Part One: {0}" -f $solution)


        #part two

        $all = @()
        $all += "[[6]]"
        $all += "[[2]]"
        foreach($pair in $datapairs){
            $all+= $pair.Left
            $all+= $pair.right
        }
        #$allasc = [Collections.Generic.List[int]]::new
        #foreach($set in $all){
        #    $allasc. += @([Collections.Generic.List[int]]::new([int[]]$set.replace('10',':').ToCharArray()))
        #}
        $list= [Collections.Generic.List[string]]::new()
        $list.add("[[6]]")
        $list.add("[[2]]")
        foreach($pair in $datapairs){
            $list.add($pair.left)
            $list.add($pair.right)
        }
        #$list
        
        $backwards = Sort-Custom -list $list
        $correct = @()
        #something goofy - order is reversed so reverse it to correct.
        for($i = $backwards.count -1;$i -ge 0;$i--){
            $correct += $backwards[$i]
    
        }
        $ind1 = $correct.indexof("[[2]]") +1
        $ind2 = $correct.indexof("[[6]]") +1
        $SolutionPart2 = $ind1 * $ind2
        write-host ("Solution Part 2: {0}" -f $SolutionPart2)
        #$correct
        
        #list is now sorted
        

    }#end Begin
        


    }#end Function

    function Compare-LeftRight {
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

                Write-verbose ("L:{0} R:{1}" -f $Left,$Right)

                if($left -eq $right){Continue}
                
                if($Left -in (48..58) -and $right -in (48..58)){
                    #Both are digits
                    if($left -lt $right){
                        #Left is Smaller
                        Return -1
                    }
                    Else{
                        #Rigth is Smaller
                        Return 1
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
                    Return -1
                }
                if($right -eq $closedbracket -and $left -ne $closedbracket){
                    Return 1
                }

                write-warning ("Oops something went wrong... unanticipated scenario")
            }
        }
    }

    Function _$helperPart1 {
        . .\Day_13\Sort.ps1
        . .\Day_13\Compare.ps1
        . .\Day_13\D13.ps1
        #d13 -A
        d13 -b
    }