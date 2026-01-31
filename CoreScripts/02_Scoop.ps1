$env:SCOOP = $State.ScoopPath
$env:SCOOP_GLOBAL = $State.GlobalPath
[Environment]::SetEnvironmentVariable('SCOOP', $State.ScoopPath, 'User')
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $State.GlobalPath, 'Machine')

if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    # Network install via mirror
    iwr -useb scoop.201704.xyz | iex
}

# Configure Buckets and Core tools
scoop install 7zip git -p
scoop bucket rm main 2>$null
scoop bucket add main
scoop bucket add extras
scoop update
scoop cache rm *