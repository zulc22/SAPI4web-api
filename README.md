In my experience so far; the best luck for building a _WORKING_ 32-bit binary
was to use the LDC release binary '1.23.0-multilib'. (dub is included)

This is almost certainly required as the DLLs are meant to run in 32-bit mode.

# SAPI4 server compilation on local Windows machine

1. Install Microsoft Speech SDK 4.0 (`SAPI4SDK.exe`)
2. Run `build.bat`. If you have a different version of VS, change vcvars32 path (fix soon?)
3. Install [`ldc2`](https://github.com/ldc-developers/ldc/releases)
4. Go to SAPI4_web and compile the web server: `dub --arch=x86 --build=release`

# Web GUI

Inherited from parent project. Served on / on the HTTP port specified by the log
when starting a server.

# API endpoints

## /VoiceList

List all voice names.

### GET /VoiceList

- 200 Found

```jsonc
["Voice Name 1", "Voice Name 2", ...]
```

## VoiceLimitations

### GET /VoiceLimitations

- 200 Found

```jsonc
{ // For each loaded voice:
	voiceName: {
		"defPitch": number, 
		"minPitch": number,
		"maxPitch": number,
		"defSpeed": number,
		"minSpeed": number,
		"maxSpeed": number
	}, ...
}
```

Returned when voice is blank or not specified.

### GET /VoiceLimitations?voice=[voice]

- 200 Found

```jsonc
{ // Return limitations for the specified voice
	"defPitch": number, // Default for the 'Pitch' control
	"minPitch": number, // Minimum for the 'Pitch' control
	"maxPitch": number, // Maximum... and so on...
	"defSpeed": number,
	"minSpeed": number,
	"maxSpeed": number
}
```

- 400 Bad Request

```
Invalid voice
```

Responded with when the voice parameter does not match any loaded voice.

## SAPI4
This endpoint uses the SAPI4 engine for the main function; text to speech synthesis.

### GET /SAPI4<?text=...&voice=...>[&pitch=...][&speed=...]

- 200 Found

Returns RIFF WAV data. (`audio/wav`)

- 400 Bad Request

```
Invalid text
```

Text is either empty or length is more than or equal to 4096 characters.

```
Invalid pitch/speed
```

One of the pitch or speed parameters could not be parsed as a number.

```
Invalid voice
```

Voice was not specified or the name specified does not match a loaded voice.
(see /VoiceList and /VoiceLimitations)

```
Available pitch: [$x ~ $y], got $z
```

Pitch was not in expected range. (see /VoiceLimitations)

```
Available speed: [$x ~ $y], got $z
```

Speed was not in expected range. (see /VoiceLimitations)

```
Please reformat your text
```

SAPI4 returned an error while synthesizing speech,
or exceeded the 10 second timeout to complete speech synthesis.
