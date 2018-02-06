function Invoke-Note {
    param (
        [Parameter(Mandatory)]
        [ValidateSet("C","C#","D","E","F","F#","G","G#","A","A#","B","Rest")]
        [string]$NoteName,
        
        [ValidateSet("Sixteenth","Eighth","Quarter","Half","Whole")]
        [string]$NoteLength = "Quarter",
        
        [ValidateRange(2,9)]
        [int]$Octave = 4,

        [ValidateScript({$_ -gt 0})]
        [int]$Tempo = 120
    )

    $MeasureTimeInMilliseconds = 60 / $Tempo * 1000

    switch ($NoteName) {
        "C"     { $FundamentalFrequency = 16.35; break }
        "C#"    { $FundamentalFrequency = 17.32; break }
        "D"     { $FundamentalFrequency = 18.35; break }
        "D#"    { $FundamentalFrequency = 19.45; break }
        "E"     { $FundamentalFrequency = 20.60; break }
        "F"     { $FundamentalFrequency = 21.83; break }
        "F#"    { $FundamentalFrequency = 23.12; break }
        "G"     { $FundamentalFrequency = 24.50; break }
        "G#"    { $FundamentalFrequency = 25.96; break }
        "A"     { $FundamentalFrequency = 27.50; break }
        "A#"    { $FundamentalFrequency = 29.14; break }
        "B"     { $FundamentalFrequency = 30.87; break }
        "Rest"  { $FundamentalFrequency = 0; break }
        Default {}
    }

    switch ($NoteLength) {
        "Sixteenth" { $NoteTime = $MeasureTimeInMilliseconds / 16; break }
        "Eighth"    { $NoteTime = $MeasureTimeInMilliseconds / 8; break }
        "Quarter"   { $NoteTime = $MeasureTimeInMilliseconds / 4; break }
        "Half"      { $NoteTime = $MeasureTimeInMilliseconds / 2; break }
        "Whole"     { $NoteTime = $MeasureTimeInMilliseconds; break }
        Default {}
    }

    $OctaveMultiplier = [math]::Pow(2,$Octave)
    $NoteFrequency = $FundamentalFrequency * $OctaveMultiplier

    if ($FundamentalFrequency -eq 0) {
        Start-Sleep -Milliseconds $NoteTime
    } else {
        [System.Console]::Beep($NoteFrequency,$NoteTime)
    }        
}

function Invoke-Melody {
    param (
        [Parameter(Mandatory)]
        [ValidateSet("C","C#","D","E","F","F#","G","G#","A","A#","B","Rest")]    
        [string[]]$NoteNameList,
        
        [ValidateSet("Sixteenth","Eighth","Quarter","Half","Whole")]
        [string[]]$NoteLengthList,

        [int[]]$NoteOctaveList,
        
        [int]$Tempo = 120
    )

    $MelodyNoteCount = $NoteNameList.Length

    for ($i = 0; $i -lt $MelodyNoteCount; $i++) {
        try {
            $NoteOctave = $NoteOctaveList[$i]
        } catch {
            $NoteOctave = 4
        }

        try {
            $NoteLength = $NoteLengthList[$i]
        } catch {
            $NoteLength = "Quarter"        
        }

        Invoke-Note -NoteName $NoteNameList[$i] -NoteLength $NoteLength -Octave $NoteOctave -Tempo $Tempo
    }
}
