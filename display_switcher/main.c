#include "get_connected_monitors.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int send_notify(const char *title, const char *message) {
  char cmd[256];
  snprintf(cmd, sizeof(cmd), "notify-send '%s' '%s'", title, message);
  return system(cmd);
}

int stop_waybar() { return system("pkill waybar"); }
int start_waybar() { return system("waybar &"); }

int send_hyprctl_command(const char *command) {
  FILE *fp = popen(command, "r");
  if (!fp) {
    perror("popen failed");
    return -1;
  }

  char buffer[256];
  int success = 0;

  while (fgets(buffer, sizeof(buffer), fp)) {
    buffer[strcspn(buffer, "\n")] = 0; // Strip newline
    if (strcmp(buffer, "ok") == 0) {
      success = 1;
    }
    // Optional: printf("Command output: %s\n", buffer);
  }

  pclose(fp);
  return success ? 0 : -1;
}

static int do_only_external(const MonitorInfo *internal,
                            const MonitorInfo *external) {
  stop_waybar();
  char cmd[256];
  char msg[256];
  snprintf(cmd, sizeof(cmd), "hyprctl keyword monitor %s, disable",
           internal->name);
  int rc = send_hyprctl_command(cmd);
  if (rc != 0) {
    snprintf(msg, sizeof(msg), "Failed to do only '%s' ", external->name);
    send_notify("Monitor Setup", msg);
  } else {
    snprintf(msg, sizeof(msg), "Did only '%s' ", external->name);
    send_notify("Monitor Setup", msg);
  }
  start_waybar();
  return rc;
}

static int do_mirror(const MonitorInfo *internal, const MonitorInfo *external) {
  stop_waybar();
  char cmd[256];
  char msg[256];
  snprintf(cmd, sizeof(cmd),
           "hyprctl keyword monitor %s,preferred,auto,1,mirror,%s",
           internal->name, external->name);
  int rc = system(cmd);
  snprintf(msg, sizeof(msg), "Mirrored '%s'", external->name);
  send_notify("Monitor Setup", msg);
  start_waybar();
  return rc;
}

static int do_extend_right(const MonitorInfo *internal,
                           const MonitorInfo *external) {
  stop_waybar();
  char cmd[256];
  char msg[256];
  send_hyprctl_command(cmd);
  snprintf(cmd, sizeof(cmd),
           "hyprctl keyword monitor %s,preferred,0x0,%f && "
           "hyprctl keyword monitor %s,preferred,%dx0,%f",
           internal->name, internal->scale, external->name, internal->width,
           external->scale);
  int rc = send_hyprctl_command(cmd);
  if (rc != 0) {
    snprintf(msg, sizeof(msg), "Failed to extend '%s' Right", external->name);
    send_notify("Monitor Setup", msg);
  } else {
    snprintf(msg, sizeof(msg), "Extended '%s' Right", external->name);
    send_notify("Monitor Setup", msg);
  }
  start_waybar();
  return rc;
}

static int do_extend_left(const MonitorInfo *internal,
                          const MonitorInfo *external) {
  stop_waybar();
  char cmd[256];
  char msg[256];
  snprintf(cmd, sizeof(cmd), "hyprctl dispatch dpms on %s", external->name);
  send_hyprctl_command(cmd);
  snprintf(cmd, sizeof(cmd),
           "hyprctl keyword monitor %s,preferred,0x0,%f && "
           "hyprctl keyword monitor %s,preferred,-%dx0,%f",
           internal->name, internal->scale, external->name, external->width,
           external->scale);
  int rc = send_hyprctl_command(cmd);
  if (rc != 0) {
    snprintf(msg, sizeof(msg), "Failed to extend '%s' Left", external->name);
    send_notify("Monitor Setup", msg);
  } else {
    snprintf(msg, sizeof(msg), "Extended '%s' Left", external->name);
    send_notify("Monitor Setup", msg);
  }
  start_waybar();
  return rc;
}

static int do_extend_above(const MonitorInfo *internal,
                           const MonitorInfo *external) {
  stop_waybar();
  char cmd[256];
  char msg[256];
  snprintf(cmd, sizeof(cmd), "hyprctl dispatch dpms on %s", external->name);
  send_hyprctl_command(cmd);

  int internalWidthMargin = (int)llround(
      (external->width / external->scale - internal->width / internal->scale) /
      2.0);

  int externalLogicalHeight = (int)llround(external->height / external->scale);

  snprintf(cmd, sizeof(cmd),
           "hyprctl keyword monitor %s,preferred,0x-%d,%.2f && "
           "hyprctl keyword monitor %s,preferred,%dx0,%.2f",
           external->name, externalLogicalHeight, external->scale,
           internal->name, internalWidthMargin, internal->scale);
  printf("Command: %s\n", cmd);

  int rc = send_hyprctl_command(cmd);
  if (rc != 0) {
    snprintf(msg, sizeof(msg), "Failed to extend '%s' Above", external->name);
    send_notify("Monitor Setup", msg);
  } else {
    snprintf(msg, sizeof(msg), "Extended '%s' Above", external->name);
    send_notify("Monitor Setup", msg);
  }
  start_waybar();
  return rc;
}

