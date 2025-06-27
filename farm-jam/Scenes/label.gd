extends Label
func _process(delta):
    self.text = "Goverment Credits: " + str(Global.money)