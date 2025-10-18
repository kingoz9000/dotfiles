#!/usr/bin/env python3
import argparse
import requests
from dotenv import load_dotenv
import os


class Notification:
    def __init__(self, args, user_key=None, app_token=None):
        self.title = args.title
        self.message = args.message
        self.user_key = user_key
        self.app_token = app_token
        self.stamp = "Sent from Thiccpad"
        self.device = args.device
        if args.url:
            self.url = args.url
            self.message = "Link " + self.stamp
        elif args.image:
            self.url = None
            self.image = args.image
            self.message = "Image " + self.stamp
        else:
            self.url = None
            self.message += "\n" + self.stamp

    def send_pushover_notification(self):
        url = "https://api.pushover.net/1/messages.json"
        data = {
            "token": self.app_token,
            "user": self.user_key,
            "title": self.title,
            "message": self.message,
            "device": self.device,
        }
        if self.url:
            data["url"] = self.url
            data["url_title"] = "Open URL"

        files = None  # default

        if hasattr(self, "image"):
            try:
                files = {"attachment": open(self.image, "rb")}
            except FileNotFoundError:
                print(f"Image file not found: {self.image}")
                return

        response = requests.post(url, data=data, files=files)
        if response.status_code == 200:
            print("Notification sent successfully!")
        else:
            print("Failed to send notification:", response.text)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send a notification")
    parser.add_argument(
        "-t", "--title", type=str, required=True, help="Title of the notification"
    )
    parser.add_argument(
        "-m", "--message", type=str, required=False, help="Message of the notification"
    )
    parser.add_argument("-u", "--url", type=str, required=False, help="URL to open")
    parser.add_argument("-d", "--device", type=str, required=False, help="Device name")
    parser.add_argument("-i", "--image", type=str, required=False, help="Image to send")

    load_dotenv()
    args = parser.parse_args()
    notification = Notification(args, os.getenv("PUSHOVER_USER_KEY"), os.getenv("PUSHOVER_APP_TOKEN"))
    notification.send_pushover_notification()
