from pyamaha import Device, System, NetUSB


def find_index(body, text):
    for index, info in enumerate(body["list_info"]):
        if info["text"] == text:
            return index

    return -1


def play_album(dev, artist, album):
    res = dev.request(
        NetUSB.get_list_info(input="server", list_id="main", size=8, lang="en", index=0)
    )
    body = res.json()
    menu = body["menu_name"]

    action = "select"
    index = 0

    if menu == "SERVER":
        index = find_index(body, "raspberrypi: minidlna")
    elif menu == "raspberrypi: minidlna":
        index = find_index(body, "Music")
    elif menu == "Music":
        index = find_index(body, "Artist")
    elif menu == "Artist":
        index = find_index(body, artist)
    elif menu == artist:
        index = find_index(body, album)
    elif menu == album:
        action = "play"
    else:  # Not correct directory, moving up
        action = "return"

    res = dev.request(
        NetUSB.set_list_control(type=action, list_id="main", zone="main", index=index)
    )
    body = res.json()
    assert body["response_code"] == 0
    if action == "play":
        return

    play_album(dev, artist, album)


def main():
    dev = Device("10.0.0.2")
    # play_album(dev, "catbeats", "Moss Magic")
    play_album(dev, "catbeats", "night chill")


main()
