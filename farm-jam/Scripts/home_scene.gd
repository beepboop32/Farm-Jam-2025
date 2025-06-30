extends Node2D
@export var fadeDuration = 0.75

var dayNewsReports = [
	"...Tonight, we receive reports from leading pharmaceutical companies that the cure has passed clinical trials and will be prepared for distribution in just 5 days. Upon delivery of the drug, we expect that crops will start to recover within the following months. Most locations still have access to enough food and resources to see them through, but we urge those without this privilege to contact the number shown on the screen for assistance. Please note resources will be taken out on a loan, and you are expected to pay the full amount back to the supplier after this crisis has passed. The current death toll is at -3*£&*$6(2-. A mass memorial service will be broadcasted worldwide to pay respects to those lost to this apocalypse within the coming weeks.",
	"The cure has begun shipment and is expected to arrive within the next few days. We have exceeded our target for successful development of the drug, which is good news for those without self-sufficiency. Supermarkets are expected to be restocked with inorganic material within the coming weeks. The memorial service planning has begun, though it will be carried out with minimum resources. A higher level of commemoration and services will occur in the future, to give victims the remembrance they deserve. In other news, the world-champion footballer £%6738-.2 has been found dead in his home from malnourishment.",
	"The time is 9:00pm. Tonight, we look at the impact the apocalypse has had on the remaining survivor's mental health. From depression to psychosis, a range of problems have arisen from the stress and physical impacts of malnourishment on a large percentage of the world. This is Grace’s story: [---] While this may seem dark, hope is still present. The cure has begun deployment to more remote areas, to those with the least resources available, including those who resorted to cannibalism. We urge viewers to hold on just a few more days- and the post-apocalypse resources can be deployed once the crops are growing, and animals are being born.",
	"We have received news that the cure’s distribution has been unexpectedly stopped. To our international reporter: I am reporting from outside the lab that once contained the vaccinations. Scientists lay in rest beyond the walls, victim to a gas leak. In this troubled time, we encourage the community to keep going- for a solution is being invested into to improve the quality of life of the public.  ",
	"We understand that this is a very difficult time, for everyone. Organisations worldwide are extending their sympathies to those families who have lost their lives during this crisis. More have been victim to suicide, stealing, and other crimes. A mass funeral will be broadcasted across our networks shortly. Unfortunately, there is no happy ending in sight, so we encourage you to all enjoy and value your lives whilst you are lucky enough to have them.",
	"Tonight’s broadcast comes with a heavy heart. We can now confirm that all remaining stock of the cure has been destroyed following a coordinated assault on the final manufacturing facility. While no group has claimed responsibility, speculation points to anti-survivor extremists. Governments urge unity. But with supplies dwindling and trust eroding, many are asking, is there anything left to save?",
	"As the temperature continues to drop, makeshift shelters are appearing across suburban zones. The Ministry of Continuity has released a statement urging citizens not to panic, though their helpline has reportedly been offline for over 24 hours. The moon appeared red last night, a result of ash clouds still circulating in the upper atmosphere. Spiritual groups call it an omen. Scientists call it particulate saturation. Either way, it’s getting harder to breathe.",
	"Emergency transmissions intercepted today indicate small, isolated communities are beginning to thrive in agricultural domes. However, their coordinates remain encrypted and trade is off-limits to outsiders. Meanwhile, a new disease has begun to spread among urban survivors, one not caused by the apocalypse, but by desperation: water-borne infections, parasites, and aggressive fungal blooms. Health officials advise boiling water and avoiding stagnant pools, though few have the means to do either.",
	"We are now seeing widespread rejection of centralized government authority. Civilian militias are taking control of resource zones. In one city, a food drop was set alight in protest. A single crate was found painted with a message: ‘There is no cure for what we are becoming.’ Reports of hallucinations, memory loss, and erratic aggression continue to rise. Whether this is psychological trauma or something more, no one can say for sure.",
	"Tonight, there will be no broadcast. This is the final automated message from the Global Emergency Network. You are not alone. You were never alone. Survive, not for the world, but for yourself. Static."
]

func _process(delta: float) -> void:
	if !DialogBox.exists:
		$ButtonLayer.visible = true

func _ready() -> void:
	Global.home = true
	var color = $CanvasModulate.color
	color.a = 0.0
	$CanvasModulate.color = color
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(color.r, color.g, color.b, 1.0), fadeDuration)
	if Global.currentDay <= len(dayNewsReports):
		DialogBox.show_dialog("Breaking News:\n%s" % dayNewsReports[Global.currentDay - 1])
	else:
		DialogBox.show_dialog("Breaking News:\n?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????")

func _on_button_pressed() -> void:
	Global.timeSpeedMultiplier = 1.0
	Global.totalMinutes = 6*60
	if Global.queueEnding:
		get_tree().change_scene_to_file("res://Scenes/BaseEndScene.tscn")
		return
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")

func _on_lamp_switch_pressed() -> void:
	$"Lamp Light".visible = !$"Lamp Light".visible
	if $"Lamp Light".visible:
		$CanvasModulate.color = Color(0.325, 0.325, 0.325)
	else:
		$CanvasModulate.color = Color(0.144, 0.144, 0.144)

func _on_shop_button_pressed() -> void:
	$"ButtonLayer/Shop Panel".visible = !$"ButtonLayer/Shop Panel".visible
