Function D5A {
    [cmdletbinding()]
    param()
    Begin{

        #$data = Get-Content .\Day_05\Input_Test.txt
        $data = Get-Content .\Day_05\Input.txt

        #$data = $data|select -first 20

        $i = 0
        While($data[$i] -ne ""){
            $i++
        }
        $stackrow = $i-2
        Write-host ("Blank Row: {0} -- Header Row: {1} -- First row of Stacks:{2} "-f $i,($i-1),($i-2))
        $numcol = ($data[$i-1].split(" "))[-2]

        write-host ("Num Col:{0}" -f $numcol)
        $inv = @()
        $inv += ""  
        for($col = 1;$col -le $numcol;$col++){
            $stackstr = ""
            
            for($row = $stackrow;$row -ge 0;$row--){
                $Box = $data[$row].substring((1+($col -1)*4),1)
                $stackstr += $box
            }
            $stackstr = $stackstr.Replace(" ","")
            write-host ("Stack :___{0}___" -f $stackstr)
            $inv += $stackstr
        }


        for($k = $i+1;$k -lt $data.count;$k++){
            #Write-host ($data[$k])
            $Qty = ($data[$k].split(" "))[1]
            $Origin = ($data[$k].split(" "))[3]
            $Destination = ($data[$k].split(" "))[5]
            write-host ("`nMove:{0} Origin:{1} Destination:{2}" -f $qty,$Origin,$Destination )
        
            For($j= 1;$j -le $Qty;$j++){

                $Ostackstr = $inv[$Origin].tostring()
                [char] $box = $Ostackstr.substring($Ostackstr.length -1, 1)
                $inv[$Destination] = [string]("{0}{1}" -f $inv[$Destination],[char]$Box).replace(" ","").tostring()
                $inv[$Origin] = $inv[$Origin].substring(0,$Ostackstr.length -1).tostring()
                
            }
            write-host ("`n*** New Inv ***")
            $inv
        }
    
        Write-host ("`n**** Final Processing ****")
        $ans = ""
        for($k = 1;$k -le $numcol ;$k++){
            $stackstr = $inv[$k].replace(" ","").tostring()
            $last =  $inv[$k].substring($stackstr.length -1,1).tostring()
            write-host ("stack{0}: {1}" -f $k,$last)

            $ans += $last
        }
        write-host ("Answer: {0}" -f $ans)
    }
}


Function D5B {
    [cmdletbinding()]
    param()
    Begin{

        #$data = Get-Content .\Day_05\Input_Test.txt
        $data = Get-Content .\Day_05\Input.txt

        #$data = $data|select -first 20

        $i = 0
        While($data[$i] -ne ""){
            $i++
        }
        $stackrow = $i-2
        Write-host ("Blank Row: {0} -- Header Row: {1} -- First row of Stacks:{2} "-f $i,($i-1),($i-2))
        $numcol = ($data[$i-1].split(" "))[-2]

        write-host ("Num Col:{0}" -f $numcol)
        $inv = @()
        $inv += ""  
        for($col = 1;$col -le $numcol;$col++){
            $stackstr = ""
            
            for($row = $stackrow;$row -ge 0;$row--){
                $Box = $data[$row].substring((1+($col -1)*4),1)
                $stackstr += $box
            }
            $stackstr = $stackstr.Replace(" ","")
            #write-host ("Stack :___{0}___" -f $stackstr)
            $inv += $stackstr
        }


        for($k = $i+1;$k -lt $data.count;$k++){

            $Qty = ($data[$k].split(" "))[1]
            $Origin = ($data[$k].split(" "))[3]
            $Destination = ($data[$k].split(" "))[5]
            write-host ("`nMove:{0} Origin:{1} Destination:{2}" -f $qty,$Origin,$Destination )
            

            #Write-host ("  You've got to move it {0} to {1}" -f $Origin,$Destination)
            $Ostackstr = $inv[$Origin].tostring()
            #write-host ("     Stack: {0}" -f $Ostackstr)
            #write-host ("         Length: {0}" -f $Ostackstr.length)
            $box = $Ostackstr.substring($Ostackstr.length - $qty, $qty)
            #write-host (  "Box: {0} {1}" -f $Box,$box.length)
            $inv[$destination] = [string]("{0}{1}" -f $inv[$destination],$box)
            $inv[$origin] = $inv[$origin].substring(0,$inv[$origin].length - $qty).tostring()
            
            write-host ("`n*** New Inv ***")
            $inv
        }
    
        Write-host ("`n**** Final Processing ****")
        $ans = ""
        for($k = 1;$k -le $numcol ;$k++){
            $stackstr = $inv[$k].replace(" ","").tostring()
            $last =  $inv[$k].substring($stackstr.length -1,1).tostring()
            write-host ("stack{0}: {1}" -f $k,$last)
            #if($inv[$k] -eq ""){$ans += " "}Else{$ans += $inv[$k].tochararray()|select -last 1}
            $ans += $last
        }
        write-host ("Answer: {0}" -f $ans)
    }
}