static int do_only_internal(const MonitorInfo *internal,
                            const MonitorInfo *external) {
  stop_waybar();
  char cmd[256];
  char msg[256];
  snprintf(cmd, sizeof(cmd),
           "hyprctl keyword monitor %s,preferred,0x0,%f && "
           "hyprctl keyword monitor %s, disable",
           internal->name, internal->scale, external->name);
  int rc = send_hyprctl_command(cmd);
  if (rc != 0) {
    snprintf(msg, sizeof(msg), "Failed to do only '%s' ", internal->name);
    send_notify("Monitor Setup", msg);
  } else {
    snprintf(msg, sizeof(msg), "Did only '%s' ", internal->name);
    send_notify("Monitor Setup", msg);
  }
  start_waybar();
  return rc;
}

static int do_set_scale(const MonitorInfo *external) {
  /* Ask for a scale via wofi */
  FILE *sf = popen("echo -e \"1x\n1.25x\n1.5x\n2x\" | wofi --dmenu", "r");
  if (!sf) {
    perror("popen failed");
    system("notify-send 'Monitor Setup' 'Failed to open scale menu'");
    return 1;
  }

  char sel[16] = {0};
  if (!fgets(sel, sizeof(sel), sf)) {
    pclose(sf);
    system("notify-send 'Monitor Setup' 'No scale selected'");
    return 1;
  }
  pclose(sf);
  sel[strcspn(sel, "\n")] = '\0';

  /* Accept "1.25x" or "1.25" */
  char *endp = NULL;
  float scale = strtof(sel, &endp);
  if (endp && *endp == 'x') { /* ok: trailing x */
  }

  if (!(scale >= 0.5f && scale <= 5.0f)) {
    system("notify-send 'Monitor Setup' 'Invalid scale selected'");
    return 1;
  }

  /* Preserve current resolution and position; only change scale */
  char res[64];
  if (external->refresh_rate > 0.0f) {
    snprintf(res, sizeof(res), "%dx%d@%d", external->width, external->height,
             (int)(external->refresh_rate + 0.5f));
  } else {
    snprintf(res, sizeof(res), "%dx%d", external->width, external->height);
  }

  char pos[64];
  snprintf(pos, sizeof(pos), "%dx%d", external->x, external->y);

  char cmd[256];
  snprintf(cmd, sizeof(cmd), "hyprctl keyword monitor %s,%s,%s,%.2f",
           external->name, res, pos, scale);

  int rc = send_hyprctl_command(cmd);
  system(rc == 0 ? "notify-send 'Monitor Setup' 'Scale set'"
                 : "notify-send 'Monitor Setup' 'Failed to set scale '");
  system("pkill hyprpaper && hyprpaper &");
  return rc;
}

int main() {
  MonitorList list = get_connected_monitors();

  if (list.count < 2) {
    send_hyprctl_command("hyprctl keyword monitor eDP-1,preferred,0x0,1");
    send_hyprctl_command("hyprctl keyword monitor HDMI-A-1,preferred,0x0,1");
    send_hyprctl_command("hyprctl keyword monitor DP-6,preferred,0x0,1");

    list = get_connected_monitors();
    if (list.count < 2) {
      send_notify("No external monitor connected",
                  "Please connect an external monitor.");
      return 0;
    }
  }

  if (strcmp(list.monitors[0].name, "eDP-1") == 0) {
  } else {
    MonitorInfo temp = list.monitors[0];
    list.monitors[0] = list.monitors[1];
    list.monitors[1] = temp;
  }
  send_hyprctl_command("hyprctl dispatch dpms on eDP-1");

  FILE *fp = popen(
      "echo -e \"󰍺 Mirror\n󰁔Extend Right\n󰁍Extend Left\n󰁝Extend "
      "Above\n󰶐 Only Internal\n󰍺 Only External\n Set Scale\" | wofi "
      "--dmenu",
      "r");
  if (!fp) {
    perror("popen failed");
    return 1;
  }

  char selection[64];
  char command[256];
  if (fgets(selection, sizeof(selection), fp)) {
    // Remove trailing newline
    selection[strcspn(selection, "\n")] = '\0';

    if (strcmp(selection, "󰍺 Mirror") == 0) {
      return do_mirror(&list.monitors[0], &list.monitors[1]);

    } else if (strcmp(selection, "󰁔Extend Right") == 0) {
      return do_extend_right(&list.monitors[0], &list.monitors[1]);

    } else if (strcmp(selection, "󰁍Extend Left") == 0) {
      return do_extend_left(&list.monitors[0], &list.monitors[1]);

    } else if (strcmp(selection, "󰁝Extend Above") == 0) {
      return do_extend_above(&list.monitors[0], &list.monitors[1]);

    } else if (strcmp(selection, "󰶐 Only Internal") == 0) {
      return do_only_internal(&list.monitors[0], &list.monitors[1]);

    } else if (strcmp(selection, " Set Scale") == 0) {
      return do_set_scale(&list.monitors[1]);

    } else if (strcmp(selection, "󰍺 Only External") == 0) {
      return do_only_external(&list.monitors[0], &list.monitors[1]);

    } else {
      system("notify-send 'Monitor Setup' 'Unknown selection'");
      return 1;
    }
  }
}
