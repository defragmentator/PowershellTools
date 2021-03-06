function Get-Base32 {
    <#
        .SYNOPSIS
            Base32 encoder
        .DESCRIPTION
            This function encodes array of bytes to Base32
        .EXAMPLE
            Get-Base32 $data
        .EXAMPLE
            $data | Get-Base32
        .NOTES
            PowerShell Base32 encoderbased on https://humanequivalentunit.github.io/Base32-coding-the-scripting-way/

        .INPUTS
            byte[]
        .OUTPUTS
            String
        .LINK


    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
	[byte[]] $InputObject,
	[Parameter(Mandatory=$false)]
	[Alias("EnablePadding")]
	[bool]$pad   = $True	
     )

    Process {
        foreach ($item  in $InputObject) {
            $dataArray += $item
        }
    }
    
    Begin {
        $dataArray = @()
    }


    End {
    	    $byteArrayAsBinaryString = -join $dataArray.ForEach{
	    [Convert]::ToString($_, 2).PadLeft(8, '0')
	    }
        
            $padding=""
	    if($pad -eq $True)
    	    {
		switch ($byteArrayAsBinaryString.length % 5){
		    1 { $padding="====" }
		    2 { $padding="=" }
		    3 { $padding="======" }
		    4 { $padding="===" }
		}
    	    }
      
	    $byteArrayAsBinaryString = $($byteArrayAsBinaryString+("0000".Substring(0,5-($byteArrayAsBinaryString.length%5))))
	 
	    $x = [regex]::Replace($byteArrayAsBinaryString, '.{5}', {
    		param($Match)
    		'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'[[Convert]::ToInt32($Match.Value, 2)]
	    })
	    Write-Output "$x$padding"
    }
}

    