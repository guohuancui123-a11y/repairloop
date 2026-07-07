$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$repo = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$assets = Join-Path $repo "docs\assets"
$output = Join-Path $assets "repairloop-social-preview.png"

New-Item -ItemType Directory -Force -Path $assets | Out-Null

$width = 1280
$height = 640
$bg = [System.Drawing.Color]::FromArgb(13, 17, 23)
$panel = [System.Drawing.Color]::FromArgb(22, 27, 34)
$border = [System.Drawing.Color]::FromArgb(48, 54, 61)
$text = [System.Drawing.Color]::FromArgb(230, 237, 243)
$muted = [System.Drawing.Color]::FromArgb(139, 148, 158)
$green = [System.Drawing.Color]::FromArgb(63, 185, 80)
$red = [System.Drawing.Color]::FromArgb(248, 81, 73)
$blue = [System.Drawing.Color]::FromArgb(88, 166, 255)
$orange = [System.Drawing.Color]::FromArgb(255, 107, 74)

$titleFont = New-Object System.Drawing.Font("Segoe UI", 76, [System.Drawing.FontStyle]::Bold)
$subtitleFont = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Regular)
$loopFont = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
$footerFont = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Regular)
$monoFont = New-Object System.Drawing.Font("Consolas", 24, [System.Drawing.FontStyle]::Regular)

function New-Brush($color) {
    return New-Object System.Drawing.SolidBrush($color)
}

$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear($bg)

$graphics.FillEllipse((New-Brush ([System.Drawing.Color]::FromArgb(42, 255, 107, 74))), -120, -180, 620, 620)
$graphics.FillEllipse((New-Brush ([System.Drawing.Color]::FromArgb(24, 88, 166, 255))), 890, 380, 520, 520)

$graphics.DrawString("RepairLoop", $titleFont, (New-Brush $orange), 80, 68)
$graphics.DrawString("Local-first Python Runtime Repair", $subtitleFont, (New-Brush $text), 86, 170)
$graphics.DrawString("Run  →  Capture  →  Repair  →  Verify", $loopFont, (New-Brush $green), 86, 245)
$graphics.DrawString("No cloud. No API key. No source upload.", $footerFont, (New-Brush $muted), 88, 548)

$graphics.FillRectangle((New-Brush $panel), 760, 95, 420, 330)
$graphics.DrawRectangle((New-Object System.Drawing.Pen($border, 2)), 760, 95, 420, 330)
$graphics.FillEllipse((New-Brush $red), 785, 116, 14, 14)
$graphics.FillEllipse((New-Brush ([System.Drawing.Color]::FromArgb(210, 153, 34))), 808, 116, 14, 14)
$graphics.FillEllipse((New-Brush $green), 831, 116, 14, 14)

$terminalLines = @(
    @{ Text = "> python app.py"; Color = $blue },
    @{ Text = "FileNotFoundError"; Color = $red },
    @{ Text = "> repair-loop repair"; Color = $blue },
    @{ Text = "[FIX] create config"; Color = $muted },
    @{ Text = "[VERIFY] success"; Color = $green }
)
$y = 165
foreach ($line in $terminalLines) {
    $graphics.DrawString($line.Text, $monoFont, (New-Brush $line.Color), 790, $y)
    $y += 48
}

$bitmap.Save($output, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()

Write-Output $output
