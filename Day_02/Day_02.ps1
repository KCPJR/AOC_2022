function Day2A {
[cmdletbinding()]
Param()    
begin{
$data = get-content C:\Scripts\aoc2022\Day_02\Input_D2.txt

write-host ("Games: {0}" -f $data.count)
$total = 0
foreach($game in $data){
    switch ($game) {
        "A X" {write-host ("Draw 1");$Total += 4}
        "A Y" {write-host ("Win 2");$Total += 8}
        "A Z" {write-host ("Lose 3");$Total += 3}
        "B X" {write-host ("Lose 1");$Total += 1}
        "B Y" {write-host ("Draw 2");$Total += 5}
        "B Z" {write-host ("Win 3");$Total += 9}
        "C X" {write-host ("Win 1");$Total += 7}
        "C Y" {write-host ("Lose 2");$Total += 2}
        "C Z" {write-host ("Draw 3");$Total += 6} 
        Default {}
    }
}
write-host("*******")
Write-host("Score: {0}" -f $Total)
}#begin

} #function



function Day2B {
    [cmdletbinding()]
    Param()    
    begin{
    $data = get-content C:\Scripts\aoc2022\Day_02\Input_D2.txt
    
    write-host ("Games: {0}" -f $data.count)
    $total = 0
    foreach($game in $data){
        switch ($game) {
            "A X" {write-host ("Lose 3");$Total += 3}
            "A Y" {write-host ("Draw 1");$Total += 4}
            "A Z" {write-host ("Win 2");$Total += 8}
            "B X" {write-host ("Lose 1");$Total += 1}
            "B Y" {write-host ("Draw 2");$Total += 5}
            "B Z" {write-host ("Win 3");$Total += 9}
            "C X" {write-host ("Lose 2");$Total += 2}
            "C Y" {write-host ("Draw 3");$Total += 6}
            "C Z" {write-host ("Win 1");$Total += 7} 
            Default {}
        }
    }
    write-host("*******")
    Write-host("Score: {0}" -f $Total)
    }#begin
    
    } #function
    
    
