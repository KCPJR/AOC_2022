Function D7{
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
                $data = Get-Content .\Day_07\Input_test.txt
            }
            B {
                Write-host "ParameterSet B"
                $data = Get-Content .\Day_07\Input.txt
            }
            Default {}
        }

        $inv = @()
        $path = ""
        $dirlist = @()
        Foreach($line in $data){
            Write-Verbose ("Line: {0}" -f $line)
            
            switch -Wildcard ($line) {
                "$ cd *" { 
                    
                    if($line -eq "$ cd /"){
                        $path = "/"
                        break
                    }
                    if ($line -eq "$ cd .."){
                        $prevdir = ($path.split("/"))[0..($path.split("/").count -3)] -join ("/")
                        Write-Verbose ("`tChange Dir to :{0}" -f $prevdir)
                        $path = ("{0}/" -f $prevdir)
                        Write-Verbose ("`tNew Path: {0}" -f $path)
                        Break
                    }
                    Else{
                    $newdir = ($line.split(" ")[2])
                    $path = ("{0}{1}/" -f $path,$newdir)
                    Write-Verbose ("`tPath: {0}" -f $path)
                    Break
                    }
                  }
                "$ ls" {
                    Write-Verbose ("`tLS command issued")
                    break
                }  
                "dir *" {
                    write-verbose("`t Directory found")
                    $dirname = $line.split(" ")[1]
                    $dirpath = ("{0}{1}" -f $path,$dirname)
                    $dirlist += $dirpath
                    break
                }
            
                Default {
                    $filename = $line.split(" ")[1]
                    $filesize = $line.split(" ")[0]
                    Write-Verbose ("`tPath: {0}" -f $path)
                    Write-Verbose ("`t File Found:{0}  ({1})" -f $filename, $filesize)
                    $inv += [PSCustomObject]@{
                        fullpath = ("{0}{1}" -f $path,$filename)
                        Path = $path
                        size = $filesize
                        filename = $filename
                    }
                    write-verbose ("`t Total File Count: {0}" -f $inv.count)
                }
            } #switch


        }#foreach line

        write-verbose("**************")
        $inv
        
        $bigtot = 0
        $dirinv = @()
        Foreach($dir in $dirlist){
            $totsize = 0
            $files = $inv|?{$_.path -like ("{0}*" -f $dir)}

            $files|%{$totsize += $_.size}
            Write-Verbose ("{0} -- {1}" -f $dir, $totsize)
            $dirinv += [PSCustomObject]@{
                Directory = $dir
                Size = $totsize
            }
            if($totsize -le 100000){
                Write-Host ("")
            #    Write-Verbose ("{0} -- {1}" -f $dir, $totsize)
                $totsize
                $bigtot += $totsize
            }
        }
            
        
        #}
        Write-host ("Solution Part A: {0}" -f $bigtot)
        
        #Part 2
        $currentused = 0
        $inv|%{$currentused += $_.size}
        $currentfree = 70000000 - $currentused
        Write-Verbose ("Current Used: {0}" -f $currentused)
        Write-Verbose ("Current Available: {0}" -f $currentfree)
        $needed = (30000000 - $currentfree)
        Write-Verbose ("Need: {0}" -f $needed)
        $dirsbigenough = $dirinv | ?{$_.Size -ge $needed}
        $best = $dirsbigenough|sort -Property Size|select -First 1
        write-verbose ("Solution Part B: {0} -- {1}" -f $best.directory, $best.Size)
    }
}