function Get-CRC8 {
    <#
        .SYNOPSIS
            Calculate CRC8-maxim/dallas.
        .DESCRIPTION
            This function calculates the CRC of the input data using the CRC8-maxim/dallas algorithm.
        .EXAMPLE
            Get-CRC8 $data
        .EXAMPLE
            $data | Get-CRC8
        .NOTES
            PowerShell conversion based on https://communary.net/2017/02/12/calculate-crc32-in-powershell/ 
            and http://sanity-free.org/146/crc8_implementation_in_csharp.html

        .INPUTS
            byte[]
        .OUTPUTS
            uint32
        .LINK


    #>
    [CmdletBinding()]
    param (
        # Array of Bytes to use for CRC calculation
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [byte[]]$InputObject
    )

    Begin {

        function New-CrcTable {
            [byte]$c = $null
            $crcTable = New-Object 'System.byte[]' 256

            for ($n = 0; $n -lt 256; $n++) {
                $c = [byte]$n
                for ($k = 0; $k -lt 8; $k++) {
                    if ($c -band 1) {
                        $c = (0x8C -bxor ($c -shr 1))
                    }
                    else {
                        $c = ($c -shr 1)
                    }
                }
                $crcTable[$n] = $c
            }

            Write-Output $crcTable
        }

        function Update-Crc ([byte]$crc, [byte[]]$buffer, [int]$length) {
            [byte]$c = $crc

            if (-not($script:crcTable)) {
                $script:crcTable = New-CrcTable
            }

            for ($n = 0; $n -lt $length; $n++) {
                $c = $script:crcTable[($c -bxor $buffer[$n])] 
            }

            Write-output $c
        }

        $dataArray = @()
    }

    Process {
        foreach ($item  in $InputObject) {
            $dataArray += $item
        }
    }

    End {
        $inputLength = $dataArray.Length
        Write-Output ((Update-Crc -crc 0 -buffer $dataArray -length $inputLength) )
    }
}


