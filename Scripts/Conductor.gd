extends Node

var audioPlayer : AudioStreamPlayer

var beatFilePath : String

var SECONDS_PER_MIN : float = 60

var bpm : int
var crotchet : float
var offset : float

var beats : Array
var leftEnabled : Array
var rightEnabled : Array
var percentEnabled : Array

var beatNumber : int
var enabledBeats : Array[bool] = []

signal onBeat

# Because this is dumb they dont have ScheduledPlay, so can't do segmented audio. Very annoying

# Called when the node enters the scene tree for the first time.
func init(aud : AudioStreamPlayer, beatFile : String):
	audioPlayer = aud
	beatFilePath = beatFile
	
	beats = []
	leftEnabled = []
	rightEnabled = []
	
	var file = FileAccess.open(beatFilePath, FileAccess.READ)
	var content = file.get_as_text()
	preprocessing(content)
	
	for i in beats.size():
		enabledBeats.append(false)
		percentEnabled.append(0)
	beatNumber = 0
	lastBeatPosition = 0
	
	
func preprocessing(content):
	bpm = int(content.split(",")[0])
	crotchet = SECONDS_PER_MIN / bpm
	offset = float(content.split(",")[1].split("\n")[0])
	print("Bpm is: ", bpm, ", Offset is: ", offset)
	
	read_beats(content)
	get_left_enabled()
	get_right_enabled()

func read_beats(content):
	for line in content.split("\n").slice(1, -1):
		var arr = []
		for i in line:
			arr.append(bool(int(i)))
		beats.append(arr)

func get_left_enabled():
	var lastEnabled : int
	var beat : int
	for ind in beats:
		var arr = []
		lastEnabled = 0
		for beatInd in ind.size():
			beat = ind[beatInd]
			if(beat): 
				lastEnabled = beatInd
			arr.append(lastEnabled)
		leftEnabled.append(arr)

func get_right_enabled():
	var lastEnabled : int
	var beat : int
	for ind in beats:
		var arr = []
		lastEnabled = len(ind)
		for beatInd in range(ind.size()-1, 0, -1):
			beat = ind[beatInd]
			if(beat): lastEnabled = beatInd
			arr.append(lastEnabled)
		arr.reverse()
		rightEnabled.append(arr)
		
func get_percentage_enabled():
	var last : float
	var next : float
	
	for i in beats.size():
		last = BeatToTime(leftEnabled[i][beatNumber])
		next = BeatToTime(rightEnabled[i][min(beatNumber, len(rightEnabled[i])-1)])
		
		if last >= next: 
			percentEnabled[i] = 1
		else: 
			percentEnabled[i] = (songPosition - last) / (next - last)
		
	
func percentage_enabled(mapIndex : int) -> float:
	return percentEnabled[mapIndex]

func timeToNextEnabled(mapIndex : int) -> float:
	var next : float = BeatToTime(rightEnabled[mapIndex][beatNumber])
	return next - songPosition

func BeatToTime(beat : int) -> float:
	return beat * crotchet

func TimeToBeat(time : float) -> int:
	return floor(time / crotchet)



var songPosition : float
var lastBeatPosition : float = 0 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	songPosition = audioPlayer.get_playback_position() - offset
	if songPosition > lastBeatPosition + crotchet:
		beatNumber += 1
		lastBeatPosition += crotchet
		for i in beats.size():
			enabledBeats[i] = beats[i][beatNumber]
		emit_signal("onBeat" , enabledBeats, beatNumber)
		
		
		
	get_percentage_enabled()

func next_song():
	stop()
	play()

func play():
	audioPlayer.play()
	
func stop():
	audioPlayer.stop()
	beatNumber = 0
	lastBeatPosition = 0
