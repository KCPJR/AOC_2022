Function D6{
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
                $markersize = 4
                $data = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
                #$data = "bvwbjplbgvbhsrlpgdmjqwftvncz"
                #$data = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
            }
            B {
                Write-host "ParameterSet B"
                $markersize = 14
                $data = Get-Content .\Day_06\Input.txt
            }
            Default {}
        }





        
        $exitflag = $false
        $i = $markersize    
        While($i -lt $data.length -and !$exitflag){
            
            #$u = ($data[($i-($markersize -1))..$i]) -join ""
            $ca = ($data[($i-($markersize -1))..$i]|Select-Object -Unique).count
            #Write-host ("_{0}_   {1} {2}" -f $u,$u.length,$ca)
            #write-host ("{0} to {1} _{2}_ {3}" -f ($i-3),$i,$u,$ca)
            if($ca -eq $markersize){
                $Key = $i;
                $exitflag = $true}
            $i++
        }

        
        Write-host("Key: {0}" -f $key)
        Write-host("Solution: {0}" -f ($key + 1))
    }
}