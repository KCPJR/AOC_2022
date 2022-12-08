function ParametersetTest {

    [CmdletBinding(DefaultParameterSetName = 'A')]
    param (
        [Parameter(ParameterSetName = "A")]
        [Switch] $A,

        # Parameter help description
        [Parameter(ParameterSetName = "B")]
        [Switch]
        $B

    )
    
    begin {
        switch ($PsCmdlet.ParameterSetName) {
            A { Write-host "ParameterSet A" }
            B { Write-host "ParameterSet B"}
            Default {}
        }
    }
    
}