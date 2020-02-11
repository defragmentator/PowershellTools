I was looking for Powershell scripts which could calculate CRC-8 checksum and encode data using Base32 encoding. There were no such so I've written it. Enjoy!

* CRC-8
  1. This implementation is exactly as CRC8-maxim/dallas
  1. Other types of CRC-8: probably it would be easy to implement other types of CRC8 by changing 0X8C in code
```
$c = (0x8C -bxor ($c -shr 1))
```
to some other values from [Wiki](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) with value of Polynomial representations named there in chart as "Reversed".  It was not testet yet!

* Base32 is based on regexp so it is very unoptimal, but it works.

* Example usage:
```
$b= [System.Text.Encoding]::ASCII.GetBytes("Power") | Get-Base32

"base32: $b"

$a= [System.Text.Encoding]::ASCII.GetBytes("Power") | Get-CRC8

[String]::Format("{0:x2}", $a)
$a.ToString("X2")
```
