# Parse-IIS-Logs
IIS Logs

https://github.com/WiredPulse/PowerShell/blob/master/Web/Invoke-IISLogParser


<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$formMain                        = New-Object system.Windows.Forms.Form
$formMain.ClientSize             = '314,244'
$formMain.text                   = "Form"
$formMain.TopMost                = $true

$b1                              = New-Object system.Windows.Forms.Button
$b1.text                         = "b1"
$b1.width                        = 60
$b1.height                       = 30
$b1.location                     = New-Object System.Drawing.Point(164,205)
$b1.Font                         = 'Microsoft Sans Serif,10'

$b2                              = New-Object system.Windows.Forms.Button
$b2.text                         = "b2"
$b2.width                        = 60
$b2.height                       = 30
$b2.location                     = New-Object System.Drawing.Point(236,205)
$b2.Font                         = 'Microsoft Sans Serif,10'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $true
$TextBox1.width                  = 258
$TextBox1.height                 = 50
$TextBox1.location               = New-Object System.Drawing.Point(12,49)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'
$TextBox1.text                   = 'adffff'

$label                     = New-Object system.Windows.Forms.Label
$label.text                = "Connection Watcher"
$label.AutoSize            = $true
$label.width               = 25
$label.height              = 10
$label.location            = New-Object System.Drawing.Point(45,14)
$label.Font                = 'Microsoft Sans Serif,10'

$formMain.controls.AddRange(@($b1,$b2,$TextBox1,$label))

$b1.Add_Click({ testMe })
$b2.Add_Click({ testMe })

## Show the form
$formMain.ShowDialog()
