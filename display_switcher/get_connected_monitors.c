#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "get_connected_monitors.h"

MonitorList get_connected_monitors(void) {
    MonitorList list = {0};
    FILE *fp = popen("hyprctl monitors -j", "r");
    if (!fp) {
        perror("popen failed");
        return list;
    }

    char buffer[65536] = {0}; // Large enough for the full output
    fread(buffer, 1, sizeof(buffer) - 1, fp);
    pclose(fp);

    cJSON *monitors = cJSON_Parse(buffer);
    if (!monitors || !cJSON_IsArray(monitors)) {
        fprintf(stderr, "Failed to parse JSON.\n");
        return list;
    }

    int index = 0;
    cJSON *item;
    cJSON_ArrayForEach(item, monitors) {
        if (index >= MAX_MONITORS) break;
        MonitorInfo *m = &list.monitors[index++];

        #define SET_STR(field, key) do { \
            cJSON *f = cJSON_GetObjectItemCaseSensitive(item, key); \
            if (cJSON_IsString(f)) strncpy(m->field, f->valuestring, sizeof(m->field) - 1); \
        } while(0)

        m->id = cJSON_GetObjectItem(item, "id")->valueint;
        SET_STR(name, "name");
        SET_STR(description, "description");
        SET_STR(make, "make");
        SET_STR(model, "model");
        SET_STR(serial, "serial");
        m->width = cJSON_GetObjectItem(item, "width")->valueint;
        m->height = cJSON_GetObjectItem(item, "height")->valueint;
        m->refresh_rate = (float)cJSON_GetObjectItem(item, "refreshRate")->valuedouble;
        m->x = cJSON_GetObjectItem(item, "x")->valueint;
        m->y = cJSON_GetObjectItem(item, "y")->valueint;
        m->scale = (float)cJSON_GetObjectItem(item, "scale")->valuedouble;
        m->transform = cJSON_GetObjectItem(item, "transform")->valueint;
        m->focused = cJSON_IsTrue(cJSON_GetObjectItem(item, "focused"));
        m->dpmsStatus = cJSON_IsTrue(cJSON_GetObjectItem(item, "dpmsStatus"));
        m->vrr = cJSON_IsTrue(cJSON_GetObjectItem(item, "vrr"));
        m->activelyTearing = cJSON_IsTrue(cJSON_GetObjectItem(item, "activelyTearing"));
        m->disabled = cJSON_IsTrue(cJSON_GetObjectItem(item, "disabled"));
        m->solitary = atoi(cJSON_GetObjectItem(item, "solitary")->valuestring);
        SET_STR(directScanoutTo, "directScanoutTo");
        SET_STR(currentFormat, "currentFormat");
        SET_STR(mirrorOf, "mirrorOf");

        // Workspaces
        cJSON *ws = cJSON_GetObjectItem(item, "activeWorkspace");
        if (cJSON_IsObject(ws)) {
            m->active_workspace.id = cJSON_GetObjectItem(ws, "id")->valueint;
            SET_STR(active_workspace.name, "name");
        }

        ws = cJSON_GetObjectItem(item, "specialWorkspace");
        if (cJSON_IsObject(ws)) {
            m->special_workspace.id = cJSON_GetObjectItem(ws, "id")->valueint;
            SET_STR(special_workspace.name, "name");
        }

        // Reserved array
        cJSON *reserved = cJSON_GetObjectItem(item, "reserved");
        if (cJSON_IsArray(reserved)) {
            for (int i = 0; i < 4 && i < cJSON_GetArraySize(reserved); i++) {
                m->reserved[i] = cJSON_GetArrayItem(reserved, i)->valueint;
            }
        }

        // Available modes
        cJSON *modes = cJSON_GetObjectItem(item, "availableModes");
        if (cJSON_IsArray(modes)) {
            int count = 0;
            cJSON *mode;
            cJSON_ArrayForEach(mode, modes) {
                if (count >= MAX_MODES) break;
                if (cJSON_IsString(mode)) {
                    strncpy(m->availableModes[count++], mode->valuestring, MAX_NAME_LEN - 1);
                }
            }
            m->mode_count = count;
        }

        #undef SET_STR
    }

    list.count = index;
    return list;
}

