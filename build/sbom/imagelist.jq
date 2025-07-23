.[]
|select(.Repository|startswith("tao/"))
|select(.Tag=="latest")
|("containerd:" + .Repository + ":" +.Tag)