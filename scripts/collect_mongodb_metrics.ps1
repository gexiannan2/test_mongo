[CmdletBinding()]
param(
    [ValidateRange(1, 1800)]
    [int]$DurationSeconds = 600,
    [ValidateRange(1, 60)]
    [int]$IntervalSeconds = 1,
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $PSScriptRoot "..\results\mongod-metrics.csv"
}

if (-not (Get-Process -Name mongod -ErrorAction SilentlyContinue)) {
    throw "未检测到 mongod 进程。请先启动 MongoDB 服务后再采集指标。"
}

$outputDirectory = Split-Path -Parent $OutputPath
if (-not [string]::IsNullOrWhiteSpace($outputDirectory)) {
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
}

# CPU、私有工作集、磁盘 IOPS、磁盘响应时间和磁盘队列长度。
$counterPaths = @(
    "\Process(mongod*)\% Processor Time",
    "\Process(mongod*)\Working Set - Private",
    "\PhysicalDisk(_Total)\Disk Transfers/sec",
    "\PhysicalDisk(_Total)\Avg. Disk sec/Transfer",
    "\PhysicalDisk(_Total)\Current Disk Queue Length"
)
$sampleCount = [math]::Ceiling($DurationSeconds / $IntervalSeconds)

Write-Host "开始采集 MongoDB 系统指标：$DurationSeconds 秒，每 $IntervalSeconds 秒一次"
Write-Host "输出文件：$OutputPath"

$samples = Get-Counter -Counter $counterPaths `
    -SampleInterval $IntervalSeconds `
    -MaxSamples $sampleCount

$rows = foreach ($sample in $samples) {
    foreach ($counter in $sample.CounterSamples) {
        [pscustomobject]@{
            timestamp = $counter.Timestamp.ToString("o")
            path = $counter.Path
            value = $counter.CookedValue
        }
    }
}

$rows | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "采集完成，共 $($rows.Count) 条指标记录。"
